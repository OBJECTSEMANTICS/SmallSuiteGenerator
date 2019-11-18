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
	^ SLiteral new value: aValue; yourself.
]

{ #category : #comparing }
SLiteral >> = other [
	^ super = other
		and: [ value isLiteral ifTrue: [ value = other value ] 
			ifFalse: [ 
			value isClass
				ifTrue: [ value name = other value name ]
				ifFalse: [ value className = other value className ]] ]
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
	^ super hash xor: value hash
]

{ #category : #mutation }
SLiteral >> insertOn: aTestCase [
	^ aTestCase addLiteral: self returnType
]

{ #category : #printing }
SLiteral >> printOn: aStream [
	aStream
		nextPutAll:
			(value isNumber
				ifTrue: [ value printString ]
				ifFalse: [ value storeString ])
]

{ #category : #accessing }
SLiteral >> referenceTo: aClassName [
	^( value isClass
		ifTrue: [ value name ]
		ifFalse: [ value className ]) = aClassName
]

{ #category : #mutation }
SLiteral >> repairOn: aTestCase changing: aExpression [
	self value: value mutateToChange
]

{ #category : #accessing }
SLiteral >> replaceBy: otherExpression [
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
