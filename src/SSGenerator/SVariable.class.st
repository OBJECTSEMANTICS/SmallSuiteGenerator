Class {
	#name : #SVariable,
	#superclass : #SExpression,
	#instVars : [
		'nameVar'
	],
	#category : #'SSGenerator-Nodes'
}

{ #category : #accessing }
SVariable class >> name: aString [
	|variable|
	variable := self new.
	variable name: aString.
	^ variable.
]

{ #category : #comparing }
SVariable >> = other [
	^ super = other and: [ nameVar = other varName ]
]

{ #category : #copying }
SVariable >> copy [ 	
	|copy|
	copy := super copy.
	copy varName: nameVar copy.
	^ copy
]

{ #category : #comparing }
SVariable >> hash [
	^ super hash xor: nameVar hash
]

{ #category : #initialization }
SVariable >> initialize [
	nameVar := '_var'
]

{ #category : #printing }
SVariable >> printOn: aStream [
	aStream
		nextPutAll: nameVar.
	id ifNotNil: [ 
		aStream nextPutAll: id asString]
]

{ #category : #accessing }
SVariable >> varName [
	^ nameVar
]

{ #category : #accessing }
SVariable >> varName: anObject [
	nameVar := anObject
]
