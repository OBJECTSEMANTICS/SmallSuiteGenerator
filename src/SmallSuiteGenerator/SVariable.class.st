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

{ #category : #comparing }
SVariable >> = other [
	^ super = other and: [ varName = other varName ]
]

{ #category : #copying }
SVariable >> copy [
	| copy |
	copy := super copy.
	copy
		varName: varName copy.
	^ copy
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

{ #category : #mutation }
SVariable >> pickUpReferences: anExpression [
	^ self = anExpression reference
		ifFalse: [ #() ]
		ifTrue: [ (Array with: self) ]
]

{ #category : #printing }
SVariable >> printOn: aStream [
	SPlatform asDict 
		ifFalse: [
			aStream nextPutAll: varName.
			id ifNotNil: [ aStream nextPutAll: id printString ]]
		ifTrue: [
			aStream nextPutAll: '( var at: '.
			id ifNil: [ aStream nextPutAll: varName. ]
			ifNotNil: [ aStream nextPutAll: (id+1) printString . ].
			aStream nextPutAll: ' )']
]

{ #category : #accessing }
SVariable >> referenceTo: aClassName [
	^ self returnType = aClassName
]

{ #category : #mutation }
SVariable >> repairOn: aTestCase changing: anExpression [
	| otherVariable |
	otherVariable := aTestCase
		alternativeOfVariable: self
		before: anExpression.
	mutated := otherVariable ~= self.
	self varName: otherVariable varName.
	self id: otherVariable id.
]

{ #category : #mutation }
SVariable >> replaceArgBy: expression [
	returnType = expression returnType
		ifFalse: [ ^ self
				error:
					'Cannot replace argument of type: ' , returnType , ' by: '
						, expression returnType ].
	self replaceBy: expression
]

{ #category : #accessing }
SVariable >> replaceBy: otherVariable [
	" I replace my attributes values with the ones in the otherExpression.
	  the argument is an object from my same class"
	self varName: otherVariable varName.
	self id: otherVariable id.
	self returnType: otherVariable returnType
]

{ #category : #actions }
SVariable >> replaceExpression: anExpression by: newExpression [
	"If I am referencing to anExprension. I will now reference to the newExpresion"	
	| reference |
	self = anExpression
		ifFalse: [ ^ self ].
	reference := newExpression reference.
	self
		id: reference id;
		varName: reference varName;
		returnType: reference returnType;
		mutated: true
]

{ #category : #accessing }
SVariable >> varName [
	^ varName
]

{ #category : #accessing }
SVariable >> varName: anObject [
	varName := anObject
]

{ #category : #mutation }
SVariable >> variablesWithId [
	^ id ifNotNil: [ (Array with: self) ] ifNil: [ super variablesWithId ]
]
