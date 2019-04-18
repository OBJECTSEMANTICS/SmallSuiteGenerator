Class {
	#name : #SMutationOperation,
	#superclass : #SGAObject,
	#instVars : [
		'mutationRate'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #'as yet unclassified' }
SMutationOperation >> doMutate: aTestCase [
		self randomNumber <= mutationRate ifTrue: [ aTestCase remove ].
		self randomNumber <= mutationRate ifTrue: [ aTestCase change ].
		self randomNumber <= mutationRate ifTrue: [ aTestCase insert ]
	
]

{ #category : #initialization }
SMutationOperation >> initialize [
	self mutationRate: (1 / 3) asFloat
]

{ #category : #'as yet unclassified' }
SMutationOperation >> mutate: aTestCase [
	| newTestCase |
	newTestCase := STestCase seed: aTestCase profiler.
	newTestCase addStatements: aTestCase statements deepCopy.
	^ self doMutate: newTestCase.
]

{ #category : #accessing }
SMutationOperation >> mutationRate: aFloat [
	mutationRate := aFloat
]
