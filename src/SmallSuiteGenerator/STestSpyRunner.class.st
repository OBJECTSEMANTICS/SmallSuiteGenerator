Class {
	#name : #STestSpyRunner,
	#superclass : #SSTestRunner,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #actions }
STestSpyRunner >> load: aSTestCase [
	| node |
	node := aSTestCase parseTree.
	node body addNode: (RBParser parseExpression: '^ self analyze: thisContext').
	self compile: node.
]
