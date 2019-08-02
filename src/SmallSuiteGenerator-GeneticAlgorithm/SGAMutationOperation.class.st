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
		ifTrue: [ aTestCase removeStatement.
			aTestCase validReferences ifFalse: [ self halt ] ].
	self randomNumber <= mutationRate
		ifTrue: [ aTestCase changeStatement .
			aTestCase validReferences ifFalse: [ self halt ]].
	self randomNumber <= mutationRate
		ifTrue: [ aTestCase insertStatement.
			aTestCase validReferences ifFalse: [ self halt ] ]
]

{ #category : #initialization }
SGAMutationOperation >> initialize [
	self mutationRate: (1 / 3) asFloat
]

{ #category : #'as yet unclassified' }
SGAMutationOperation >> mutate: aTestCase [
	| newTestCase |
	newTestCase := aTestCase copy.
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
