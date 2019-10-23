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
	self randomNumber <= mutationRate
		ifTrue: [ aTestCase removeStatement.].
	self randomNumber <= mutationRate
		ifTrue: [ aTestCase changeStatement ].
	self randomNumber <= mutationRate
		ifTrue: [ aTestCase insertStatement ]
]

{ #category : #initialization }
SGAMutationOperation >> initialize [
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
SGAMutationOperation >> mutationRate [
	^ mutationRate 
]

{ #category : #accessing }
SGAMutationOperation >> mutationRate: aFloat [
	mutationRate := aFloat
]
