"
SAssignment is a node which is compossed by a variable and an expression.

For example: 
	1.	
		_var0 := 1.
	
		_var0 -> Variable.
		1 -> value (in this case a literal).
		
	2. 
		_var1 := SFoo new.
		
		_var1 -> Varaible
		SFoo new -> an instance of factoryMessage
"
Class {
	#name : #SAssignment,
	#superclass : #SExpression,
	#instVars : [
		'variable',
		'value'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SAssignment class >> name: aVariable value: anExpression [
	^ self new
		variable:  aVariable;
		value: anExpression;
		returnType: anExpression returnType;
		yourself
]

{ #category : #comparing }
SAssignment >> = other [
	^ (super = other) 
		and: [ (variable = other variable) 
			and: [ (value = other value) ] ]
]

{ #category : #visitor }
SAssignment >> accept: aSSVisitor [
	^ aSSVisitor visitAssignment: self.
]

{ #category : #actions }
SAssignment >> changeOn: aTestCase [
	^ self value changeOn: aTestCase.
]

{ #category : #querying }
SAssignment >> containsVariable: aVariable [
	^ self value containsVariable: aVariable.
]

{ #category : #copying }
SAssignment >> copy [ 
	|copy|
	copy := super copy.
	copy variable: variable copy;
	value: value copy.
	^ copy
]

{ #category : #actions }
SAssignment >> fixWith: anObject in: aTestCase [
	value fixWith: anObject in: aTestCase.
	returnType := value returnType.
	variable returnType: value returnType.
]

{ #category : #comparing }
SAssignment >> hash [
	^ super hash bitXor: (variable hash bitXor: value hash)
]

{ #category : #accessing }
SAssignment >> id [ 		
	^ variable id
]

{ #category : #initialization }
SAssignment >> initialize [ 	
	super initialize.
]

{ #category : #actions }
SAssignment >> insertOn: aTestCase [
	^ value insertOn: aTestCase
]

{ #category : #querying }
SAssignment >> isThereEnoughArgumentsToBuild: aTestCase [
	^ self value isThereEnoughArgumentsToBuild: aTestCase
]

{ #category : #querying }
SAssignment >> pickUpReferences: aExpression [
	^ value pickUpReferences: aExpression
]

{ #category : #querying }
SAssignment >> reference [ 
	^ variable
]

{ #category : #querying }
SAssignment >> referenceTo: aClassName [
	^ value referenceTo: aClassName
]

{ #category : #evaluating }
SAssignment >> value [ 
	^ value
]

{ #category : #accessing }
SAssignment >> value: anObject [
	value := anObject
]

{ #category : #accessing }
SAssignment >> variable [
	^ variable
]

{ #category : #accessing }
SAssignment >> variable: anObject [
	variable := anObject
]
