"
SGAMutationOperation is an operator which modifies some statements of the testCase. However this operation depends of a random probability to be applied.

This operation can apply three different types of mutation: 	
	- remove -> It means that a statement choosen randomly can be removed of the testCase.
	- change -> According to the statement choosen, it is modified in value or selector.
	- insert -> A statement is added following one of these options: asRandomMessage, asMethodMessage or asParameter. The reason for these options is because statements are usually of different expressions.
"
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
  newTestCase := aTestCase copyForMutation.
  self doMutate: newTestCase.
  ^newTestCase
]

{ #category : #accessing }
SGAMutationOperation >> mutationRate: aFloat [
	mutationRate := aFloat
]
