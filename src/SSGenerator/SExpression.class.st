Class {
	#name : #SExpression,
	#superclass : #Object,
	#instVars : [
		'returnType',
		'id'
	],
	#category : #SSGenerator
}

{ #category : #accessing }
SExpression >> id [
	^ id
]

{ #category : #accessing }
SExpression >> id: anObject [
	id := anObject
]

{ #category : #accessing }
SExpression >> returnType [
	^ returnType
]

{ #category : #accessing }
SExpression >> returnType: anObject [
	returnType := anObject
]
