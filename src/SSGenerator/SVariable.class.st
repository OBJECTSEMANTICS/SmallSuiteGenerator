Class {
	#name : #SVariable,
	#superclass : #SExpression,
	#instVars : [
		'varName'
	],
	#category : #'SSGenerator-Nodes'
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
	copy varName: varName copy.
	^ copy
]

{ #category : #comparing }
SVariable >> hash [
	^ super hash xor: varName  hash
]

{ #category : #initialization }
SVariable >> initialize [
	varName := '_var'
]

{ #category : #printing }
SVariable >> printOn: aStream [
	aStream nextPutAll: varName.
	id ifNotNil: [ aStream nextPutAll: id asString ]
]

{ #category : #'as yet unclassified' }
SVariable >> references: anExpression [
	^ self = anExpression reference
		ifFalse: [ #() ]
		ifTrue: [ self ]
]

{ #category : #accessing }
SVariable >> varName [
	^ varName
]

{ #category : #accessing }
SVariable >> varName: anObject [
	varName := anObject
]
