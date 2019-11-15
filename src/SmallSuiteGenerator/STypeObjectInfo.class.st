Class {
	#name : #STypeObjectInfo,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'instance creation' }
STypeObjectInfo class >> instance [ 	
	^ self new
]

{ #category : #actions }
STypeObjectInfo >> joinWith: otherObject [
	self subclassResponsibility 
]
