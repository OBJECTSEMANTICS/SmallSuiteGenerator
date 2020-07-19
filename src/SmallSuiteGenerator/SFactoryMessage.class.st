"
SFactoryMessage is a node that represents the class' creation with methods of meta class.

For example: 

	1.	
		SStack newStack.
	
		#SStack -> It's the receiver 
		#newStack -> It's a method of meta class.
		
	2. 
		SFoo score: _var1.
		
		#SFoo -> Receiver
		#score: -> Message of receiver
		_var1 -> Argument 
		
	3. 
		SFoo new.
		
		#SFoo new -> Receiver
		#new -> Default selector
"
Class {
	#name : #SFactoryMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #accessing }
SFactoryMessage class >> default: aClassName [
	^ self new
		receiver:
			(SVariable new
				varName: aClassName;
				returnType: aClassName;
				yourself);
		selector: #new;
		returnType: aClassName;
		yourself
]

{ #category : #visitor }
SFactoryMessage >> accept: aSSVisitor [
	aSSVisitor visitFactoryMessage: self.
]

{ #category : #action }
SFactoryMessage >> changeOn: aTestCase [
	"nothing to change"
	aTestCase addAlternativeFactoryMessage: self.
]

{ #category : #action }
SFactoryMessage >> insertOn: aTestCase [
	^ aTestCase
		addFactoryMessage: self returnType
		usingSelector: self selector.
]

{ #category : #testing }
SFactoryMessage >> isFactoryMessage [
	^ true
]

{ #category : #querying }
SFactoryMessage >> referenceTo: aClassName [
	^ receiver referenceTo: aClassName
]
