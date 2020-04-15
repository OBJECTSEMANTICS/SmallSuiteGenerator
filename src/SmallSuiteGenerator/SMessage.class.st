"
SMessage is a node which represents method calls that not return an instance variable of a class. They are a little more complex. It can receive arguments also.

For example: 
	1.	
		_var1 returnCollection.
	
		_var1 -> Receiver which points to SFoo's factoryMessage.
		#returnCollection -> selector of the method.
		
	2. 
		_var1 return: _var2.
		
		_var1 -> Receiver
		#return: -> selector
		_var2 -> Argument of type ByteString
"
Class {
	#name : #SMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SMessage class >> newFromReceiver: aReceiver method: aMethod andPreviousStatements: statements [
	^ SMessage new
		returnType: (aMethod returnTypeFor: aReceiver);
		selector: aMethod selector;
		receiver: aReceiver;
		args: (self args: aMethod with: statements);
		needsBeFixed: aMethod hasProfiler not;
		yourself
]

{ #category : #override }
SMessage >> changeSelectorFrom: aExpression in: aTestCase [
	| otherMessage |
	otherMessage := aTestCase
		alternativeMessage: self
		before: aExpression.
	mutated := otherMessage selector ~= self selector.
	self selector: otherMessage selector.
	self args: otherMessage args
]

{ #category : #fixing }
SMessage >> fixWith: anObject in: aTestCase [
	(anObject receiver types includes: receiver returnType) ifFalse: [ self halt ].
	returnType := randomGenerator selectAtRandom: anObject returnType types.
	anObject argTypes with: args do: [ :arg1 :arg2 | 
		(arg1 types includes: arg2 returnType) ifFalse: [ self halt. ]
		 ].
	needsBeFixed := false.
]

{ #category : #mutation }
SMessage >> insertMethodMessage: aExpression using: aTestCase [
	^ self insertRandomMessage: aExpression using: aTestCase
]

{ #category : #mutation }
SMessage >> insertOn: aTestCase [
	^ aTestCase addMessage: self selector from: self receiver returnType
]
