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
		'blackList',
		'cacheMessagesFrom'
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
	^ types
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

{ #category : #accessing }
STypeInfo >> allParentClassesInfoFrom: aClassName [
	|smalltalkClass result|
	smalltalkClass := Smalltalk at: aClassName.
	result := OrderedCollection new.
	smalltalkClass withAllSuperclassesDo:[:class|
		|info|
		info :=self classAt: class name ifNone:[nil].
		info ifNotNil: [ result add: info. ]].
	^ result.
	 
]

{ #category : #converting }
STypeInfo >> asTypeInfo: aTypeCollector [
	|aBlackList|
	aBlackList := self blackList.
	self cleanBlockClosuresOf: aTypeCollector.
	aTypeCollector allClasses
		do: [ :aSpyClass | 
			aBlackList select: [ :aMethod | aMethod fullClassName == aSpyClass className ] 
				thenDo: [:aMethod | aSpyClass removeMethod: aMethod ].
			self addClassInfo: (STypeClassInfo asClassInfo: aSpyClass) ].
	self joinScalars: aTypeCollector scalars copy.
	^ self
]

{ #category : #accessing }
STypeInfo >> blackList [
	^ blackList
]

{ #category : #accessing }
STypeInfo >> blackList: aList [
	blackList := aList.
	self deleteBlackListMethods 
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
STypeInfo >> classAt: aClassName ifPresent: aBlock [
	^ types at: aClassName ifPresent: aBlock ifAbsent: [  ]
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
	[ |cleanBlocks|
		cleanBlocks := (aTypeCollector scalars at: #BlockClosure) select: [ :aBlock | aBlock isClean ].
		aTypeCollector scalars at: #BlockClosure put: cleanBlocks ]
	on: Error
	do: [].
]

{ #category : #actions }
STypeInfo >> collectSubclassesOf: type [
	[(#(#Object #Metaclass #Class #ProtoObject #Behavior #ClassDescription) includes: type)
		ifTrue: [ ^ Array with: type ]
		ifFalse: [ ^ Array with: type withAll: (type asClass allSubclasses collect: #name) ]]
	on: Error
	do: [ ^ Array with: type ]
]

{ #category : #adding }
STypeInfo >> completeTypeInfo [
	|aBlackList aBlock|
	aBlackList := self blackList.
	aBlock := [ :keyAndvalue :clsAndrealCls :symbol  | |key value cls|
		key :=  keyAndvalue first.
		value := keyAndvalue second.
		cls := clsAndrealCls first.
		((self isMethodWith: key and: cls in: aBlackList) not "and: [ key isUnary not" and: [
				value argTypes allSatisfy: [ :arg | arg types notEmpty ] ] "]") 
		ifTrue: [
			(clsAndrealCls second perform: symbol) 
			at: key
			ifAbsentPut: [ 
				value returnType types ifEmpty: [value returnType type: #SUndefinedObject].
				value receiver type: cls.
				value hasProfiler: false.
				value executions: 0.5 ] ] ].
	self types keysDo: [:aClass | |classInfo realClassInfo|
	classInfo := SmallTypeCollector new collectTypeFrom: aClass asClass.
	realClassInfo := self types at: aClass.
	classInfo methodTypes keysAndValuesDo: [ :key :value |
		aBlock cull: {key . value} cull: {aClass . realClassInfo} cull: #methodTypes.].
	classInfo classMethodTypes keysAndValuesDo: [ :key :value |
		aBlock cull: {key . value} cull: {aClass . realClassInfo} cull: #classMethodTypes.] ].
	self reset
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

{ #category : #converting }
STypeInfo >> deleteBlackListMethods [

	self blackList do: [:compMethod |
		|aClass selector|
		selector := #methodTypes.
		aClass := compMethod mclass.
		aClass isMeta ifTrue: [ 
			selector := #classMethodTypes.
			aClass := aClass instanceSide ].
		self types at: aClass name asSymbol
			ifPresent: [:classInfo | 
				(classInfo perform: selector)
						removeKey: compMethod selector
				 		ifAbsent: []
			] 
			ifAbsent: [].
	]
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
	^ types
		flatCollect: [ :aClassType | 
			aClassType factoryMessages
				select: [ :aMessage | aMessage receiver types includes: aClassName ] ]
]

{ #category : #initialization }
STypeInfo >> initialize [
	super initialize.
	types := Dictionary new.
	scalars := Dictionary new.
	cacheMessagesFrom :=Dictionary new.
	self initializeBlackList
]

{ #category : #initialization }
STypeInfo >> initializeBlackList [
	blackList ifNil: [ blackList := Array new ]
]

{ #category : #initialization }
STypeInfo >> initializeIsAbstract [
	self types valuesDo: [ :e | e isAbstract ]
]

{ #category : #'error handling' }
STypeInfo >> intersect: typeList [ 
	|result|
	result := Set new. 
	typeList do: [ :type | | allTypes |
		allTypes := self collectSubclassesOf: type.
		allTypes do: [:t | (self isScalar: t) 
									ifTrue: [ result add: t ]
									ifFalse: [
										self classAt: type 
										ifPresent: [ :cls | cls isAbstract ifFalse: [  result add: t ] ] ] ] ].
	^ result asOrderedCollection
]

{ #category : #accessing }
STypeInfo >> isAbstractClass: symbol [
	^ (self classAt: symbol) isAbstract.
]

{ #category : #accessing }
STypeInfo >> isMethodWith: selector and: aClass in: aBlackList [
	^ aBlackList
		anySatisfy: [ :each | each mclass = aClass and:[ each selector = selector]]
]

{ #category : #'error handling' }
STypeInfo >> isScalar: aClassName [
	^ scalars at: aClassName ifPresent:[ true] ifAbsent:[false].
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
	cacheMessagesFrom := Dictionary new.
	otherTypeInfo types
		do: [ :aTypeClass | self addClassInfo: aTypeClass ].
		self joinScalars: otherTypeInfo scalars.
	self reset.
]

{ #category : #accessing }
STypeInfo >> messagesFrom: aClassName [
	^ cacheMessagesFrom 
		at: aClassName 
		ifAbsentPut: [ |classInfos|
			classInfos := self allParentClassesInfoFrom: aClassName.
			classInfos := classInfos flatCollect:
				[:classInfo| classInfo messages].
			classInfos].
]

{ #category : #lookup }
STypeInfo >> methodType: aSelector from: aClassName [
	|messages|
	messages := self messagesFrom: aClassName.
	^ messages 
		detect:[ :methodInfo | methodInfo selector = aSelector] 
		ifNone:[ 
			self error: 
			('MethodType of selector: {1} is not found in class: {2}' format:{aSelector. aClassName}) ].
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
STypeInfo >> reset [
	types valuesDo: [ :type | type resetMethods ]
	
]

{ #category : #actions }
STypeInfo >> scalar: aClassName with: aValue [
	scalars at: aClassName put: aValue asSet asArray
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
