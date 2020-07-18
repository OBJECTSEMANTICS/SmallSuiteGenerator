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

{ #category : #actions }
SLiteral >> changeOn: aTestCase [
	|copy|
	copy := self copy.
	copy value: value mutateToChange.
	aTestCase addAssignment: copy.
]

{ #category : #querying }
SLiteral >> containsVariable: aVariable [
	^ false.
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

{ #category : #actions }
SLiteral >> insertOn: aTestCase [
	^ aTestCase addLiteral: self returnType.
]

{ #category : #actions }
SLiteral >> interpret: aExecutionContext [
  ^ value.
]

{ #category : #actions }
SLiteral >> negateId [
	"nothing to negate"
]

{ #category : #printing }
SLiteral >> printOn: aStream [
	aStream
		nextPutAll:
			((value isNumber or: [ value isBlock ])
				ifTrue: [ value printString ]
				ifFalse: [ value storeString ])
]

{ #category : #querying }
SLiteral >> referenceTo: aClassName [
	^( value isClass
		ifTrue: [ value name ]
		ifFalse: [ value className ]) = aClassName asString
]

{ #category : #actions }
SLiteral >> rename: aDictionary [
	"nothing to rename"
]

{ #category : #evaluating }
SLiteral >> value [ 	
	^ value
]

{ #category : #accessing }
SLiteral >> value: anObject [
	value := anObject.
]
