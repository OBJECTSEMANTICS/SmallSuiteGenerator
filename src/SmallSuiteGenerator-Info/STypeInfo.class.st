Class {
	#name : #STypeInfo,
	#superclass : #Object,
	#instVars : [
		'types',
		'classes',
		'noneAbstractClasses',
		'scalars'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #adding }
STypeInfo >> addClassInfo: aTypeClassInfo [
	aTypeClassInfo typeInfo: self.
	types at: aTypeClassInfo typeName
	ifPresent: [ :aTypeClass | aTypeClass joinWith: aTypeClassInfo ]
	 ifAbsentPut: aTypeClassInfo
]

{ #category : #accessing }
STypeInfo >> classAt: aClassName [
	^ types at: aClassName
]

{ #category : #accessing }
STypeInfo >> classAt: aClassName ifNone: aBlock [
	^ types at: aClassName ifAbsent: aBlock
]

{ #category : #accessing }
STypeInfo >> classes [
	"classes
		ifNil: [ classes := types keys
				collect: [ :className | Smalltalk at: className ] ]."

	classes
		ifNil: [ classes := Dictionary new.
			types keysDo:
					[ :aClassName | classes at: aClassName put: (Smalltalk at: aClassName) ] ].
	^ classes
]

{ #category : #copying }
STypeInfo >> copy [
	| copy |
	copy := STypeInfo new.
	types
		valuesDo: [ :aClassTypeInfo | copy addClassInfo: aClassTypeInfo copy ].
	copy scalars: scalars copy.
	^ copy
]

{ #category : #'error handling' }
STypeInfo >> error: aString [
	^ SError signal: aString
]

{ #category : #lookup }
STypeInfo >> factoryMethods: className [
	^ types
		at: className
		ifPresent: [ :classInfo | 
			classInfo classMethodTypes associations
				select: [ :assoc | assoc value returnType type = className ]
				thenCollect: [ :assoc | assoc value ] ]
		ifAbsent: [ #() ]
]

{ #category : #initialization }
STypeInfo >> initialize [
	super initialize.
	types := Dictionary new.
	scalars := Dictionary new
]

{ #category : #'as yet unclassified' }
STypeInfo >> joinScalars: aDict [
	aDict associations
		do: [ :assoc | 
			scalars
				at: assoc key
				ifPresent: [ :values | scalars at: assoc key put: (values union: assoc value) ]
				ifAbsentPut: [ assoc value ] ]
]

{ #category : #'as yet unclassified' }
STypeInfo >> joinWith: otherTypeInfo [
	otherTypeInfo types
		valuesDo: [ :aTypeClass | self addClassInfo: aTypeClass ].
		self joinScalars: otherTypeInfo scalars
]

{ #category : #accessing }
STypeInfo >> noneAbstractClasses [
	noneAbstractClasses
		ifNil: [ noneAbstractClasses := self classes values
				reject: [ :aClass | 
					aClass isAbstract
						or: [ (aClass methods select: #isAbstract) isNotEmpty
								or: [ (aClass methods
										select: [ :meth | meth literals includes: #subclassResponsibility ])
										isNotEmpty ] ] ] ].
	^ noneAbstractClasses
]

{ #category : #accessing }
STypeInfo >> randomNoneAbstractClass [
	self assert: types isNotEmpty description: 'There is not a class'.
	^ self noneAbstractClasses shuffle anyOne
]

{ #category : #'as yet unclassified' }
STypeInfo >> scalar: aClassName with: aValue [
	scalars at: aClassName put: aValue asSet
]

{ #category : #accessing }
STypeInfo >> scalars [
	^ scalars 
]

{ #category : #accessing }
STypeInfo >> scalars: aDictionary [
	scalars := aDictionary
]

{ #category : #'accessing structure variables' }
STypeInfo >> type: aAssoc [
	self addClassInfo: (STypeClassInfo type: aAssoc)
]

{ #category : #lookup }
STypeInfo >> typeOf: aSelector from: aClassName [
	^ (types at: aClassName) methodOf: aSelector
]

{ #category : #lookup }
STypeInfo >> typeOf: aSelector fromMetaClassName: aClassName [
	^ (types at: aClassName) classMethodOf: aSelector
]

{ #category : #accessing }
STypeInfo >> types [ 
	^ types
]
