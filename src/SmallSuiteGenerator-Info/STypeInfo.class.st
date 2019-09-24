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

{ #category : #'as yet unclassified' }
STypeInfo >> accessMessagesFrom: aClassName [
	^ types
		flatCollect: [ :aClassType | 
			aClassType accessMessages
				select: [ :aMessage | aMessage receiver types includes: aClassName ] ]
]

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
	classes
		ifNil: [ classes := Dictionary new.
			types
				keysDo:
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

{ #category : #'as yet unclassified' }
STypeInfo >> exportDataCSV: neoCSVWriter withFilter: aSymbol [
	types
		do: [ :type | type exportDataCSV: neoCSVWriter withFilter: aSymbol ]
]

{ #category : #lookup }
STypeInfo >> factoryMessagesFrom: aClassName [
	^ types
		flatCollect: [ :aClassType | 
			aClassType factoryMessages
				select: [ :aMessage | aMessage receiver types includes: aClassName ] ]
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

{ #category : #'as yet unclassified' }
STypeInfo >> messagesFrom: aClassName [
	^ types
		flatCollect: [ :aClassType | 
			aClassType messages
				select: [ :aMessage | aMessage receiver types includes: aClassName ] ]
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
STypeInfo >> reportFrequencyByFilter [
	|report|
	report := Dictionary new.
	STypeMethodInfo selectorsFilter do: [ :aSelector | 
		report at: aSelector put: (types inject: 0 into: [ :sum :type | sum + (type reportFrequencyByFilter: aSelector)]) 
	 ].
	^ report
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
STypeInfo >> type: aSelector from: aClassName [
	types valuesDo: [ :aTypeClassInfo | 
			aTypeClassInfo messagesAndAccessMessages
				detect: [ :aMessage | 
					(aMessage isFromReceiver: aClassName)
						and: [ aMessage selector = aSelector ] ] ifFound: [:aMessage | ^ aMessage ] ifNone: [false]].
		^ self error: aSelector , ' not found in: ' , aClassName
]

{ #category : #lookup }
STypeInfo >> type: aSelector fromMetaClassName: aClassName [
	^ (self factoryMessagesFrom: aClassName) detect: [ :aMessage | aMessage selector = aSelector  ] ifNone: [ self error: aSelector , ' not found in: ' , aClassName ]
]

{ #category : #accessing }
STypeInfo >> types [ 
	^ types
]
