Class {
	#name : #SMultiTypeInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'types'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'instance creation' }
SMultiTypeInfo class >> new: aType [
	^ self new type: aType
]

{ #category : #comparing }
SMultiTypeInfo >> = otherType [
	^ types includes: otherType
]

{ #category : #'as yet unclassified' }
SMultiTypeInfo >> commonSuperclass [
	| commonSuperclass |
	types ifEmpty: [ ^ '' ].
	commonSuperclass := Smalltalk classNamed: types anyOne.
	types
		do: [ :aType | 
			commonSuperclass := commonSuperclass
				commonSuperclassWith: (Smalltalk classNamed: aType asString) ].
	^ commonSuperclass name
]

{ #category : #copying }
SMultiTypeInfo >> copy [
	| copy |
	copy := self class instance.
	types do: [ :aType | copy type: aType ].
	^ copy
]

{ #category : #initialization }
SMultiTypeInfo >> initialize [
	types := Set new
]

{ #category : #'as yet unclassified' }
SMultiTypeInfo >> joinWith: otherTypeReturn [
	otherTypeReturn types do: [ :aType | self type: aType ]
]

{ #category : #accessing }
SMultiTypeInfo >> type [
	^ types ifEmpty: [nil] ifNotEmpty: [types asArray shuffle anyOne]
]

{ #category : #'accessing structure variables' }
SMultiTypeInfo >> type: aClassName [
	aClassName ~= #nil ifTrue: [ 
	types add: aClassName]
]

{ #category : #accessing }
SMultiTypeInfo >> types [ 	
	^ types
]
