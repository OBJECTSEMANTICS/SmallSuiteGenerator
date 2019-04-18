Class {
	#name : #SEngine,
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
		'terminationBlock'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SEngine >> beforeRun [
	selection fitnessBlock: fitnessBlock.
	selection populationSize: populationSize.
]

{ #category : #'as yet unclassified' }
SEngine >> crossover: testCaseA with: testCaseB [
	^ crossoverOperator crossover: testCaseA with: testCaseB
]

{ #category : #accessing }
SEngine >> crossoverOperator: aCrossoverOperator [
	crossoverOperator := aCrossoverOperator.
	crossoverOperator random: random
]

{ #category : #'as yet unclassified' }
SEngine >> initialPopulationOnClass: aClass [
	population := OrderedCollection new.
	populationSize timesRepeat: [  ].
]

{ #category : #'as yet unclassified' }
SEngine >> initialPopulationOnPackage: regex [
	
]

{ #category : #initialization }
SEngine >> initialize [
	super initialize.
	random := Random new.
	populationSize := 100.
	self maximizeComparator.
	mutationOperator := SMutationOperation new.
	mutationOperator mutationRate: (1 / 3) asFloat.
	mutationOperator random: random.
	crossoverOperator := SCrossoverOperation new.
	crossoverOperator random: random.
	self selection: STournamentSelection new.
]

{ #category : #testing }
SEngine >> isTestCase: aTestCase betterThan: aFittestTestCase [
	"Compare an testCase against the fittest testCase of the population"
	^ compareFitness value: aTestCase fitness value: aFittestTestCase fitness
]

{ #category : #'as yet unclassified' }
SEngine >> maximizeComparator [
	compareFitness := [ :f1 :f2 | f1 > f2 ]
]

{ #category : #accessing }
SEngine >> mutationOperator: aMutationOperator [
	mutationOperator := aMutationOperator.
	aMutationOperator random: random
]

{ #category : #accessing }
SEngine >> mutationRate: aFloat [
	mutationOperator mutationRate: aFloat
]

{ #category : #accessing }
SEngine >> numberOfStatements: aInt [
	numberOfStatements := aInt
]

{ #category : #accessing }
SEngine >> populationSize: aInteger [
	populationSize := aInteger
]

{ #category : #'as yet unclassified' }
SEngine >> produceNewPopulation [
	selection doSelection.
	population := selection population.
]

{ #category : #running }
SEngine >> run [ 
	selection initialPopulation: population.
	selection compareFitness: compareFitness.
	[ self shouldTerminate ] whileFalse: [ self produceNewPopulation ]
]

{ #category : #'as yet unclassified' }
SEngine >> runOnClass: aClass [
	self beforeRun.
	self initialPopulationOnClass: aClass.
	self run.
]

{ #category : #'as yet unclassified' }
SEngine >> runOnPackage: regex [
	self beforeRun.
	self initialPopulationOnClass: regex.
	self run
]

{ #category : #accessing }
SEngine >> selection: aSelection [
	selection := aSelection.
	aSelection engine: self.
	
]

{ #category : #asserting }
SEngine >> shouldTerminate [
	^ terminationBlock value
]
