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
	#category : #'SmallSuiteGenerator-Core'
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
	^ (self new 
			varName: (self variableName: anObject); 
			id: (self variableId: anObject); 
			yourself)
]

{ #category : #accessing }
SVariable class >> variableId: aString [
	^ ('_var*' match: aString) 
			ifTrue:[ (aString copyFrom: 5 to: aString size) asInteger ] 
			ifFalse:[nil].
]

{ #category : #accessing }
SVariable class >> variableName: aString [
	^('_var*' match: aString) ifTrue:[ '_var'] ifFalse:[ aString].
]

{ #category : #comparing }
SVariable >> = other [
	^ self containsVariable: other.
]

{ #category : #visitor }
SVariable >> accept: aSSVisitor [
	^ aSSVisitor visitVariable: self.
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

{ #category : #accessing }
SVariable >> key [
   self printerClass isDictionary 
		ifTrue: [ ^id + 1 ] 
		ifFalse: [ ^self printString asSymbol ]
]

{ #category : #querying }
SVariable >> pickUpReferences: anExpression [
	^ self = anExpression reference
		ifFalse: [ #() ]
		ifTrue: [ (Array with: self) ]
]

{ #category : #accessing }
SVariable >> printerClass [
  ^ SSTestCase defaultPrinterClass
]

{ #category : #querying }
SVariable >> referenceTo: aClassName [
	^ self returnType = aClassName
]

{ #category : #accessing }
SVariable >> varName [
	^ varName
]

{ #category : #accessing }
SVariable >> varName: anObject [
	varName := anObject
]
