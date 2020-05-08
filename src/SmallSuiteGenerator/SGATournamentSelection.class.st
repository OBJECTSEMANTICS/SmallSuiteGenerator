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
		asSortedCollection: [ :a :b | (a fitnessFor: fitness functionName) > (b fitnessFor: fitness functionName) ].
	^ sample
]

{ #category : #accessing }
SGATournamentSelection >> tournamentSize: anInteger [
	tournamentSize := anInteger 
]
