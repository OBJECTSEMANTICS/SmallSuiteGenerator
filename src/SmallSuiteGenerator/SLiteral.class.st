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
	#category : #'SmallSuiteGenerator-Core'
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

{ #category : #visitor }
SLiteral >> accept: aSSVisitor [
	^ aSSVisitor visitLiteral: self.
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

{ #category : #querying }
SLiteral >> referenceTo: aClassName [
	^( value isClass
		ifTrue: [ value name ]
		ifFalse: [ value className ]) = aClassName asString
]

{ #category : #'as yet unclassified' }
SLiteral >> stmColor [
  ^ Color r: 0.2072336265884653 g: 0.8504398826979472 b: 0.1573802541544477
"Color r: 0.2072336265884653 g: 0.5503421309872922 b: 0.19745845552297164"
"Color r: 0.5953079178885631 g: 0.7644183773216031 b: 0.1466275659824047"
]

{ #category : #evaluating }
SLiteral >> value [ 	
	^ value
]

{ #category : #accessing }
SLiteral >> value: anObject [
	value := anObject.
]
