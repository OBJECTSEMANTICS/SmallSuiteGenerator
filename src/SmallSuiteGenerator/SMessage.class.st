Class {
	#name : #SMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SMessage class >> newFromReceiver: aReceiver method: aMethod andPreviousStatements: statements [
	^ SMessage new
		returnType: aMethod returnType type;
		selector: aMethod selector;
		receiver: aReceiver;
		args: (self args: aMethod with: statements);
		yourself
]

{ #category : #visiting }
SMessage >> accept: visitor [
	^ visitor visitMessage: self
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
SMessage >> insertOn: aTestCase [
	^ aTestCase addMessage: self selector from: self receiver returnType
]
