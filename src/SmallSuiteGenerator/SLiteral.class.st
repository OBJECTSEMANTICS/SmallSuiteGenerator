"
SLiteral is a node which is compossed by a value that is included in typeInfo scalars.

For example: 
	1.	
		10
		
		10 -> SmallInteger.
		
	2. 
		'hello'
		
		'hello' -> ByteString.
"
Class {
	#name : #SLiteral,
	#superclass : #SExpression,
	#instVars : [
		'value'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #parsing }
SLiteral class >> value: aValue [
	^ self new value: aValue; yourself.
]

{ #category : #comparing }
SLiteral >> = other [
	^ super = other
		and: [ (value isLiteral ifTrue: [ value = other value ] 
			ifFalse: [ 
			value isClass
				ifTrue: [ value name = other value name ]
				ifFalse: [ value className = other value className ]]) ]
]

{ #category : #copying }
SLiteral >> copy [ 
	| copy|
	copy := super copy.
	copy value: value copy.
	^ copy
]

{ #category : #comparing }
SLiteral >> hash [
	^ super hash bitXor: value hash
]

{ #category : #mutation }
SLiteral >> insertOn: aTestCase [
	[^ aTestCase addLiteral: self returnType] on: SError do: [  ]
]

{ #category : #printing }
SLiteral >> printOn: aStream [
	aStream
		nextPutAll:
			((value isNumber or: [ value isBlock ])
				ifTrue: [ value printString ]
				ifFalse: [ value storeString ])
]

{ #category : #actions }
SLiteral >> referenceTo: aClassName [
	^( value isClass
		ifTrue: [ value name ]
		ifFalse: [ value className ]) = aClassName asString
]

{ #category : #mutation }
SLiteral >> repairOn: aTestCase changing: aExpression [
	self value: value mutateToChange
]

{ #category : #actions }
SLiteral >> replaceBy: otherExpression [
	" I replace my attributes values with the ones in the otherExpression.
	  the argument is an object from my same class"
	self value: otherExpression value
]

{ #category : #evaluating }
SLiteral >> value [ 	
	^ value
]

{ #category : #accessing }
SLiteral >> value: anObject [
	value := anObject.
]
