Class {
	#name : #SPrimitiveStatement,
	#superclass : #SStatement,
	#instVars : [
		'value'
	],
	#category : #'SmallSuiteGenerator-Statement'
}

{ #category : #printing }
SPrimitiveStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: value asString.
	aStream nextPut: $.
]

{ #category : #accessing }
SPrimitiveStatement >> value: anObject [
	value := anObject.
]
