"
SGATournamentSelection is responsible for select the fittest testCase based in their fitness.
"
Class {
	#name : #SGATournamentSelection,
	#superclass : #SGASelection,
	#instVars : [
		'tournamentSize'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SGATournamentSelection >> fitnessFor: aTestCase [
	^ aTestCase fitness at: fitness functionName.
]

{ #category : #initialization }
SGATournamentSelection >> initialize [
	super initialize .
	tournamentSize := 5.
]

{ #category : #selection }
SGATournamentSelection >> selectOf: aCollection [
	"Return the best testCases from tournamentSize testCase randomly chosen from the population"

	| sample |
	sample := (self random collectAtRandom: aCollection )
		first: (tournamentSize min: aCollection size).
	sample := sample
		asSortedCollection: [ :a :b | (a fitness at: fitness functionName) > (b fitness  at: fitness functionName) ].
	^ sample
]

{ #category : #accessing }
SGATournamentSelection >> tournamentSize: anInteger [
	tournamentSize := anInteger 
]
