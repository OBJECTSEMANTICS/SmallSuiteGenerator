"
SGATournamentSelection is responsible for select the fittest testCase based in their fitness.
"
Class {
	#name : #SGATournamentSelection,
	#superclass : #SGASelection,
	#instVars : [
		'tournamentSize',
		'fitness'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SGATournamentSelection >> fitness: anObject [ 
	fitness := anObject 
]

{ #category : #actions }
SGATournamentSelection >> fitnessFor: aTestCase [
	^ aTestCase fitness at: fitness functionName.
]

{ #category : #initialization }
SGATournamentSelection >> initialize [
	super initialize .
	tournamentSize := 5.
]

{ #category : #actions }
SGATournamentSelection >> selectOf: aCollection [
	"Return the best testCases from tournamentSize testCase randomly chosen from the population"

	| sample |
	sample := (randomGenerator collectAtRandom: aCollection )
		first: (tournamentSize min: aCollection size).
	sample := sample
		asSortedCollection: [ :a :b | 
			|fitness1 fitness2|
	fitness1 := self fitnessFor: a.
	fitness2 := self fitnessFor: b.
		^ 			fitness1 = fitness2
						ifTrue: [ a length <= b length ]
						ifFalse: [ fitness1 > fitness2 ]. ].
	^ sample
]

{ #category : #accessing }
SGATournamentSelection >> tournamentSize: anInteger [
	tournamentSize := anInteger 
]
