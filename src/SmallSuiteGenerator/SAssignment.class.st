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
	#category : #'SmallSuiteGenerator-AST'
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
	^ (super = other) and: [ (variable = other variable) and: [ value = other value ] ]
]

{ #category : #copying }
SAssignment >> copy [ 
	|copy|
	copy := super copy.
	copy variable: variable copy;
	value: value copy.
	^ copy
]

{ #category : #comparing }
SAssignment >> hash [
	^ super hash bitXor: (variable hash bitXor: value hash)
]

{ #category : #accessing }
SAssignment >> id [ 		
	^ variable id
]

{ #category : #mutation }
SAssignment >> insertAsParameter: aExpression using: aTestCase [
	^ variable insertAsParameter: aExpression using: aTestCase
]

{ #category : #mutation }
SAssignment >> insertMethodMessage: aExpression using: aTestCase [
	^ value insertMethodMessage: aExpression using: aTestCase
]

{ #category : #mutation }
SAssignment >> insertOn: aTestCase [
	^ value insertOn: aTestCase
]

{ #category : #mutation }
SAssignment >> insertRandomMessage: aExpression using: aTestCase [
	^ value insertRandomMessage:aExpression using: aTestCase
]

{ #category : #mutation }
SAssignment >> pickUpReferences: aExpression [
	^ value pickUpReferences: aExpression
]

{ #category : #printing }
SAssignment >> printOn: aStream [
	variable printOn: aStream.
	aStream nextPutAll: ' := '.
	value printOn: aStream.
	aStream nextPut:$.
]

{ #category : #accessing }
SAssignment >> reference [ 
	^ variable
]

{ #category : #accessing }
SAssignment >> referenceTo: aClassName [
	^ value referenceTo: aClassName
]

{ #category : #mutation }
SAssignment >> repairOn: aTestCase changing: expression [
	self reference = expression reference
		ifTrue: [ value repairOn: aTestCase changing: expression ]
]

{ #category : #mutation }
SAssignment >> replaceArgBy: expression [
	value replaceArgBy: expression
]

{ #category : #accessing }
SAssignment >> replaceBy: aExpression [
	self reference = aExpression reference ifTrue: [ value replaceBy: aExpression value ]
]

{ #category : #actions }
SAssignment >> replaceExpression: expression by: newExpression [
	value replaceExpression: expression by: newExpression
]

{ #category : #'as yet unclassified' }
SAssignment >> shapeOf [
	^ RTCompositeShape new 
	add: variable shapeOf;
	add: value shapeOf;
	horizontal;
	yourself
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

{ #category : #mutation }
SAssignment >> variablesWithId [
	^ variable variablesWithId, value variablesWithId
]
