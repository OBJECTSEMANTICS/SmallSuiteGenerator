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
	aStream nextPutAll: varName.
	id ifNotNil: [ aStream nextPutAll: id asString ]
]

{ #category : #accessing }
SVariable >> referenceTo: aClassName [
	^ self returnType = aClassName
]

{ #category : #mutation }
SVariable >> repairOn: aTestCase changing: aExpression [
	| otherVariable |
	otherVariable := aTestCase
		alternativeOfVariable: self
		before: aExpression.
	self varName: otherVariable varName.
	self id: otherVariable id.
]

{ #category : #mutation }
SVariable >> replaceArgBy: anExpression [
	returnType = anExpression returnType
		ifFalse: [ ^ self error: 'cant replace arg' ].
	self replaceBy: anExpression
]

{ #category : #accessing }
SVariable >> replaceBy: otherVariable [
	self varName: otherVariable varName.
	self id: otherVariable id.
	self returnType: otherVariable returnType
]

{ #category : #actions }
SVariable >> replaceExpression: anExpression by: newExpression [
	| reference |
	self = anExpression
		ifFalse: [ ^ self ].
	reference := newExpression reference.
	self
		id: reference id;
		varName: reference varName;
		returnType: reference returnType
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
