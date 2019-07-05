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
		ifTrue: [ aTestCase change ].
	self randomNumber <= mutationRate
		ifTrue: [ aTestCase insert ]
]

{ #category : #initialization }
SGAMutationOperation >> initialize [
	self mutationRate: (1 / 3) asFloat
]

{ #category : #'as yet unclassified' }
SGAMutationOperation >> mutate: aTestCase [
	| newTestCase |
	newTestCase := SSTestCase with: aTestCase typeInfo.
	newTestCase addFromParents: aTestCase statements deepCopy.
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
