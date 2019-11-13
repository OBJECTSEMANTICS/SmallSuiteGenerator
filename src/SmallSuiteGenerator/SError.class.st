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
	SConfiguration defaultFileLogger record: message.
	super signal: message
]
