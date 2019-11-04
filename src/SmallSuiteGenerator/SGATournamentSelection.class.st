Class {
	#name : #SGATournamentSelection,
	#superclass : #SGAObject,
	#instVars : [
		'population',
		'tournamentSize',
		'fitness'
	],
	#category : #'SmallSuiteGenerator-GA'
}

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
	^ aTestCase fitness at: fitness funtionName
]

{ #category : #initialization }
SGATournamentSelection >> initialize [
	population := OrderedCollection new.
	tournamentSize := 5.
	randomGenerator := SConfiguration newRandomGenerator 
]

{ #category : #accessing }
SGATournamentSelection >> load: aTestCaseCollection [
	population := aTestCaseCollection asOrderedCollection copy.
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
