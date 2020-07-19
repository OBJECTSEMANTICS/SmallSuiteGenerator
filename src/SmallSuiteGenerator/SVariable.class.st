"
SVariable is a node which is represented by a name and id.

For example: 
	1.	
		_var2
		
		_var -> Name of variable.
		2 -> Id of variable
		
	2. 
		_int3
		
		'_int' -> Name
		3 -> Id
"
Class {
	#name : #SVariable,
	#superclass : #SExpression,
	#instVars : [
		'varName'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #accessing }
SVariable class >> name: aString [
	| variable |
	variable := self new.
	variable varName: aString.
	^ variable
]

{ #category : #accessing }
SVariable class >> nameOrId: anObject [
	| variable |
	variable := self new.
	anObject isString 
		ifTrue: [ variable varName: anObject ]
		ifFalse: [ variable id: (anObject - 1) ].
	^ variable
]

{ #category : #comparing }
SVariable >> = other [
	^ self containsVariable: other.
]

{ #category : #visitor }
SVariable >> accept: aSSVisitor [
	aSSVisitor visitVariable: self.
]

{ #category : #actions }
SVariable >> changeOn: aTestCase [
	"nothing to change"
]

{ #category : #querying }
SVariable >> containsVariable: aVariable [
	self id ifNil:[ ^ self varName = aVariable varName].
	^ self id = aVariable id.
	
]

{ #category : #copying }
SVariable >> copy [
	| copy |
	copy := super copy.
	copy
		varName: varName copy.
	^ copy
]

{ #category : #actions }
SVariable >> fix [
	self id: (varName allButFirst: 4) asInteger.
	self varName:  '_var'.
]

{ #category : #accessing }
SVariable >> fullName [
  self id ifNil:[ ^ self varName].
  ^self varName , self id asString
]

{ #category : #comparing }
SVariable >> hash [
	^ super hash bitXor: varName  hash
]

{ #category : #initialization }
SVariable >> initialize [
	super initialize.
	varName := '_var'
]

{ #category : #actions }
SVariable >> interpret: aExecutionContext [
  ^aExecutionContext at: self fullName.
]

{ #category : #accessing }
SVariable >> key [
	SPlatform asDict ifTrue: [ ^ id + 1 ] ifFalse: [ ^ self printString asSymbol ]

]

{ #category : #actions }
SVariable >> negateId [
	id ifNotNil:[id := id * -1.].
	
]

{ #category : #querying }
SVariable >> pickUpReferences: anExpression [
	^ self = anExpression reference
		ifFalse: [ #() ]
		ifTrue: [ (Array with: self) ]
]

{ #category : #querying }
SVariable >> referenceTo: aClassName [
	^ self returnType = aClassName
]

{ #category : #actions }
SVariable >> rename: aDictionary [

	id ifNotNil:[ id := aDictionary at: id. ].
]

{ #category : #accessing }
SVariable >> varName [
	^ varName
]

{ #category : #accessing }
SVariable >> varName: anObject [
	varName := anObject
]

{ #category : #querying }
SVariable >> variablesWithId [
	^ id ifNotNil: [ (Array with: self) ] ifNil: [ super variablesWithId ]
]
