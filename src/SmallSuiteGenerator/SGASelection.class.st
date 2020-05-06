"
Abstract class for strategy selection
"
Class {
	#name : #SGASelection,
	#superclass : #SGAObject,
	#instVars : [
		'fitness'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SGASelection >> fitness: anObject [ 
	fitness := anObject 
]

{ #category : #actions }
SGASelection >> fitnessFor: aTestCase [
	^ aTestCase fitness at: fitness functionName
]

{ #category : #initialization }
SGASelection >> initialize [
]
