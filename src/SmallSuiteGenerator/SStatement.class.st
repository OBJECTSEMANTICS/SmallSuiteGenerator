Class {
	#name : #SStatement,
	#superclass : #Object,
	#instVars : [
		'id',
		'returnTypeName'
	],
	#classVars : [
		'counter'
	],
	#category : #'SmallSuiteGenerator-Statement'
}

{ #category : #'class initialization' }
SStatement class >> create [
	| inst |
	inst := self new.
	inst id: counter.
	counter := counter + 1.
	^ inst
]

{ #category : #'class initialization' }
SStatement class >> initialize [
	super initialize.
	counter := 0.
	
]

{ #category : #'class initialization' }
SStatement class >> reset [
	counter := 0.
]

{ #category : #accessing }
SStatement >> id [
	^ id
]

{ #category : #accessing }
SStatement >> id: anInteger [
	id:= anInteger.
]

{ #category : #accessing }
SStatement >> isConstructor [
	^ false
]

{ #category : #accessing }
SStatement >> isField [
	^ false.
]

{ #category : #accessing }
SStatement >> isMethod [
	^ false.
]

{ #category : #accessing }
SStatement >> isPrimitive [
	^ false
]

{ #category : #printing }
SStatement >> printOn: aStream [
	^ self subclassResponsibility.
]

{ #category : #accessing }
SStatement >> returnTypeName [
	^ returnTypeName
]

{ #category : #accessing }
SStatement >> returnTypeName: anObject [
	returnTypeName := anObject
]

{ #category : #accessing }
SStatement >> varName [
	^ self variableKeyword , id asString
]

{ #category : #'as yet unclassified' }
SStatement >> variableKeyword [
	^  '_var'

]
