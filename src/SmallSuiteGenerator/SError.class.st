Class {
	#name : #SError,
	#superclass : #Error,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #signaling }
SError >> signal: message [
	SConfiguration saveOnLog: message.
	super signal: message
]
