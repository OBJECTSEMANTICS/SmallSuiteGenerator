Class {
	#name : #SGAEngine,
	#superclass : #SGAObject,
	#instVars : [
		'fitnessBlock',
		'populationSize',
		'compareFitness',
		'mutationOperator',
		'crossoverOperator',
		'selection',
		'numberOfStatements',
		'population',
		'terminationBlock',
		'logs',
		'blockToExecute',
		'coverageProfiler',
		'generatorProfiler',
		'valueToCompare'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SGAEngine >> beforeRun [
	self checkIfReadyToRun.
	selection fitnessBlock: fitnessBlock.
	selection populationSize: populationSize.
	selection random: random
]

{ #category : #accessing }
SGAEngine >> blockToExecute: aBlock [
	blockToExecute := aBlock
]

{ #category : #'as yet unclassified' }
SGAEngine >> checkIfReadyToRun [
	self
		assert: [ blockToExecute notNil ]
		description: 'Need to set the block to analyze'.
	self
		assert: [ coverageProfiler notNil ]
		description: 'Need to set a coverageProfiler'.
	self
		assert: [ generatorProfiler notNil ]
		description: 'Need to set a generatorProfiler'.
	self
		assert: [ fitnessBlock notNil ]
		description: 'Need to set a fitnessBlock'.
	self assert: [ logs isEmpty ] description: 'Already been run'
]

{ #category : #accessing }
SGAEngine >> coverageProfiler: aCoverageBlock [
	self
		assert: [ blockToExecute notNil ]
		description: 'Need to set the block to analyze'.
	self
		assert: [ generatorProfiler notNil ]
		description: 'Need to set the generatorProfiler'.
	coverageProfiler := aCoverageBlock value: blockToExecute
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
    terminationBlock := [ logs last generationNumber >= nbOfGenerations ]
]

{ #category : #accessing }
SGAEngine >> fitnessBlock [ 
	^ fitnessBlock 
]

{ #category : #accessing }
SGAEngine >> fitnessBlock: aBlock [
	fitnessBlock := aBlock value: coverageProfiler 
]

{ #category : #'as yet unclassified' }
SGAEngine >> generateInvariantsFittest [
	self assert: logs isNotEmpty description: 'In this point the logs must not be empty'.
	self logs last fittestTestCase generateInvariants.
]

{ #category : #accessing }
SGAEngine >> generatorProfiler: generatorBlock [
	self
		assert: [ blockToExecute notNil ]
		description: 'Need to set the block to analyze'.
	generatorProfiler := generatorBlock value: blockToExecute
]

{ #category : #initialization }
SGAEngine >> initialize [
	super initialize.
	logs := OrderedCollection new.
	random := Random new.
	valueToCompare := 'statementCoverage'.
	self endForMaxNumberOfGeneration: 10.
	populationSize := 100.
	self maximizeComparator.
	mutationOperator := SGAMutationOperation new.
	mutationOperator mutationRate: (1 / 3) asFloat.
	mutationOperator random: random.
	crossoverOperator := SGACrossoverOperation new.
	crossoverOperator random: random.
	self selection: SGATournamentSelection new
]

{ #category : #'as yet unclassified' }
SGAEngine >> initializePopulation [
	population := OrderedCollection new.
	populationSize
		timesRepeat: [ | testCase |
			testCase := STestCase new.
			population
				add:
					(testCase
						profile: generatorProfiler;
						generateStatements: numberOfStatements) ]
]

{ #category : #testing }
SGAEngine >> isTestCase: aTestCase betterThan: aFittestTestCase [
	"Compare an testCase against the fittest testCase of the population"
	^ compareFitness value: aTestCase fitness value: aFittestTestCase fitness
]

{ #category : #accessing }
SGAEngine >> logs [
	^ logs copy
]

{ #category : #'as yet unclassified' }
SGAEngine >> maximizeComparator [
	"change by statementCoverage or methodCoverage"

	compareFitness := [ :f1 :f2 | (f1 at: valueToCompare) > (f2 at: valueToCompare)]
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
SGAEngine >> mutationOperator: aMutationOperator [
	mutationOperator := aMutationOperator.
	aMutationOperator random: random
]

{ #category : #accessing }
SGAEngine >> mutationRate: aFloat [
	mutationOperator mutationRate: aFloat
]

{ #category : #accessing }
SGAEngine >> numberOfStatements: aInt [
	numberOfStatements := aInt
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

{ #category : #accessing }
SGAEngine >> result [ 
	^ self logs last fittestTestCase statements
]

{ #category : #running }
SGAEngine >> run [
	| t log |
	self beforeRun.
	self initializePopulation.
	selection initialPopulation: population.
	selection compareFitness: compareFitness.
	UIManager default
		informUserDuring: [ :bar | 
			| gen |
			gen := 0.
			[ self shouldTerminate ]
				whileFalse: [ gen := gen + 1.
					bar label: gen asString.
					self microPause.
					t := Time now asSeconds.
					self produceNewPopulation.
					log := SGALog new.
					log generationNumber: gen.
					log fittestTestCase: selection fittest.
					log timeToProduceGeneration: Time now asSeconds - t.
					logs add: log ].
			coverageProfiler cleanInstrumentation ].
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
SGAEngine >> valueToCompare: keyValue [
	valueToCompare := keyValue 
]
