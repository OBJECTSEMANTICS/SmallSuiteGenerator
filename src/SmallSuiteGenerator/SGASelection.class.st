"
Abstract class for strategy selection
"
Class {
	#name : #SGASelection,
	#superclass : #SGAObject,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #initialization }
SGASelection >> initialize [
	randomGenerator := SPlatform randomGenerator.
]
