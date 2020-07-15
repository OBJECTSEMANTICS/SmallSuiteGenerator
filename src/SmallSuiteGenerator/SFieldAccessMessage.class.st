"
SFieldAccessMessage is a node which represents method calls that return an instance variable of a class.

For example: 
	1.	
		_var1 x.
	
		_var1 -> Receiver which points to Point's factoryMessage.
		#x -> selector of the method
"
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
	mutated := otherFieldAccessMessage selector ~= self selector.
	self selector: otherFieldAccessMessage selector
]

{ #category : #fixing }
SFieldAccessMessage >> fixWith: anObject in: aTestCase [
	(anObject receiver types includes: receiver returnType) ifFalse: [ self halt ].
	returnType := self random selectAtRandom: anObject returnType types.
	needsBeFixed := false.
]

{ #category : #mutation }
SFieldAccessMessage >> insertOn: aTestCase [
	[^ aTestCase addFieldAccessMessage: self selector from: self receiver returnType] on: SError do: [  ]
]

{ #category : #actions }
SFieldAccessMessage >> replaceArg: expressions by: newExpressions [
]
