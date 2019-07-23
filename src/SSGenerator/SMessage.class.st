Class {
	#name : #SMessage,
	#superclass : #SAbstractMessage,
	#category : #'SSGenerator-Nodes'
}

{ #category : #'instance creation' }
SMessage class >> newFromReceiver: aReceiver method: aMethod andPreviousStatements: statements [
	^ SMessage new
		returnType: aMethod returnType;
		selector: aMethod selector;
		receiver: aReceiver;
		args: (self args: aMethod with: statements);
		yourself
]

{ #category : #'as yet unclassified' }
SMessage >> changeSelectorFrom: aExpression in: aTestCase [
	| otherMessage |
	otherMessage := aTestCase
		alternativeMessage: self
		before: aExpression.
	self selector: otherMessage selector.
	self args: otherMessage args
]

{ #category : #'as yet unclassified' }
SMessage >> insertMethodMessage: aExpression using: aTestCase [
	^ self insertRandomMessage: aExpression using: aTestCase
]

{ #category : #'as yet unclassified' }
SMessage >> insertRandomMessage: aExpression using: aTestCase [
	| expression |
	expression := self expressionWithMaxIndex: aTestCase.
	^ (aTestCase insertExpression: self copy after: expression) reference
]
