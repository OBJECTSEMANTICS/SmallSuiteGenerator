"
SMultiTypeInfo is a set of types.

Instance Variables
	types:		<Set>
"
Class {
	#name : #SMultiTypeInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'types',
		'cleanTypes',
		'mustBeFixed'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'instance creation' }
SMultiTypeInfo class >> new: aType [
	^ self new type: aType
]

{ #category : #comparing }
SMultiTypeInfo >> = other [
	^ self class = other class and: [ self types = other types ]
]

{ #category : #accessing }
SMultiTypeInfo >> cleanTypes: anObject [
	cleanTypes := anObject 
]

{ #category : #accessing }
SMultiTypeInfo >> cleanTypesIn: aTypeInfo [
	cleanTypes ifNotNil: [ ^ cleanTypes ].
	cleanTypes := aTypeInfo intersect: self types.
	^ cleanTypes
]

{ #category : #accessing }
SMultiTypeInfo >> commonSuperclass [
	| commonSuperclass |
	types ifEmpty: [ ^ '' ].
	commonSuperclass := SPlatform lookUpClass: types anyOne.
	commonSuperclass ifNil: [ ^ '' ].
	types
		do: [ :aType | 
			| otherClass |
			otherClass := SPlatform lookUpClass: aType.
			otherClass ifNil: [ ^ '' ].
			(commonSuperclass isClass and: [ commonSuperclass name = #Object ])
				ifTrue: [ ^ #Object ].
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
	(self types size = other types size) ifFalse:[ ^ false ].
	
	self types asOrderedCollection with: (other types asOrderedCollection) do:[ :a :b|
		(a = b) ifFalse:[ ^ false ].
	].
	^ true.
]

{ #category : #'instance creation' }
SMultiTypeInfo >> fromSton: stonReader [
	stonReader
		parseListDo: [ :each :index | 
			self type: each ]

	
]

{ #category : #metrics }
SMultiTypeInfo >> hasOnlyOneType [
	^ types size <= 1.
]

{ #category : #comparing }
SMultiTypeInfo >> hash [
	^ self types hash
]

{ #category : #testing }
SMultiTypeInfo >> includes: aType [
	^ self types includes: aType
]

{ #category : #initialization }
SMultiTypeInfo >> initialize [
	types := Set new.
	mustBeFixed := false
]

{ #category : #metrics }
SMultiTypeInfo >> isBlockSymbol [
	
	^ types size = 2 
		and: [ (types anySatisfy: [ :aType | aType = #BlockClosure ]) 
			and: [ types anySatisfy:[ :aType | aType = #ByteSymbol ] ] ]
]

{ #category : #actions }
SMultiTypeInfo >> joinWith: otherTypeReturn [
	| hasOneType |
	hasOneType := self hasOnlyOneType.	
	(otherTypeReturn types difference: self types) do: [ :aType | 
		self type: aType.
		self resetTypes. ].
	types size > 1 ifTrue: [ types remove: #SUndefinedObject ifAbsent: [ ] ].
	mustBeFixed := hasOneType and: [ types size > 1 ]
]

{ #category : #accessing }
SMultiTypeInfo >> mustBeFixed [ 
	^ mustBeFixed
]

{ #category : #accessing }
SMultiTypeInfo >> removeType: aType [
	types remove: aType ifAbsent: [  ]
]

{ #category : #actions }
SMultiTypeInfo >> resetTypes [
	self cleanTypes: nil
]

{ #category : #'ston persistence' }
SMultiTypeInfo >> stonOn: stonWriter [
	stonWriter
		writeObject: self
		streamShortList: [ :array | self types do: [:type | array add: type] ]
]

{ #category : #accessing }
SMultiTypeInfo >> type [
	^ types ifEmpty: [ nil ] ifNotEmpty: [ self random selectAtRandom: self types  ]
]

{ #category : #'accessing structure variables' }
SMultiTypeInfo >> type: aClassName [
	aClassName ~= #nil ifTrue: [ 
		types add: aClassName ]
]

{ #category : #accessing }
SMultiTypeInfo >> types [
	^ types asArray
]
