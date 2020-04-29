"
I'm a generic class for returnType of methods unexecuted
"
Class {
	#name : #SUndefinedObject,
	#superclass : #UndefinedObject,
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #comparing }
SUndefinedObject >> printOn: aStream [ 
	"Refer to the comment in Object|printOn:." 

	aStream nextPutAll: 'nil'
]
