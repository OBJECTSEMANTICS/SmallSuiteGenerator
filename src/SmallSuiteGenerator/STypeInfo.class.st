"
STypeInfo is responsible for collecting the STypeCollector's main data and building a new instance from the collected data.

It is composed of STypeClassInfo collection and each item likewise is formed by STypeMethodInfo collection.

Instance Variables
	types:						<Dictionary>	All the classes (represented as an instance of STypeClassInfo) for which information is collected
	classes:					<Dictionary>
	noneAbstractClasses:	<Collection>
	scalars: 					<Dictionary>	collection of classes that cannot be instrumented
"
Class {
	#name : #STypeInfo,
	#superclass : #SObject,
	#instVars : [
		'types',
		'classes',
		'noneAbstractClasses',
		'scalars',
		'blackList'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #converting }
STypeInfo class >> asTypeInfo: aTypeCollector [
	^ self new asTypeInfo: aTypeCollector 
]

{ #category : #converting }
STypeInfo class >> asTypeInfo: aTypeCollector methodsBlacklist: aList [
	^ self new blackList: aList; asTypeInfo: aTypeCollector" methodsBlacklist: aList"
]

{ #category : #comparing }
STypeInfo >> = other [
	^ self class = other class
		and: [ types = other types
				and: [ | otherScalars |
					otherScalars := other scalars.
					scalars keys = otherScalars keys
						and: [ (scalars values collect: #size)
								= (otherScalars values collect: #size) ] ] ]
]

{ #category : #accessing }
STypeInfo >> accessMessagesFrom: aClassName [
	^ types values
		flatCollect: [ :aClassType | 
			aClassType accessMessages
				select: [ :aMessage | aMessage receiver types includes: aClassName ] ]
]

{ #category : #adding }
STypeInfo >> addClassInfo: aTypeClassInfo [
	types
		at: aTypeClassInfo typeName
		ifPresent: [ :aTypeClass | aTypeClass joinWith: aTypeClassInfo ]
		ifAbsentPut: [ aTypeClassInfo ].
	self joinScalars: aTypeClassInfo scalars
]

{ #category : #converting }
STypeInfo >> asTypeInfo: aTypeCollector [
	self cleanBlockClosuresOf: aTypeCollector.
	aTypeCollector allClasses
		do: [ :aSpyClass | 
			blackList select: [ :aMethod | aMethod origin name == aSpyClass className ] 
				thenDo: [:aMethod | aSpyClass removeMethod: aMethod ].
			(aSpyClass className endsWith: 'BlockClosure')
				ifFalse: [ self addClassInfo: (STypeClassInfo asClassInfo: aSpyClass) ] ].
	self joinScalars: aTypeCollector orderedScalars copy.
	^ self
]

{ #category : #accessing }
STypeInfo >> blackList: aList [
	blackList := aList
]

{ #category : #accessing }
STypeInfo >> classAt: aClassName [
	^ types at: aClassName
]

{ #category : #accessing }
STypeInfo >> classAt: aClassName ifNone: aBlock [
	^ types at: aClassName ifAbsent: aBlock
]

{ #category : #lookup }
STypeInfo >> classMethodType: aSelector from: aClassName [
	aSelector = #new
		ifTrue: [ ^ self defaultFactoryMessageFrom: aClassName ].
	(self factoryMessagesFrom: aClassName)
		detect: [ :aMessage | aMessage selector = aSelector ]
		ifFound: [ :aMessage | ^ aMessage ].
	self
		error:
			'ClassMethodType of selector: ' , aSelector
				, ' is not found in class: ' , aClassName
]

{ #category : #accessing }
STypeInfo >> classes [
	classes ifNil: [ classes := Dictionary new ].
	types
		keysDo: [ :aClassName | 
			classes
				at: aClassName
				ifAbsentPut: (SPlatform lookUpClass: aClassName) ].
	^ classes
]

{ #category : #converting }
STypeInfo >> cleanBlockClosuresOf: aTypeCollector [ 
	[ |cleanBlocks backupBlocks |
		cleanBlocks := (aTypeCollector scalars at: #BlockClosure) select: [ :aBlock | aBlock isClean ].
		aTypeCollector scalars at: #BlockClosure put: cleanBlocks.
		backupBlocks := (aTypeCollector orderedScalars at: #BlockClosure) select: [ :aBlock | aBlock isClean ].
		aTypeCollector orderedScalars at: #BlockClosure put: backupBlocks. ]
	on: Error
	do: [].
]

{ #category : #adding }
STypeInfo >> completeTypeInfo [
	self types keysDo: [:aClass | |classInfo realClassInfo|
	classInfo := SmallTypeCollector new collectTypeFrom: aClass asClass.
	realClassInfo := self types at: aClass.
	classInfo methodTypes keysAndValuesDo: [ :key :value |
		((self isInBlackListClass: aClass with: key) not and: [ key isUnary not and: [ value argTypes allSatisfy: [ :arg | arg types notEmpty ] ] ]) 
		ifTrue: [
			realClassInfo methodTypes 
			at: key
			ifAbsentPut: [ 
				self updateArgsOf: value.
				value returnType types ifEmpty: [value returnType type: #SUndefinedObject].
				value receiver type: aClass.
				value hasProfiler: false.
				value executions: 0.5 ] ] ] ]
]

{ #category : #copying }
STypeInfo >> copy [
	| copy |
	copy := self class new.
	types
		do: [ :aClassTypeInfo | copy addClassInfo: aClassTypeInfo copy ].
	copy scalars: scalars copy.
	^ copy
]

{ #category : #'accessing structure variables' }
STypeInfo >> defaultFactoryMessageFrom: aClassName [
	(self messagesFrom: aClassName)
		detect: [ :message | message selector = #initialize ]
		ifFound: [ ^ STypeMethodInfo
				type:
					#new
						->
							(Array
								with: aClassName
								with: aClassName
								with: #()
								with: false) ].
	self error: 'ClassMethodType of selector new cannot be applied at class: ', aClassName
]

{ #category : #'error handling' }
STypeInfo >> error: aString [
	^ SError signal: aString
]

{ #category : #actions }
STypeInfo >> exportDataCSV: neoCSVWriter withFilter: aSymbol [
	types
		do: [ :type | type exportDataCSV: neoCSVWriter withFilter: aSymbol ]
]

{ #category : #lookup }
STypeInfo >> factoryMessagesFrom: aClassName [
	^ types values
		flatCollect: [ :aClassType | 
			aClassType factoryMessages
				select: [ :aMessage | aMessage receiver types includes: aClassName ] ]
]

{ #category : #initialization }
STypeInfo >> initialize [
	super initialize.
	types := OrderedDictionary new.
	scalars := OrderedDictionary new.
	self initializeBlackList
]

{ #category : #initialization }
STypeInfo >> initializeBlackList [
	blackList ifNil: [ blackList := OrderedCollection new ]
]

{ #category : #accessing }
STypeInfo >> isAbstractClass: symbol [
	| aClass |
	aClass := self classes at: symbol.
	^  (aClass methods select: #isAbstract) isNotEmpty
]

{ #category : #accessing }
STypeInfo >> isInBlackListClass: aClass with: selector [ 
	^ (blackList anySatisfy: [:each | (each origin name = aClass) & (each selector = selector) ]) 
]

{ #category : #actions }
STypeInfo >> joinScalars: aDict [
	aDict associations do: [ :assoc | 
		scalars
			at: assoc key
			ifPresent: [ :values |
			scalars at: assoc key put: (values union: assoc value) asArray ]
			ifAbsentPut: [ assoc value asArray ] ]
]

{ #category : #actions }
STypeInfo >> joinWith: otherTypeInfo [
	otherTypeInfo types
		do: [ :aTypeClass | self addClassInfo: aTypeClass ].
		self joinScalars: otherTypeInfo scalars
]

{ #category : #accessing }
STypeInfo >> messagesFrom: aClassName [
	^ types values
		flatCollect: [ :aClassType | 
			aClassType messages
				select: [ :aMessage | aMessage receiver types includes: aClassName ] ]
]

{ #category : #lookup }
STypeInfo >> methodType: aSelector from: aClassName [
	types
		do: [ :aTypeClassInfo | 
			aTypeClassInfo messagesAndAccessMessages
				detect: [ :aMessage | 
					(aMessage isFromReceiver: aClassName)
						and: [ aMessage selector = aSelector ] ]
				ifFound: [ :aMessage | ^ aMessage ]
				ifNone: [ false ] ].
	^ self error: 'MethodType of selector: ', aSelector , ' is not found in class: ' , aClassName
]

{ #category : #accessing }
STypeInfo >> noneAbstractClasses [
	noneAbstractClasses ifNil: [ 
		noneAbstractClasses := self classes associations
			select: [ :assoc | (self isAbstractClass: assoc key) not ]
			thenCollect: [ :assoc | assoc value ] ].
	^ noneAbstractClasses
]

{ #category : #accessing }
STypeInfo >> reportFrequencyByFilter [
	| report |
	report := Dictionary new.
	(STypeMethodInfo selectorsFilter, #(#others #all))
		do: [ :aSelector | 
			report
				at: aSelector
				put:
					(types
						inject: 0
						into: [ :sum :type | sum + (type reportFrequencyByFilter: aSelector) ]) ].
	^ report
]

{ #category : #actions }
STypeInfo >> scalar: aClassName with: aValue [
	scalars at: aClassName put: aValue asOrderedSet asArray
]

{ #category : #accessing }
STypeInfo >> scalars [
	^ scalars
]

{ #category : #accessing }
STypeInfo >> scalars: aDictionary [
	aDictionary associationsDo: [ :assoc | 
		self scalar: assoc key with: assoc value ]
]

{ #category : #'accessing structure variables' }
STypeInfo >> type: aAssoc [
	self addClassInfo: (STypeClassInfo type: aAssoc)
]

{ #category : #accessing }
STypeInfo >> types [ 
	^ types
]

{ #category : #lookup }
STypeInfo >> updateArgsOf: aMethod [ 
	aMethod argTypes do: [ :argType |
	| includeTypes |
	includeTypes := argType types anySatisfy: [ :type | self scalars keys includes: type ].
	includeTypes ifFalse: [ 
		argType types do: [ :type | 
			self scalars keys 
				select: [ :scalar | (type asClass allSubclasses collect: #name) includes: scalar ] 
				thenDo: [ :scalar | argType type: scalar ] ] ] ].
	"updateArgsOf: aMethod 
	aMethod argTypes do: [ :argType |
	| includeTypes |
	includeTypes := argType types anySatisfy: [ :type | self scalars keys includes: type ].
	includeTypes ifFalse: [ 
		argType types do: [ :type |
			(type substrings: '.') last = 'Object' ifFalse: [
			self scalars keys 
				select: [ :scalar | ((self classOf: type asString) first allSubclasses 
					collect: [:e | e fullName asSymbol]) includes: scalar ] 
				thenDo: [ :scalar | argType type: scalar ] ] ] ]]"
]
