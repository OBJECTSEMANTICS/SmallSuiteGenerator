Class {
	#name : #STournamentSelection,
	#superclass : #SGAObject,
	#instVars : [
		'population',
		'fittest',
		'fitnessBlock',
		'populationSize',
		'compareFitness',
		'initialPopulation',
		'engine',
		'tournamentSize'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #accessing }
STournamentSelection >> compareFitness: aTwoArgBlock [
	compareFitness := aTwoArgBlock
]

{ #category : #'as yet unclassified' }
STournamentSelection >> createNewPopulation [
	"Return a new population made of newly breed testCase"

	| parentA parentB offsprings offspringA offspringB |
	population := OrderedCollection new.
	[ population size < self populationSize ]
		whileTrue: [ parentA := self getGoodTestCase.
			parentB := self getGoodTestCase.
			offsprings := self crossover: parentA with: parentB.
			offspringA := self mutate: offsprings first.
			offspringB := self mutate: offsprings second.
			(self isTooLong: offspringA)
				ifFalse: [ population add: offspringA ].
			(self isTooLong: offspringB)
				ifFalse: [ population add: offspringB ] ]
]

{ #category : #'as yet unclassified' }
STournamentSelection >> crossover: testCaseA with: testCaseB [
	^ engine crossover: testCaseA with: testCaseB
]

{ #category : #'as yet unclassified' }
STournamentSelection >> doSelection [
	populationSize := initialPopulation size.
	fittest := initialPopulation first.
	initialPopulation
		do: [ :testCase | 
			testCase computeFitnessUsing: fitnessBlock.
			(self isTestCase: testCase betterThan: fittest)
				ifTrue: [ fittest := testCase ] ].
	self createNewPopulation.
	initialPopulation := population
]

{ #category : #accessing }
STournamentSelection >> engine: aEngine [
	engine := aEngine
]

{ #category : #accessing }
STournamentSelection >> fitnessBlock: aBlock [
	fitnessBlock := aBlock
]

{ #category : #'as yet unclassified' }
STournamentSelection >> getGoodTestCase [
	"Return the best testCase from tournamentSize testCase randomly chosen from the population"
	| best testCase |
	best := nil.
	tournamentSize
		timesRepeat: [ testCase := initialPopulation
				at: (self randomNumber: initialPopulation size).
			(best isNil
				or: [ compareFitness value: testCase fitness value: best fitness ])
				ifTrue: [ best := testCase ] ].
	^ best
]

{ #category : #accessing }
STournamentSelection >> initialPopulation: aPopulation [
	initialPopulation := aPopulation 
]

{ #category : #initialization }
STournamentSelection >> initialize [
	population := OrderedCollection new
]

{ #category : #testing }
STournamentSelection >> isTestCase: testCase betterThan: fittestTestCase [
	^ engine isTestCase: testCase betterThan: fittestTestCase
]
