Class {
	#name : #SGAOperation,
	#superclass : #SGAObject,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #initialization }
SGAOperation >> initialize [ 
	randomGenerator := SConfiguration newRandomGenerator 
]
