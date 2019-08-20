Class {
	#name : #SLiteral,
	#superclass : #SExpression,
	#instVars : [
		'value'
	],
	#category : #'SmallSuiteGenerator-Nodes'
}

{ #category : #comparing }
SLiteral >> = other [
	^ super = other and: [ value = other value ]
]

{ #category : #copying }
SLiteral >> copy [ 
	| copy|
	copy := super copy.
	copy value: value copy.
	^ copy
]

{ #category : #comparing }
SLiteral >> hash [
	^ super hash xor: value hash
]

{ #category : #'as yet unclassified' }
SLiteral >> insertOn: aTestCase [
	^ aTestCase addLiteral: self returnType
]

{ #category : #printing }
SLiteral >> printOn: aStream [
	aStream nextPutAll: value storeString;
	nextPut: $.
]

{ #category : #mutation }
SLiteral >> repairOn: aTestCase changing: aExpression [
	self value: value mutateToChange
]

{ #category : #accessing }
SLiteral >> replaceBy: otherExpression [
	self value: otherExpression value
]

{ #category : #evaluating }
SLiteral >> value [ 	
	^ value
]

{ #category : #accessing }
SLiteral >> value: anObject [
	value := anObject
]
