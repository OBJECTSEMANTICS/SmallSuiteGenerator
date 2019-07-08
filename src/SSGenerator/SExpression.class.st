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
SExpression >> insertMethodMessageWith: aTestCase [
	^ nil
]

{ #category : #'as yet unclassified' }
SExpression >> insertParameterWith: aTestCase [
	^ nil
]

{ #category : #'as yet unclassified' }
SExpression >> insertRandomMessageWith: aTestCase [
	^ nil
]

{ #category : #testing }
SExpression >> isFactoryMessage [
	^ false
]

{ #category : #accessing }
SExpression >> returnType [
	^ returnType
]

{ #category : #accessing }
SExpression >> returnType: anObject [
	returnType := anObject
]
