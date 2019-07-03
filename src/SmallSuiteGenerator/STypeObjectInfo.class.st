Class {
	#name : #STypeObjectInfo,
	#superclass : #Object,
	#instVars : [
		'typeInfo'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #accessing }
STypeObjectInfo >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
STypeObjectInfo >> typeInfo: anObject [
	typeInfo := anObject
]
