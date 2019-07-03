Class {
	#name : #SLiteral,
	#superclass : #SExpression,
	#instVars : [
		'value'
	],
	#category : #SSGenerator
}

{ #category : #printing }
SLiteral >> printOn: aStream [
	aStream nextPutAll: value asString;
	nextPut: $.
]

{ #category : #accessing }
SLiteral >> value: anObject [
	value := anObject
]
