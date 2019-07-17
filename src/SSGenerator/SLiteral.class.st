Class {
	#name : #SLiteral,
	#superclass : #SExpression,
	#instVars : [
		'value'
	],
	#category : #'SSGenerator-Nodes'
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
SLiteral >> insertParameterUsing: aTestCase [
	aTestCase insertExpression: self copy after: (aTestCase statements first)
]

{ #category : #printing }
SLiteral >> printOn: aStream [
	aStream nextPutAll: value storeString;
	nextPut: $.
]

{ #category : #evaluating }
SLiteral >> value [ 	
	^ value
]

{ #category : #accessing }
SLiteral >> value: anObject [
	value := anObject
]
