"
SGACrossoverRate is a technique where two individuals crossover if and only if the next random number is less than crossoverRate (by default 0.8)
"
Class {
	#name : #SGACrossoverRate,
	#superclass : #SGACrossover,
	#instVars : [
		'crossoverRate'
	],
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #initialization }
SGACrossoverRate >> crossoverRate: aFloat [
	crossoverRate := aFloat.
]

{ #category : #initialization }
SGACrossoverRate >> initialize [ 
	super initialize.
	crossoverRate := 0.8.
]

{ #category : #initialization }
SGACrossoverRate >> shouldCrossOver: testCaseA with: testCaseB [
	
	^ (self next < crossoverRate) 
		and: [ testCaseA validReferences 
			and: [ testCaseB validReferences ] ]
]
