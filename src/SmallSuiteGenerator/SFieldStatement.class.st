Class {
	#name : #SFieldStatement,
	#superclass : #SStatement,
	#instVars : [
		'receiverVarName',
		'fieldName'
	],
	#category : #'SmallSuiteGenerator-Statement'
}

{ #category : #accessing }
SFieldStatement >> fieldName [
	^ fieldName
]

{ #category : #accessing }
SFieldStatement >> fieldName: anObject [
	fieldName := anObject
]

{ #category : #printing }
SFieldStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self receiverVarName asString.
	aStream nextPutAll: ' '.
	aStream nextPutAll: self fieldName.
	aStream nextPut: $.
]

{ #category : #accessing }
SFieldStatement >> receiverVarName [
	^ receiverVarName
]

{ #category : #accessing }
SFieldStatement >> receiverVarName: anObject [
	receiverVarName := anObject
]
