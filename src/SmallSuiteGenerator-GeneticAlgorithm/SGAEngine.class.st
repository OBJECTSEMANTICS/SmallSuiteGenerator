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
		'modelClasses',
		'testClasses',
		'operators',
		'evaluationStrategy',
		'typeInfo',
		'fitness'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #actions }
SGAEngine >> analyzeMutants [
	| analysis |
	self
		assert: (modelClasses isNotNil and: [ modelClasses isNotEmpty ])
		description: 'modelClasses must not be nil or empty'.
	analysis := MutationTestingAnalysis
		testCasesFrom: self validTestClasses
		mutating: modelClasses
		using: self validOperators
		with:
			(evaluationStrategy
				ifNil: [ SConfiguration defaultEvaluationStrategy ]).
	analysis run.
	^ analysis generalResult
]

{ #category : #preconditions }
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

{ #category : #preconditions }
SGAEngine >> checkBlockToExecute [
	self
		assert: [ blockToExecute notNil ]
		description: 'Need to set the block to analyze'
]

{ #category : #preconditions }
SGAEngine >> checkFitness [
	self
		assert: [ fitness notNil ]
		description: 'Need to set a fitnessBlock'
]

{ #category : #preconditions }
SGAEngine >> checkIfReadyToRun [
	self checkBlockToExecute.
	self checkTypeInfo.
	self checkFitness.
	self checkLogs
]

{ #category : #preconditions }
SGAEngine >> checkLogs [
	self assert: [ logs isEmpty ] description: 'Already been run'
]

{ #category : #preconditions }
SGAEngine >> checkTypeInfo [
	self
		assert: [ typeInfo notNil ]
		description: 'Set a typeInfo'
]

{ #category : #actions }
SGAEngine >> crossover: testCaseA with: testCaseB [
	^ crossoverOperator crossover: testCaseA with: testCaseB
]

{ #category : #accessing }
SGAEngine >> crossoverOperator: aCrossoverOperator [
	crossoverOperator := aCrossoverOperator.
	crossoverOperator random: random
]

{ #category : #accessing }
SGAEngine >> endForMaxNumberOfGeneration: nbOfGenerations [
    "End the algorithm after a fixed number of generations"
    terminationBlock := [ logs last generationNumber >= nbOfGenerations ]
]

{ #category : #accessing }
SGAEngine >> evaluationStrategy: aEvaluationStrategy [
	evaluationStrategy := aEvaluationStrategy 
]

{ #category : #accessing }
SGAEngine >> fitness [
	^ fitness
]

{ #category : #accessing }
SGAEngine >> fitness: aFitness [
	fitness := aFitness
]

{ #category : #actions }
SGAEngine >> generateAssertionsUsing: selectedInvariants [
	self
		assert: logs isNotEmpty
		description: 'In this point the logs must not be empty'.
	self logs
		do: [ :log | 
			log fittestTestCase generateAssertionsUsing: selectedInvariants.
			"log mutationResult: self analyzeMutants" ]
]

{ #category : #actions }
SGAEngine >> generateAssertionsUsing: selectedInvariants invariantsAndApplyPrettyCodeWith: kindsRefactoring [
	self
		assert: logs isNotEmpty
		description: 'In this point the logs must not be empty'.
	self logs
		do: [ :log | 
			"log fittestTestCase prettyCodeApplying: kindsRefactoring."
			log fittestTestCase generateAssertionsUsing: selectedInvariants.
			"log mutationResult: self analyzeMutants" ]
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
	modelClasses := #()
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
	population := OrderedCollection new.
	populationSize
		timesRepeat: [ population
				add:
					(SSTestCase new
						typeInfo: typeInfo;
						numMaxStatements: numberOfStatements;
						generateStatements) ]
]

{ #category : #testing }
SGAEngine >> isTestCase: aTestCase betterThan: aFittestTestCase [
	"Compare an testCase against the fittest testCase of the population"
	^ compareFitness value: aTestCase fitness value: aFittestTestCase fitness
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

{ #category : #accessing }
SGAEngine >> maximizeComparator [
	"change by statementCoverage or methodCoverage"

	compareFitness := [ :f1 :f2 | f1  > f2 ]
]

{ #category : #actions }
SGAEngine >> microPause [
    "Useful when you wish to log in the Transcript and see progresses"
    (Delay forMilliseconds: 1) wait.
    World doOneCycleNow.
]

{ #category : #accessing }
SGAEngine >> modelClasses: classes [
	self assert: (classes isNotNil and: [ classes isNotEmpty ]) description: 'The classes must not be nil or empty'.
	modelClasses := classes
]

{ #category : #accessing }
SGAEngine >> mutantOperators: mutantOperators [
	operators := mutantOperators 
]

{ #category : #actions }
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

{ #category : #actions }
SGAEngine >> produceNewPopulation [
	selection doSelection.
	population := selection population.
]

{ #category : #accessing }
SGAEngine >> result [ 
	^ self logs last fittestTestCase statements
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
					bar label: gen asString.
					self microPause.
					t := Time now asSeconds.
					self produceNewPopulation.
					logs add: (self logWithGenerationNumber: gen atTime: t) ].
				"coverageProfiler cleanInstrumentation" ]
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

{ #category : #preconditions }
SGAEngine >> shouldTerminate [
	logs ifEmpty: [ ^ false ].
	^ terminationBlock value
]

{ #category : #accessing }
SGAEngine >> testClasses: testCaseClasses [
	testClasses := testCaseClasses 
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

{ #category : #querying }
SGAEngine >> valid: aCollection
		ifNotValid: aBlock [
		^ (aCollection isNil or: [ aCollection isEmpty ]) ifFalse: [aCollection]
		ifTrue: [ aBlock value ]
]

{ #category : #querying }
SGAEngine >> validOperators [
	^ self
				valid: operators
				ifNotValid: [ SConfiguration defaultMutantOperators ]
]

{ #category : #querying }
SGAEngine >> validTestClasses [
	^ self valid: testClasses ifNotValid: [ SConfiguration classAssertsGenerationTest ]
]
