Class {
	#name : #SGAEngine,
	#superclass : #SGAObject,
	#instVars : [
		'populationSize',
		'mutationOperator',
		'compareFitness',
		'crossoverOperator',
		'selection',
		'numberOfStatements',
		'population',
		'terminationBlock',
		'logs',
		'blockToExecute',
		'typeInfo',
		'fitness',
		'numberOfGenerations',
		'testRunner',
		'targetClassName'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
SGAEngine >> beforeRun [
	self checkIfReadyToRun.
	selection fitness: fitness.
	selection populationSize: populationSize.
	selection random: random
]

{ #category : #accessing }
SGAEngine >> blockToExecute [
	^ blockToExecute
]

{ #category : #accessing }
SGAEngine >> blockToExecute: aBlock [
	blockToExecute := aBlock
]

{ #category : #testing }
SGAEngine >> checkBaseClassName [
	self
		assert: [ targetClassName notNil and: [ typeInfo types includesKey: targetClassName ] ]
		description: 'Need to set the base class name and it must be exist in the typeInfo'
]

{ #category : #testing }
SGAEngine >> checkBlockToExecute [
	self
		assert: [ blockToExecute notNil ]
		description: 'Need to set the block to analyze'
]

{ #category : #testing }
SGAEngine >> checkFitness [
	self
		assert: [ fitness notNil ]
		description: 'Need to set a fitnessBlock'
]

{ #category : #testing }
SGAEngine >> checkIfReadyToRun [
	self checkBlockToExecute.
	self checkTypeInfo.
	self checkFitness.
	self checkBaseClassName.
	self checkLogs
]

{ #category : #testing }
SGAEngine >> checkLogs [
	self assert: [ logs isEmpty ] description: 'Already been run'
]

{ #category : #testing }
SGAEngine >> checkTypeInfo [
	self
		assert: [ typeInfo notNil ]
		description: 'Set a typeInfo'
]

{ #category : #accessing }
SGAEngine >> clean [
	fitness ifNotNil: [ fitness clean ]
]

{ #category : #'as yet unclassified' }
SGAEngine >> crossover: testCaseA with: testCaseB [
	^ crossoverOperator crossover: testCaseA with: testCaseB
]

{ #category : #accessing }
SGAEngine >> crossoverOperator: aCrossoverOperator [
	crossoverOperator := aCrossoverOperator.
	crossoverOperator random: random
]

{ #category : #'as yet unclassified' }
SGAEngine >> endForMaxNumberOfGeneration: nbOfGenerations [
	"End the algorithm after a fixed number of generations"
	numberOfGenerations := nbOfGenerations.
	terminationBlock := [ logs last generationNumber >= nbOfGenerations ]
]

{ #category : #accessing }
SGAEngine >> fitness [
	^ fitness
]

{ #category : #accessing }
SGAEngine >> fitness: aFitness [
	fitness := aFitness
]

{ #category : #'as yet unclassified' }
SGAEngine >> generateAssertions: classAssertions on: aClass [
	self
		assert: logs isNotEmpty
		description: 'In this point the logs must not be empty'.
	self population
		doWithIndex: [ :test :index | 
			test generateAssertions: classAssertions.
			testRunner
				compile: test parseTreeWithAssertions
				withName: ('test' , index asString) asSymbol
				on: aClass ]
]

{ #category : #initialization }
SGAEngine >> initialize [
	super initialize.
	logs := OrderedCollection new.
	random := Random new.
	self endForMaxNumberOfGeneration: 10.
	populationSize := 100.
	self maximizeComparator.
	self initializeMutationOperator.
	self initializeCrossoverOperator.
	self selection: SGATournamentSelection new.
	testRunner := SSTestRunner new.
	numberOfGenerations := 0
]

{ #category : #initialization }
SGAEngine >> initializeCrossoverOperator [
	crossoverOperator := SGACrossoverOperation new.
	crossoverOperator random: random.
]

{ #category : #initialization }
SGAEngine >> initializeMutationOperator [
	mutationOperator := SGAMutationOperation new.
	mutationOperator mutationRate: (1 / 3) asFloat.
	mutationOperator random: random.
]

{ #category : #initialization }
SGAEngine >> initializePopulation [
	population := self randomlyGeneratedPopulation
]

{ #category : #testing }
SGAEngine >> isTestCase: aTestCase betterThan: aFittestTestCase [
	"Compare an testCase against the fittest testCase of the population"

	^ compareFitness
		value: aTestCase
		value: aFittestTestCase
]

{ #category : #running }
SGAEngine >> logWithGenerationNumber: gen atTime: t [
	| log |
	log := SGALog new.
	log generationNumber: gen.
	log fittestTestCase: selection fittest.
	log timeToProduceGeneration: Time now asSeconds - t.
	^ log
]

{ #category : #accessing }
SGAEngine >> logs [
	^ logs copy
]

{ #category : #'as yet unclassified' }
SGAEngine >> maximizeComparator [
	"change by statementCoverage or methodCoverage"

	compareFitness := [ :tC1 :tC2 |  fitness is: tC1 betterThan: tC2 ]
]

{ #category : #'as yet unclassified' }
SGAEngine >> microPause [
    "Useful when you wish to log in the Transcript and see progresses"
    (Delay forMilliseconds: 1) wait.
    World doOneCycleNow.
]

{ #category : #'as yet unclassified' }
SGAEngine >> mutate: testCase [
	^ mutationOperator mutate: testCase
]

{ #category : #accessing }
SGAEngine >> mutationRate: aFloat [
	mutationOperator mutationRate: aFloat
]

{ #category : #accessing }
SGAEngine >> numberOfStatements [
	^ numberOfStatements
]

{ #category : #accessing }
SGAEngine >> numberOfStatements: aInt [
	numberOfStatements := aInt
]

{ #category : #accessing }
SGAEngine >> population [
	^ population
]

{ #category : #accessing }
SGAEngine >> populationSize [ 	
	^ populationSize 
]

{ #category : #accessing }
SGAEngine >> populationSize: aInteger [
	populationSize := aInteger
]

{ #category : #'as yet unclassified' }
SGAEngine >> produceNewPopulation [
	selection doSelection.
	population := selection population.
]

{ #category : #initialization }
SGAEngine >> randomlyGeneratedPopulation [
	| collection |
	collection := OrderedCollection new.
	populationSize
		timesRepeat: [ collection
				add:
					(SSTestCase new
						typeInfo: typeInfo;
						numMaxStatements: numberOfStatements;
						addTargetClassName: targetClassName;
						validateTargetClasses: true;
						generateStatements) ].
	^ collection
]

{ #category : #running }
SGAEngine >> run [
	| t |
	self beforeRun.
	self initializePopulation.
	selection initialPopulation: population.
	selection compareFitness: compareFitness.
	UIManager default
		informUserDuring: [ :bar | 
			| gen |
			gen := 0.
			[ self shouldTerminate ]
				whileFalse: [
					gen := gen + 1.
					bar label: 'Iteration: ' , gen asString.
					self microPause.
					t := Time now asSeconds.
					self produceNewPopulation.
					logs add: (self logWithGenerationNumber: gen atTime: t).
					bar
						current: ((gen / numberOfGenerations) asFloat * 100) asInteger ] ]
]

{ #category : #accessing }
SGAEngine >> selection [
	^ selection
]

{ #category : #accessing }
SGAEngine >> selection: aSelection [
	selection := aSelection.
	aSelection engine: self.
	
]

{ #category : #asserting }
SGAEngine >> shouldTerminate [
	logs ifEmpty: [ ^ false ].
	^ terminationBlock value
]

{ #category : #accessing }
SGAEngine >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
SGAEngine >> targetClassName: symbol [
	targetClassName := symbol
]

{ #category : #accessing }
SGAEngine >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SGAEngine >> typeInfo: aTypeInfo [
	self checkBlockToExecute.
	typeInfo := aTypeInfo
]
