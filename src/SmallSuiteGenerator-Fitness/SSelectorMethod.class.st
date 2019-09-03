Class {
	#name : #SSelectorMethod,
	#superclass : #Object,
	#classInstVars : [
		'functions'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SSelectorMethod class >> functions: collFunction [
	functions := collFunction
]

{ #category : #testing }
SSelectorMethod class >> is: aTestCase1 betterThan: aTestCase2 [
	^ self subclassResponsibility 
]
