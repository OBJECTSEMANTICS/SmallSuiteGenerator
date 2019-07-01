Class {
	#name : #SVariable,
	#superclass : #SExpression,
	#instVars : [
		'nameVar'
	],
	#category : #SSGenerator
}

{ #category : #accessing }
SVariable class >> name: aString [
	|variable|
	variable := self new.
	variable name: aString.
	^ variable.
]

{ #category : #initialization }
SVariable >> initialize [
	nameVar := '_var'
]

{ #category : #accessing }
SVariable >> nameVar [
	^ nameVar
]

{ #category : #accessing }
SVariable >> nameVar: anObject [
	nameVar := anObject
]

{ #category : #printing }
SVariable >> printOn: aStream [
	aStream
		nextPutAll: nameVar.
	id ifNotNil: [ 
		aStream nextPutAll: id asString]
]
