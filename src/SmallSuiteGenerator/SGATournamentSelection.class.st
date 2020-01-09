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
		'engine'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'as yet unclassified' }
SGATournamentSelection >> createNewPopulation [
	| newPopulation TB  |
  TB := self pickBestTest.
  newPopulation := OrderedCollection new.
  [ newPopulation size < tournamentSize and: [ self population size >= 2 ] ] whileTrue: [ | P1 P2 O1 O2 fp fo lp lo child options |
        P1 := self pickOne.
        P2 := self pickOne.
        self shouldCrossOver ifTrue: [ child := self crossover: P1 with: P2.
              O1 := child first.
              O2 := child second.
				  O1 addParent: P1; addParent: P2.
				  O2 addParent: P1; addParent: P2.
		 ] ifFalse: [ O1 := P1.
              O2 := P2 ].
        self mutate: O1.
        self mutate: O2.
        fitness compute: (Array with: O1 with: O2).
        options := (Array with: O1 with: O2 with: P1 with: P2) asSortedCollection: [:a :b |  engine is: a betterThan: b ].
        newPopulation addAll: (options first: 2) ].
  population := newPopulation
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> doSelection [
	tournamentSize := initialPopulation size.
	fittest := initialPopulation first.
	initialPopulation do: [ :testCase | 
		testCase computeFitness: fitness.
		(engine is: testCase betterThan: fittest) ifTrue: [ fittest := testCase ].	
	].
	self createNewPopulation.
	initialPopulation := population
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
SGATournamentSelection >> initialPopulation: anObject [
	initialPopulation := anObject
]

{ #category : #initialization }
SGATournamentSelection >> initialize [
	population := OrderedCollection new.
	tournamentSize := 5.
	randomGenerator := SConfiguration newRandomGenerator 
]

{ #category : #accessing }
SGATournamentSelection >> load: aTestCaseCollection [
	population := aTestCaseCollection	asOrderedCollection "copy"
]

{ #category : #actions }
SGATournamentSelection >> pickOne [
	"Return the best testCase from tournamentSize testCase randomly chosen from the population"

	| sample selected |
	sample := (randomGenerator collectAtRandom: population)
		first: (tournamentSize min: population size).
	sample := sample
		asSortedCollection: [ :a :b | (self fitnessFor: a) < (self fitnessFor: b) ].
	selected := sample last.
	population remove: selected.
	^ selected
]

{ #category : #accessing }
SGATournamentSelection >> population [
	^ population 
]
