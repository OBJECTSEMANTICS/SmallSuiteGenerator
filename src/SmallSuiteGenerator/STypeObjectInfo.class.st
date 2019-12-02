"
STypeObjectInfo is an abstract class of info nodes: 	
	
	- type class -> Which collect type info data of a class in the profiler
	- type method -> Collect types of the receiver, arguments and returnType of a method in the profiler
"
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
