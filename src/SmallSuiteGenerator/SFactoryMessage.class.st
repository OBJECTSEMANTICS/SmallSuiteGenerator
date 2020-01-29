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

{ #category : #creation }
SFactoryMessage class >> method: aMethodTypeInfo class: aClassName previousStatements: statements [
	^ self new
		receiver:
			(SVariable new
				varName: aClassName;
				returnType: aClassName ;
				yourself);
		returnType: aClassName;
		selector: aMethodTypeInfo selector;
		args: (self args: aMethodTypeInfo with: statements);
		yourself
]

{ #category : #creation }
SFactoryMessage class >> method: aMethodTypeInfo previousStatements: statements [
	|returnType|
	returnType := aMethodTypeInfo returnType type.
	^ self new
		receiver:
			(SVariable new
				varName: returnType ;
				returnType: returnType ;
				yourself);
		returnType: returnType;
		selector: aMethodTypeInfo selector;
		args: (self args: aMethodTypeInfo with: statements);
		yourself
]

{ #category : #override }
SFactoryMessage >> changeSelectorFrom: aExpression in: aTestCase [
	| otherFactoryMessage |
	otherFactoryMessage := aTestCase
		alternativeFactoryMessage: self
		before: aExpression.
	self selector: otherFactoryMessage selector.
	self args: otherFactoryMessage args
]

{ #category : #mutation }
SFactoryMessage >> insertOn: aTestCase [
	^ aTestCase
		addFactoryMessage: self returnType
		ofSelector: self selector
]

{ #category : #testing }
SFactoryMessage >> isFactoryMessage [
	^ true
]

{ #category : #accessing }
SFactoryMessage >> referenceTo: aClassName [
	^ receiver referenceTo: aClassName
]

{ #category : #'as yet unclassified' }
SFactoryMessage >> shapeOf [
	^ RTBox new color: Color cyan; size: 20
]

{ #category : #'as yet unclassified' }
SFactoryMessage >> stmColor [
  ^ Color r: 0.01857282502443793 g: 0.2512218963831867 b: 0.9110459433040078
"Color r: 0.1573802541544477 g: 0.3196480938416422 b: 0.5141739980449658"
"Color r: 0.21407624633431085 g: 0.3831867057673509 b: 0.6803519061583577"
]
