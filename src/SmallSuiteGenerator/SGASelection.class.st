Class {
	#name : #SGASelection,
	#superclass : #SGAObject,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #initialization }
SGASelection >> initialize [
	randomGenerator := SConfiguration newRandomGenerator.
]
