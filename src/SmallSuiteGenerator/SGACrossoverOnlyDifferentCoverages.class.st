Class {
	#name : #SGACrossoverOnlyDifferentCoverages,
	#superclass : #SGACrossover,
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #asserting }
SGACrossoverOnlyDifferentCoverages >> shouldCrossOver: testCaseA with: testCaseB [
	^ testCaseA fitness ~= testCaseB fitness
]
