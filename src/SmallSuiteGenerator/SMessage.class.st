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

{ #category : #visitor }
SMessage >> accept: aSSVisitor [
	aSSVisitor visitMessage: self.
]

{ #category : #action }
SMessage >> insertOn: aTestCase [
	^ aTestCase addMessage: self selector from: self receiver returnType.
]

{ #category : #testing }
SMessage >> isMessage [
	^ true.
]
