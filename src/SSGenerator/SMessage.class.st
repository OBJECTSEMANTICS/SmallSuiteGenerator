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
SMessage >> insertMethodMessageUsing: aTestCase [
	^ self insertRandomMessageUsing: aTestCase
]

{ #category : #'as yet unclassified' }
SMessage >> insertRandomMessageUsing: aTestCase [
	| expression |
	expression := self expressionWithMaxIndex: aTestCase.
	^ (aTestCase insertExpression: self copy after: expression) reference
]
