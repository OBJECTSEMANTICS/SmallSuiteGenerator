Class {
	#name : #SGARankSelection,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SGARankSelection >> selectOf: aCollection [
	^ randomGenerator collectAtRandom: aCollection 
]
