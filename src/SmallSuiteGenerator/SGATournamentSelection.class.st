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
		'allPopulation'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SGATournamentSelection >> allPopulation [
	^ allPopulation 
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> createNewPopulation [
	| newPopulation  |
  "TB := engine pickBestTest."
  newPopulation := OrderedCollection new.
	"initialPopulation := initialPopulation collect: [:testCase | testCase deepCopy addParent: testCase ].
	allPopulation addAll: initialPopulation."
  [ newPopulation size < tournamentSize and: [ tournamentSize >= 2 ] ] whileTrue: [ | P1 P2 O1 O2 "fp fo lp lo" selectedOptions children options |
        P1 := self pickOne.
        P2 := self pickOne.
        self shouldCrossOver ifTrue: [ children := engine crossoverOperator crossover: P1 with: P2.
            O1 := children first.
    	       O2 := children second.
		 ] ifFalse: [ O1 := P1 deepCopy.
				O1 addParent: P1.
              O2 := P2 deepCopy.
					O2 addParent: P2
			].
        engine mutate: O1.
        engine mutate: O2.
        fitness compute: (Array with: O1 with: O2).
			 options := Array with: O1 with: O2 with: P1 with: P2.
			 "options size >= 2 ifTrue: [ "
			 options := options asSortedCollection: [:a :b |  engine is: a betterThan: b ].
			 selectedOptions := options first: 2.
			"selectedOptions do: [ :option | newPopulation add: (
				(allPopulation includes: option) ifTrue: [ option deepCopy addParent: option; yourself ] ifFalse: [ option]). ]."
			self halt.
			newPopulation addAll: (selectedOptions collect: [:option | 
				(allPopulation includes: option) ifTrue: [ 
					| copy |
					copy := option deepCopy addParent: option; yourself.
					allPopulation add: copy.
					copy
				] ifFalse: [ option] ]).
			 "] ifFalse: [ allPopulation addAll: options ]."
			 allPopulation addAll: options.
        "newPopulation addAll: selectedOptions" "(options first: 2)" ].
  population := newPopulation 
]

{ #category : #'as yet unclassified' }
SGATournamentSelection >> doSelection [
	tournamentSize := initialPopulation size.
	fittest := initialPopulation first.
	initialPopulation do: [ :testCase | 
		"testCase computeFitness: fitness."
		(engine is: testCase betterThan: fittest) ifTrue: [ fittest := testCase ].	
	].
	self createNewPopulation.
	initialPopulation := population
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
	tournamentSize := 5.
	randomGenerator := SConfiguration newRandomGenerator.
	allPopulation := Set new
]

{ #category : #accessing }
SGATournamentSelection >> load: aTestCaseCollection [
	population := aTestCaseCollection	asOrderedCollection "copy"
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
	^ SConfiguration randomGenerator next < (3 / 4)
]
