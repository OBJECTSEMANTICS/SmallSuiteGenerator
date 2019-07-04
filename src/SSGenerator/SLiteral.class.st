Class {
	#name : #SLiteral,
	#superclass : #SExpression,
	#instVars : [
		'value'
	],
	#category : #'SSGenerator-Nodes'
}

{ #category : #printing }
SLiteral >> printOn: aStream [
	aStream nextPutAll: value storeString;
	nextPut: $.
]

{ #category : #accessing }
SLiteral >> value: anObject [
	value := anObject
]
