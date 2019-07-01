Class {
	#name : #SGAEngine,
	#superclass : #SGAObject,
	#instVars : [
		'fitnessBlock',
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
		'coverageProfiler',
		'generatorProfiler',
		'valueToCompare',
		'modelClasses',
		'testClasses',
		'operators',
		'evaluationStrategy'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SGAEngine >> analyzeMutants [
	| analysis |
	self
		assert: (modelClasses isNotNil and: [ modelClasses isNotEmpty ])
		description: 'modelClasses must not be nil or empty'.
	analysis := MutationTestingAnalysis
		testCasesFrom:
			(SAuxiliar
				validate: testClasses
				ifNotValid: [ SConfiguration classAssertsGenerationTest ])
		mutating: modelClasses
		using:
			(SAuxiliar
				validate: operators
				ifNotValid: [ SConfiguration defaultMutantOperators ])
		with:
			(evaluationStrategy ifNil: [ SConfiguration defaultEvaluationStrategy ]).
	analysis run.
	^ analysis generalResult
]

{ #category : #'as yet unclassified' }
SGAEngine >> beforeRun [
	self checkIfReadyToRun.
	selection fitnessBlock: fitnessBlock.
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

{ #category : #'as yet unclassified' }
SGAEngine >> checkBlockToExecute [
	self
		assert: [ blockToExecute notNil ]
		description: 'Need to set the block to analyze'
]

{ #category : #'as yet unclassified' }
SGAEngine >> checkCoverageProfiler [
	self
		assert: [ coverageProfiler notNil ]
		description: 'Need to set a coverageProfiler'
]

{ #category : #'as yet unclassified' }
SGAEngine >> checkFitnessBlock [
	self
		assert: [ fitnessBlock notNil ]
		description: 'Need to set a fitnessBlock'
]

{ #category : #'as yet unclassified' }
SGAEngine >> checkGeneratorProfiler [
	self
		assert: [ generatorProfiler notNil ]
		description: 'Need to set a generatorProfiler'
]

{ #category : #'as yet unclassified' }
SGAEngine >> checkIfReadyToRun [
	self checkBlockToExecute.
	self checkCoverageProfiler.
	self checkGeneratorProfiler.
	self checkFitnessBlock.
	self checkLogs
]

{ #category : #'as yet unclassified' }
SGAEngine >> checkLogs [
	self assert: [ logs isEmpty ] description: 'Already been run'
]

{ #category : #accessing }
SGAEngine >> coverageProfiler [
	^ coverageProfiler
]

{ #category : #accessing }
SGAEngine >> coverageProfiler: aCoverageBlock [
	self checkBlockToExecute.
	self checkGeneratorProfiler.
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
SGAEngine >> evaluationStrategy: aEvaluationStrategy [
	evaluationStrategy := aEvaluationStrategy 
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
SGAEngine >> generateAssertionsUsing: selectedInvariants [
	self
		assert: logs isNotEmpty
		description: 'In this point the logs must not be empty'.
	self logs
		do: [ :log | 
			log fittestTestCase generateAssertionsUsing: selectedInvariants.
			log mutationResult: self analyzeMutants ]
]

{ #category : #'as yet unclassified' }
SGAEngine >> generateAssertionsUsing: selectedInvariants invariantsAndApplyPrettyCodeWith: kindsRefactoring [
	self
		assert: logs isNotEmpty
		description: 'In this point the logs must not be empty'.
	self logs
		do: [ :log | 
			log fittestTestCase prettyCodeApplying: kindsRefactoring.
			log fittestTestCase generateAssertionsUsing: selectedInvariants.
			log mutationResult: self analyzeMutants ]
]

{ #category : #accessing }
SGAEngine >> generatorProfiler [
	^ generatorProfiler
]

{ #category : #accessing }
SGAEngine >> generatorProfiler: generatorBlock [
	self checkBlockToExecute.
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

{ #category : #'as yet unclassified' }
SGAEngine >> initializePopulation [
	population := OrderedCollection new.
	populationSize
		timesRepeat: [ population
				add:
					(STestCase new
						typeInfo: generatorProfiler; "change this"
						generateStatements: numberOfStatements) ]
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

{ #category : #accessing }
SGAEngine >> modelClasses: classes [
	self assert: (classes isNotNil and: [ classes isNotEmpty ]) description: 'The classes must not be nil or empty'.
	modelClasses := classes
]

{ #category : #'as yet unclassified' }
SGAEngine >> mutantOperators: mutantOperators [
	operators := mutantOperators 
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
				whileFalse: [ gen := gen + 1.
					bar label: gen asString.
					self microPause.
					t := Time now asSeconds.
					self produceNewPopulation.
					logs add: (self logWithGenerationNumber: gen atTime: t) ].
			coverageProfiler cleanInstrumentation ]
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
SGAEngine >> testClasses: testCaseClasses [
	testClasses := testCaseClasses 
]

{ #category : #accessing }
SGAEngine >> valueToCompare: keyValue [
	valueToCompare := keyValue 
]
