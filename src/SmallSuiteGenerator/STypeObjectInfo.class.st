Class {
	#name : #STypeObjectInfo,
	#superclass : #Object,
	#instVars : [
		'typeInfo'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'instance creation' }
STypeObjectInfo class >> instance [ 	
	^ self new
]

{ #category : #'as yet unclassified' }
STypeObjectInfo >> joinWith: otherObject [
	self subclassResponsibility 
]

{ #category : #accessing }
STypeObjectInfo >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
STypeObjectInfo >> typeInfo: anObject [
	typeInfo := anObject
]
