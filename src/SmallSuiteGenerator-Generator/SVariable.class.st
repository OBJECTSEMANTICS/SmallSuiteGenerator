Class {
	#name : #SVariable,
	#superclass : #SExpression,
	#instVars : [
		'varName'
	],
	#category : #'SmallSuiteGenerator-Generator-Nodes'
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

{ #category : #'as yet unclassified' }
SVariable >> pickUpReferences: anExpression [
	^ self = anExpression reference
		ifFalse: [ #() ]
		ifTrue: [ {self} ]
]

{ #category : #printing }
SVariable >> printOn: aStream [
	aStream nextPutAll: varName.
	id ifNotNil: [ aStream nextPutAll: id asString ]
]

{ #category : #mutation }
SVariable >> repairOn: aTestCase changing: aExpression [
	| otherVariable |
	otherVariable := aTestCase
		alternativeOfVariable: self
		before: aExpression.self halt.
	self varName: otherVariable varName.
	self id: otherVariable id
]

{ #category : #'as yet unclassified' }
SVariable >> replaceArgBy: aExpression [
	returnType = aExpression returnType
		ifFalse: [ ^ self error: 'cant replace arg' ].
	self replaceBy: aExpression
]

{ #category : #accessing }
SVariable >> replaceBy: otherVariable [
	self varName: otherVariable varName.
	self id: otherVariable id
]

{ #category : #actions }
SVariable >> replaceExpression: anExpression by: newExpression [
	| reference |
	self = anExpression
		ifFalse: [ ^ self ].
	reference := newExpression reference.
	self
		id: reference id;
		varName: reference varName
]

{ #category : #accessing }
SVariable >> varName [
	^ varName
]

{ #category : #accessing }
SVariable >> varName: anObject [
	varName := anObject
]

{ #category : #'as yet unclassified' }
SVariable >> variablesWithId [
	^ id ifNotNil: [ { self } ] ifNil: [ super variablesWithId  ]
]
