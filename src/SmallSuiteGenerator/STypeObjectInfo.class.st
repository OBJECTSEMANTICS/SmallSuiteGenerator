Class {
	#name : #STypeObjectInfo,
	#superclass : #SObject,
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
