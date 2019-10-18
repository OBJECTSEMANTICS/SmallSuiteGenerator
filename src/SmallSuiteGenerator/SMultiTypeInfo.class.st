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
	commonSuperclass ifNil: [ ^ '' ].
	types
		do: [ :aType | 
			|otherClass|
			otherClass := Smalltalk classNamed: aType asString.
			otherClass ifNil: [ ^ '' ].
			(commonSuperclass isClass and: [ commonSuperclass name = #Object ]) ifTrue: [ ^ #Object ].
			commonSuperclass := commonSuperclass
				commonSuperclassWith: otherClass ].
	^ commonSuperclass name
]

{ #category : #copying }
SMultiTypeInfo >> copy [
	| copy |
	copy := self class instance.
	types do: [ :aType | copy type: aType ].
	^ copy
]

{ #category : #comparing }
SMultiTypeInfo >> equals: other [
	(self types size = other types size) ifFalse:[ ^ false.].
	
	self types asOrderedCollection  with: (other types asOrderedCollection) do:[ :a :b|
		(a = b) ifFalse:[^ false].
	].
	^ true.
]

{ #category : #metrics }
SMultiTypeInfo >> hasOnlyOneType [
	^ types size <= 1.
]

{ #category : #initialization }
SMultiTypeInfo >> initialize [
	types := Set new
]

{ #category : #metrics }
SMultiTypeInfo >> isBlockSymbol [
	
	^ types size =  2 and:[ (types anySatisfy:[ :t| t= #BlockClosure]) and:[ types anySatisfy:[ :t| t= #ByteSymbol]]].
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
