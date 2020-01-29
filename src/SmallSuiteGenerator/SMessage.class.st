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
		yourself
]

{ #category : #override }
SMessage >> changeSelectorFrom: aExpression in: aTestCase [
	| otherMessage |
	otherMessage := aTestCase
		alternativeMessage: self
		before: aExpression.
	self selector: otherMessage selector.
			self args: otherMessage args
]

{ #category : #mutation }
SMessage >> insertMethodMessage: aExpression using: aTestCase [
	^ self insertRandomMessage: aExpression using: aTestCase
]

{ #category : #mutation }
SMessage >> insertOn: aTestCase [
	^ aTestCase addMessage: self selector from: self receiver returnType
]

{ #category : #'as yet unclassified' }
SMessage >> shapeOf [
	^ RTBox new color: Color green; size: 20
]

{ #category : #'as yet unclassified' }
SMessage >> stmColor [
  ^ Color r: 0.8885630498533724 g: 0.8611925708699902 b: 0.41642228739002934
"Color r: 0.9139784946236559 g: 0.8172043010752689 b: 0.4858260019550342"
]
