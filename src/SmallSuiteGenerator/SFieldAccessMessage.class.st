Class {
	#name : #SFieldAccessMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SFieldAccessMessage class >> newFromReceiver: aReceiver andMethod: aMethod [
	^ SFieldAccessMessage new
		returnType: aMethod returnType type;
		selector: aMethod selector;
		receiver: aReceiver;
		yourself
]

{ #category : #override }
SFieldAccessMessage >> changeSelectorFrom: expression in: aTestCase [
	| otherFieldAccessMessage |
	otherFieldAccessMessage := aTestCase
		alternativeFieldAccessMessage: self.
	self selector: otherFieldAccessMessage selector
]

{ #category : #mutation }
SFieldAccessMessage >> insertOn: aTestCase [
	^ aTestCase addFieldAccessMessage: self selector from: self receiver returnType
]

{ #category : #actions }
SFieldAccessMessage >> replaceArg: expressions by: newExpressions [
]
