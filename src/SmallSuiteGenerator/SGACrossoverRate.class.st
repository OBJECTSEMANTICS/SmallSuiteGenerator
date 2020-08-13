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

	^ self next < crossoverRate
]
