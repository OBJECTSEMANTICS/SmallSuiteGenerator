Class {
	#name : #SGAMutationOperation,
	#superclass : #SGAOperation,
	#instVars : [
		'mutationRate'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SGAMutationOperation >> doMutate: aTestCase [
	self randomNumber <= mutationRate
		ifTrue: [ aTestCase remove ].
	self randomNumber <= mutationRate
		ifTrue: [ 
			aTestCase change ].
	self randomNumber <= mutationRate
		ifTrue: [
			aTestCase insert ]
]

{ #category : #initialization }
SGAMutationOperation >> initialize [
	self mutationRate: (1 / 3) asFloat
]

{ #category : #'as yet unclassified' }
SGAMutationOperation >> mutate: aTestCase [
	| newTestCase newStatements |
	newTestCase := STestCase seed: aTestCase profile.
	newTestCase add: aTestCase statements deepCopy fromParentWith: aTestCase assignedIds.
	"newStatements := aTestCase statements deepCopy do: #cleanId."
	"newStatements
		do: [ :stm | newTestCase addStatement: stm ]."
	self doMutate: newTestCase.
	^ newTestCase
]

{ #category : #accessing }
SGAMutationOperation >> mutationRate [
	^ mutationRate 
]

{ #category : #accessing }
SGAMutationOperation >> mutationRate: aFloat [
	mutationRate := aFloat
]
