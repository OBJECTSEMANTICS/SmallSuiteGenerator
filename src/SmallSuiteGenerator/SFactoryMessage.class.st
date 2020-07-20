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
	#category : #'SmallSuiteGenerator-Core'
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
	^ aSSVisitor visitFactoryMessage: self.
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

{ #category : #'as yet unclassified' }
SFactoryMessage >> stmColor [
  ^ Color cyan
"Color r: 0.01857282502443793 g: 0.2512218963831867 b: 0.9110459433040078"
"Color r: 0.1573802541544477 g: 0.3196480938416422 b: 0.5141739980449658"
"Color r: 0.21407624633431085 g: 0.3831867057673509 b: 0.6803519061583577"
]
