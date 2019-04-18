Class {
	#name : #SGeneticAlgorithm,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SGeneticAlgorithm >> crossover: aTestCase1 with: aTestCase2 [
	^ { aTestCase1. aTestCase2 } "implementar el algoritmo de crossover"
]

{ #category : #'as yet unclassified' }
SGeneticAlgorithm >> elitism: population [
	^ {population first}
]

{ #category : #'as yet unclassified' }
SGeneticAlgorithm >> geneticAlgorithm: aBlock onClass: aClass usingTestSuiteOfSize: aNumber [
	| profiler testCaseProfiler fitnessBlock population newPopulation |
	testCaseProfiler := SSGenerator profile: aBlock onClass: aClass.
	population := STestCase
		createTestSuite: testCaseProfiler
		ofSize: aNumber.
	profiler := SBProfiler new.
	profiler profileInstrumented: aBlock onClass: aClass.
	fitnessBlock := [ :testCase | testCase computeFitnessUsing: profiler ].
	newPopulation := self populationUsingGA: population and: fitnessBlock.
	profiler cleanInstrumentation.
	^ newPopulation
]

{ #category : #testing }
SGeneticAlgorithm >> isNextPopulationFull: collection [
	^ collection size >= 50 "el tamanio de la nueva generacion debe ser < 50"
]

{ #category : #testing }
SGeneticAlgorithm >> isTooLong: aTestCase [
	^ aTestCase numberOfStatements > 54	"si el numero de statements sobrepasa el maximo"
]

{ #category : #'instance creation' }
SGeneticAlgorithm >> newGeneration: population with: aFitnessBlock [
	| newGeneration |
	newGeneration := OrderedCollection new.
	newGeneration addAll: (self elitism: population).
	[ self isNextPopulationFull: newGeneration ]
		whileFalse: [ | offsprings p1 p2 o1 o2 |
			p1 := self select: population using: aFitnessBlock.
			p2 := self select: population using: aFitnessBlock.
			offsprings := self crossover: p1 with: p2.
			o1 := offsprings first.
			o2 := offsprings second.
			o1 mutate.
			o2 mutate.
			(self isTooLong: o1)
				ifTrue: [ newGeneration add: p1 ]
				ifFalse: [ newGeneration add: o1 ].
			(self isTooLong: o2)
				ifTrue: [ newGeneration add: p2 ]
				ifFalse: [ newGeneration add: o2 ] ].
	^ newGeneration
]

{ #category : #'as yet unclassified' }
SGeneticAlgorithm >> populationUsingGA: population and: fitnessBlock [
	| newPopulation numIterations |
	numIterations := 10.
	newPopulation := population.
	1 to: numIterations do:
		[ :numIter | newPopulation := self newGeneration: newPopulation with: fitnessBlock ].
	^ newPopulation
]

{ #category : #'as yet unclassified' }
SGeneticAlgorithm >> select: population using: aFitnessBlock [
	^ population first "se debe implementar el algoritmo de selection 
		- Rank selection o TournamentSelection
	"
]
