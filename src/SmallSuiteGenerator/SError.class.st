Class {
	#name : #SError,
	#superclass : #Error,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #signaling }
SError >> signal: message [
	SConfiguration defaultFileLogger record: message.
	super signal: message
]
