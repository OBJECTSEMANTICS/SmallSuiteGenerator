Class {
	#name : #SGATournamentSelection,
	#superclass : #SGAObject,
	#instVars : [
		'population',
		'fittest',
		'fitness',
		'populationSize',
		'compareFitness',
		'initialPopulation',
		'engine',
		'tournamentSize'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm-Core'
}

{ #category : #accessing }
SGATournamentSelection >> compareFitness: aTwoArgBlock [
	compareFitness := aTwoArgBlock
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> createNewPopulation [
	"Return a new population made of newly breed testCase"

	| parentA parentB offsprings offspringA offspringB |
	population := OrderedCollection new.
	[ population size < self populationSize ]
		whileTrue: [ parentA := self getGoodTestCase.
			parentB := self getGoodTestCase.
			offsprings := self crossover: parentA with: parentB.
			offspringA := self mutate: offsprings first.
			offspringB := self mutate: offsprings second.
			(Array with: offspringA with: offspringB)
				do: [ :each | 
					(self isTooLong: each)
						ifFalse: [ population add: each ] ] ]
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> crossover: testCaseA with: testCaseB [
	^ engine crossover: testCaseA with: testCaseB
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> doSelection [
	populationSize := initialPopulation size.
	fittest := initialPopulation first.
	initialPopulation
		do: [ :testCase | 
			testCase computeFitness: fitness.
			(self isTestCase: testCase betterThan: fittest)
				ifTrue: [ fittest := testCase ] ].
	self createNewPopulation.
	initialPopulation := population
]

{ #category : #accessing }
SGATournamentSelection >> engine [ 
	^ engine
]

{ #category : #accessing }
SGATournamentSelection >> engine: aEngine [
	engine := aEngine
]

{ #category : #accessing }
SGATournamentSelection >> fitness [ 	
	^ fitness 
]

{ #category : #accessing }
SGATournamentSelection >> fitness: aFitness [
	fitness := aFitness
]

{ #category : #accessing }
SGATournamentSelection >> fittest [
	^ fittest
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> getGoodTestCase [
	"Return the best testCase from tournamentSize testCase randomly chosen from the population"
	| best testCase |
	best := nil.
	tournamentSize
		timesRepeat: [ testCase := initialPopulation
				at: (self randomNumber: initialPopulation size).
			(best isNil
				or: [ compareFitness value: testCase value: best ])
				ifTrue: [ best := testCase ] ].
	^ best
]

{ #category : #accessing }
SGATournamentSelection >> initialPopulation: aPopulation [
	initialPopulation := aPopulation 
]

{ #category : #initialization }
SGATournamentSelection >> initialize [
	population := OrderedCollection new.
	tournamentSize := 5
]

{ #category : #testing }
SGATournamentSelection >> isTestCase: testCase betterThan: fittestTestCase [
	^ engine isTestCase: testCase betterThan: fittestTestCase
]

{ #category : #testing }
SGATournamentSelection >> isTooLong: aTestCase [
	^ aTestCase numberStatements > 54	"if number statements exceeds the number max of statements"
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> mutate: child [
	^ engine mutate: child
]

{ #category : #accessing }
SGATournamentSelection >> population [
	^ population 
]

{ #category : #accessing }
SGATournamentSelection >> populationSize [
	^ initialPopulation size
]

{ #category : #accessing }
SGATournamentSelection >> populationSize: aInteger [
	populationSize := aInteger
]
