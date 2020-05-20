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
SGATournamentSelection >> selectJustOneOf: aCollection with: probabilities [
	| sample index |
	index := 0.
	sample := (self random collectAtRandom: 
		(probabilities collect: [:prob | 
			index := index + 1.
			index -> prob ] ) )
		first: (2 min: probabilities size).
	sample := (sample sort: [ :a :b | a value > b value ]) first.
	^ aCollection at: sample key 
]

{ #category : #selection }
SGATournamentSelection >> selectOf: aCollection [
	"Return the best testCases from tournamentSize testCase randomly chosen from the population"

	| sample |
	sample := (self random collectAtRandom: aCollection )
		first: (tournamentSize min: aCollection size).
	sample := sample sort: [ :a :b | (self fitnessFor: a) > (self fitnessFor: b) ].
	^ sample
]

{ #category : #accessing }
SGATournamentSelection >> tournamentSize: anInteger [
	tournamentSize := anInteger 
]
