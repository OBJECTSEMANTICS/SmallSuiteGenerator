"
SGATournamentSelection is responsible for select the fittest testCase based in their fitness.
"
Class {
	#name : #SGATournamentSelection,
	#superclass : #SGAObject,
	#instVars : [
		'population',
		'fittest',
		'tournamentSize',
		'fitness',
		'initialPopulation',
		'engine',
		'allPopulation',
		'crossoverRate',
		'elitismRate',
		'parentReplacementCheck'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SGATournamentSelection >> allPopulation [
	^ allPopulation 
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> createNewPopulation [
  | newPopulation currentPopulation |
	currentPopulation := initialPopulation size.
	1 to: tournamentSize do: [ :i | 
  newPopulation := self eliteOfCurrentPopulation.
  [ newPopulation size < currentPopulation ] whileTrue: [ | P1copy P2copy P1 P2 O1 O2 OM1 OM2 selectedOptions children options |
        P1 := self pickOne.
        P2 := self pickAnother: P1.
        P1copy := P1 deepCopy.
        P1copy addParent: P1.
        P2copy := P2 deepCopy.
        P2copy addParent: P2.
        P1copy ni: P1 ni + 1.
        P2copy ni: P2 ni + 1.
        self shouldCrossOver ifTrue: [ children := engine crossoverOperator crossover: P1 with: P2.
              O1 := children first.
              O2 := children second.
              O1 ni: P1 ni + 1.
              O2 ni: P2 ni + 1 ] ifFalse: [ O1 := P1copy deepCopy.
				  O1 addParent: P1.
              O2 := P2copy deepCopy.
              O2 addParent: P2 ].
        OM1 := engine mutate: O1.
        self update: OM1 with: O1.
        OM2 := engine mutate: O2.
        self update: OM2 with: O2.
        fitness compute: (Array with: OM1 with: OM2).
        options := Array with: OM1 with: OM2 with: P1copy with: P2copy.
        options := options asSortedCollection: [:a :b |  engine is: a betterThan: b ].
        selectedOptions := options first: 2.
        selectedOptions do: [:option |  newPopulation add: (option idPopulation: newPopulation size + 1) ] ].
  population := newPopulation
]
]

{ #category : #asserting }
SGATournamentSelection >> crossoverRate [
	^ crossoverRate 
]

{ #category : #accessing }
SGATournamentSelection >> crossoverRate: anObject [
	crossoverRate := anObject
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> doSelection [
	fittest := initialPopulation first.
	initialPopulation do: [ :testCase | 
		"testCase computeFitness: fitness."
		(engine is: testCase betterThan: fittest) ifTrue: [ fittest := testCase ].	
	].
	self createNewPopulation.
	initialPopulation := population
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> eliteOfCurrentPopulation [
	| endIndex |
	endIndex := (population size * elitismRate * 0.01) asInteger.
	endIndex >= 1 ifTrue: [ ^ population copyFrom: 1 to: endIndex ].
	^ OrderedCollection new
]

{ #category : #accessing }
SGATournamentSelection >> elitismRate: anObject [
	elitismRate := anObject
]

{ #category : #accessing }
SGATournamentSelection >> engine: anEngine [
	engine := anEngine
]

{ #category : #accessing }
SGATournamentSelection >> fitness [ 	
	^ fitness 
]

{ #category : #accessing }
SGATournamentSelection >> fitness: aFitness [
	fitness := aFitness
]

{ #category : #actions }
SGATournamentSelection >> fitnessFor: aTestCase [
	^ aTestCase fitness at: fitness functionName
]

{ #category : #accessing }
SGATournamentSelection >> initialPopulation [
	^ initialPopulation
]

{ #category : #accessing }
SGATournamentSelection >> initialPopulation: testCases [
	"initialPopulation := anObject."
	allPopulation addAll: testCases.
	initialPopulation := testCases.
	"initialPopulation := testCases collect: [:testCase | testCase deepCopy addParent: testCase ].
	allPopulation addAll: initialPopulation."
]

{ #category : #initialization }
SGATournamentSelection >> initialize [
	population := OrderedCollection new.
	tournamentSize := 2.
	randomGenerator := SConfiguration newRandomGenerator.
	allPopulation := Set new.
	crossoverRate := 0.8.
	elitismRate := 10.
	parentReplacementCheck := false.
]

{ #category : #accessing }
SGATournamentSelection >> load: aTestCaseCollection [
	population := aTestCaseCollection	asOrderedCollection "copy"
]

{ #category : #accessing }
SGATournamentSelection >> parentReplacementCheck: anObject [
	parentReplacementCheck := anObject
]

{ #category : #actions }
SGATournamentSelection >> pickAnother: selected [
  "Return the best testCase from tournamentSize testCase randomly chosen from the population"
  | sample |
  sample := (randomGenerator collectAtRandom: initialPopulation) first: (tournamentSize min: initialPopulation size).
  sample := sample asSortedCollection: [:a :b |  (self fitnessFor: a) < (self fitnessFor: b) ].
  ^(sample reject: [:test |  test = selected ]) last
]

{ #category : #actions }
SGATournamentSelection >> pickOne [
	"Return the best testCase from tournamentSize testCase randomly chosen from the population"

	| sample selected |
	sample := (randomGenerator collectAtRandom: initialPopulation)
		first: (tournamentSize min: initialPopulation size).
	sample := sample
		asSortedCollection: [ :a :b | (self fitnessFor: a) < (self fitnessFor: b) ].
	selected := sample last.
	"population remove: selected."
	^ selected
]

{ #category : #accessing }
SGATournamentSelection >> population [
	^ population 
]

{ #category : #asserting }
SGATournamentSelection >> shouldCrossOver [
	^ SConfiguration randomGenerator next < self crossoverRate
]

{ #category : #accessing }
SGATournamentSelection >> tournamentSize: anInteger [
	tournamentSize := anInteger 
]

{ #category : #updating }
SGATournamentSelection >> update: aTestCase with: anotherTestCase [
	aTestCase ni: anotherTestCase ni.
	anotherTestCase parents do: [ :parent | aTestCase addParent:  parent ]
]
