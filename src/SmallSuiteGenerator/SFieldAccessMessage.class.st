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
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SFieldAccessMessage class >> newFromReceiver: aReceiver andMethod: aMethod [

	^ self new
		returnType: aMethod returnType type;
		selector: aMethod selector;
		receiver: aReceiver;
		yourself 
]

{ #category : #visitor }
SFieldAccessMessage >> accept: aSSVisitor [

	^ aSSVisitor visitFieldAccessMessage: self.
]

{ #category : #actions }
SFieldAccessMessage >> changeOn: aTestCase [

	aTestCase addAlternativeFieldAccessMessage: self.
]

{ #category : #actions }
SFieldAccessMessage >> insertOn: aTestCase [

	^ aTestCase addFieldAccessMessage: self selector from: self receiver returnType.
]
