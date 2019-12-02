"
SError is a subclass of Error. It is used to represent error's conditions in test generation process.

Additionally, it saves in a log all the errors gotten.
"
Class {
	#name : #SError,
	#superclass : #Error,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #exceptioninstantiator }
SError class >> signal: anObject [
	^ self new signal: anObject 
]

{ #category : #signaling }
SError >> signal: message [
	SConfiguration saveOnLog: message.
	super signal: message
]
