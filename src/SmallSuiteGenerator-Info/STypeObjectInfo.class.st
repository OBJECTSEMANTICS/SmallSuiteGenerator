Class {
	#name : #STypeObjectInfo,
	#superclass : #SObject,
	#instVars : [
		'typeInfo'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'instance creation' }
STypeObjectInfo class >> instance [ 	
	^ self new
]

{ #category : #adding }
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
