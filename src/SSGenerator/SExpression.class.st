Class {
	#name : #SExpression,
	#superclass : #Object,
	#instVars : [
		'returnType',
		'id'
	],
	#category : #'SSGenerator-Nodes'
}

{ #category : #comparing }
SExpression >> = other [
	self class = other class ifFalse: [^ false].
	^ self id = other id and: [ returnType = other returnType ]
]

{ #category : #copying }
SExpression >> copy [
	^ self class new
		id: self id;
		returnType: self returnType
]

{ #category : #comparing }
SExpression >> hash [ 	
	^ self id hash xor: self returnType
]

{ #category : #accessing }
SExpression >> id [
	^ id
]

{ #category : #accessing }
SExpression >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
SExpression >> insertMethodMessageUsing: aTestCase [
	
]

{ #category : #'as yet unclassified' }
SExpression >> insertParameterUsing: aTestCase [
	
]

{ #category : #'as yet unclassified' }
SExpression >> insertRandomMessageUsing: aTestCase [
	
]

{ #category : #testing }
SExpression >> isFactoryMessage [
	^ false
]

{ #category : #'as yet unclassified' }
SExpression >> pickUpReferences: aExpression [
	^ #()
]

{ #category : #accessing }
SExpression >> reference [
	^ self
]

{ #category : #actions }
SExpression >> replaceExpression: expression by: newExpression [
	
]

{ #category : #accessing }
SExpression >> returnType [
	^ returnType
]

{ #category : #accessing }
SExpression >> returnType: anObject [
	returnType := anObject
]
