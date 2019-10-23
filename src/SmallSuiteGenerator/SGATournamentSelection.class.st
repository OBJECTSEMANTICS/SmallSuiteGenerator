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
	tournamentSize := 5
]

{ #category : #accessing }
SGATournamentSelection >> load: aTestCaseCollection [
	population := aTestCaseCollection 
]

{ #category : #actions }
SGATournamentSelection >> pickOne [
	"Return the best testCase from tournamentSize testCase randomly chosen from the population"
	|sample selected|
	
	sample := population shuffle first: tournamentSize.
	sample := sample asSortedCollection: [ :a :b | (self fitnessFor: a)  < (self fitnessFor: b) ].
	selected := sample last.
	population remove: selected.
	^ selected.
]

{ #category : #accessing }
SGATournamentSelection >> population [
	^ population 
]
