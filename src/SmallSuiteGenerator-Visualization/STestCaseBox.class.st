Class {
	#name : #STestCaseBox,
	#superclass : #RTCompositeShape,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #adding }
STestCaseBox >> add: aTestCase [
	aTestCase statements do: [ :statement | 
		self add: statement shapeOf translateBy: 0 @ 0
	]
]
