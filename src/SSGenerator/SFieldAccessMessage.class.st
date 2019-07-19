Class {
	#name : #SFieldAccessMessage,
	#superclass : #SAbstractMessage,
	#category : #'SSGenerator-Nodes'
}

{ #category : #'instance creation' }
SFieldAccessMessage class >> newFromReceiver: aReceiver andMethod: aMethod [
	^ SFieldAccessMessage new
		returnType: aMethod returnType;
		selector: aMethod selector;
		receiver: aReceiver;
		yourself
]

{ #category : #'as yet unclassified' }
SFieldAccessMessage >> changeSelectorFrom: aExpression in: aTestCase [
	| otherFieldAccessMessage |
	otherFieldAccessMessage := aTestCase
		alternativeFieldAccessMessage: self
		before: aExpression.
	self selector: otherFieldAccessMessage selector
	"aTestCase replaceFrom: aExpression with: otherFieldAccessMessage"
]

{ #category : #'as yet unclassified' }
SFieldAccessMessage >> insertParameterUsing: aTestCase [
	self error: 'cant insert parameter'
]

{ #category : #actions }
SFieldAccessMessage >> replaceArg: expressions by: newExpressions [
]
