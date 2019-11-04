Class {
	#name : #SGAMutationOperation,
	#superclass : #SGAOperation,
	#instVars : [
		'mutationRate'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SGAMutationOperation >> doMutate: aTestCase [
	randomGenerator next <= mutationRate
		ifTrue: [ aTestCase removeStatement ].
	randomGenerator next <= mutationRate
		ifTrue: [ aTestCase changeStatement ].
	randomGenerator next <= mutationRate
		ifTrue: [ aTestCase insertStatement ]
]

{ #category : #initialization }
SGAMutationOperation >> initialize [
	super initialize.
	self mutationRate: (1 / 3) asFloat
]

{ #category : #actions }
SGAMutationOperation >> mutate: aTestCase [
	| newTestCase |
	newTestCase := aTestCase copy.
	self doMutate: newTestCase.
	^ newTestCase
]

{ #category : #accessing }
SGAMutationOperation >> mutationRate: aFloat [
	mutationRate := aFloat
]
