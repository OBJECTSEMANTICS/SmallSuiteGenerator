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
