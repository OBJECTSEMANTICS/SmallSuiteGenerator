"
STypeClassInfo is an info type node for a class.

Instance Variables
	classMethodTypes:	<Dictionary>
	methodTypes:			<Dictionary>
	typeName:				<Symbol>
"
Class {
	#name : #STypeClassInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'typeName',
		'methodTypes',
		'classMethodTypes',
		'scalars'
	],
	#classInstVars : [
		'classMethodTypes'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #converting }
STypeClassInfo class >> asClassInfo: aSpyClass [
	^ self new asClassInfo: aSpyClass 
]

{ #category : #'instance creation' }
STypeClassInfo class >> newFrom: aClassName [
	^ self new
		typeName: aClassName
]

{ #category : #'accessing structure variables' }
STypeClassInfo class >> type: aAssoc [
	| dataOfAllMethods inst dataMethods dataClassMethods |
	inst := self new typeName: aAssoc key.
	dataOfAllMethods := aAssoc value.
	dataMethods := dataOfAllMethods first.
	dataClassMethods := dataOfAllMethods second.
	dataMethods
		do: [ :data | inst typeMethod: data ].
	dataClassMethods
		do: [ :data | inst typeClassMethod: data ].
	^ inst
]

{ #category : #comparing }
STypeClassInfo >> = other [
	^ self class = other class
		and: [ typeName = other typeName
				and: [ methodTypes = other methodTypes
						and: [ classMethodTypes = other classMethodTypes ] ] ]
]

{ #category : #private }
STypeClassInfo >> accessMessages [
	^ self messagesAndAccessMessages select: #isQuick
]

{ #category : #adding }
STypeClassInfo >> addClassMethod: methodTypeInfo [
	"methodTypeInfo typeInfo: typeInfo."

	classMethodTypes
		at: methodTypeInfo selector
		ifPresent: [ :methInfo | methInfo joinWith: methodTypeInfo ]
		ifAbsentPut: methodTypeInfo.
	self addScalars: methodTypeInfo scalars 
]

{ #category : #adding }
STypeClassInfo >> addClassMethods: methodTypeInfos [
	methodTypeInfos do: [ :aMethodType | 
		self addClassMethod: aMethodType.
		]
]

{ #category : #adding }
STypeClassInfo >> addMethod: methodTypeInfo [
	"methodTypeInfo typeInfo: typeInfo."
	methodTypes
		at: methodTypeInfo selector
		ifPresent: [ :methInfo | methInfo joinWith: methodTypeInfo ]
		ifAbsentPut: [ methodTypeInfo ].
	self addScalars: methodTypeInfo scalars
]

{ #category : #adding }
STypeClassInfo >> addMethods: methodTypeInfos [
	methodTypeInfos do: [ :aMethodType | self addMethod: aMethodType.
		 ]
]

{ #category : #adding }
STypeClassInfo >> addScalars: aDictionary [
	aDictionary associations
		do: [ :assoc | 
			scalars
				at: assoc key
				ifPresent:
					[ :values | scalars at: assoc key put: (values union: assoc value) asArray ]
				ifAbsentPut: [ assoc value asArray ] ]
]

{ #category : #'accessing - read only' }
STypeClassInfo >> allMethods [
	^ methodTypes values , classMethodTypes values
]

{ #category : #'as yet unclassified' }
STypeClassInfo >> asClassInfo: aSpyClass [
	| aTypeClass instanceMethods classMethods |
	aTypeClass := self class newFrom: aSpyClass typeName.
	instanceMethods := OrderedCollection new.
	classMethods := OrderedCollection new.
	(aSpyClass typeName endsWith: ' class') ifFalse: [ 
		instanceMethods := (aSpyClass methods reject: #isTest)
				select: #wasExecuted
	].
	(aSpyClass metaclassSpy typeName endsWith: ' class') ifTrue: [ 
		classMethods := (aSpyClass metaclassSpy methods reject: #isTest) select:
					[ :clsMethod | clsMethod wasExecuted and: [ clsMethod isValidReturnTypeWithReceiver ] ] 	].
	aTypeClass
		addMethods:
			(instanceMethods
				collect: [ :instMeth | STypeMethodInfo asMethodInfo: instMeth ]);
		addClassMethods:
			(classMethods
				collect: [ :instMeth | STypeMethodInfo asMethodInfo: instMeth ]).
	^ aTypeClass
]

{ #category : #'accessing - read only' }
STypeClassInfo >> classMethodOf: aSelector [
	^ classMethodTypes at: aSelector
]

{ #category : #accessing }
STypeClassInfo >> classMethodTypes [
	^ classMethodTypes
]

{ #category : #copying }
STypeClassInfo >> copy [
	| copy |
	copy := self class instance.
	methodTypes do: [ :methodType | copy addMethod: methodType copy ].
	classMethodTypes
		do: [ :classMethodType | copy addClassMethod: classMethodType copy ].
	copy typeName: typeName.
	^ copy
]

{ #category : #actions }
STypeClassInfo >> exportDataCSV: neoCSVWriter withFilter: aSymbol [
	
	self writeDataCSV: neoCSVWriter using: (self filteredMethodsBy: aSymbol)
]

{ #category : #private }
STypeClassInfo >> factoryMessages [
	^ classMethodTypes values reject: [ :m | m selector = #basicNew ].
]

{ #category : #private }
STypeClassInfo >> factoryMessagesFrom: aClassName [
	^ self factoryMessages
		select: [ :factMessage | 
			(factMessage isFromReceiver: aClassName)
				and: [ factMessage isWithReturnType: aClassName ] ]
]

{ #category : #accessing }
STypeClassInfo >> filteredMethodsBy: aSymbol [
	^ (STypeMethodInfo selectorsFilter includes: aSymbol)
		ifTrue: [ self allMethods select: aSymbol ]
		ifFalse: [ self remainingOrAllMethods: aSymbol ]
]

{ #category : #comparing }
STypeClassInfo >> hash [
	^ typeName hash bitXor: (methodTypes hash bitXor: classMethodTypes hash)
]

{ #category : #initialization }
STypeClassInfo >> initialize [
	methodTypes := Dictionary new.
	classMethodTypes := Dictionary new.
	scalars := Dictionary new
]

{ #category : #actions }
STypeClassInfo >> joinWith: otherTypeClass [
	otherTypeClass methodTypes do: [ :aMethod | 
		self addMethod: aMethod
		 ].
	otherTypeClass classMethodTypes do: [ :aMethod | self addClassMethod: aMethod ]
]

{ #category : #private }
STypeClassInfo >> messages [
	^ self messagesAndAccessMessages reject: #isQuick
]

{ #category : #private }
STypeClassInfo >> messagesAndAccessMessages [
	^ methodTypes values
		select: [ :methType | 
			methType isDeprecated not
				 and: [ methType returnType isNil not ] ]
]

{ #category : #'accessing - read only' }
STypeClassInfo >> methodOf: aSelector [
	^ methodTypes at: aSelector
]

{ #category : #accessing }
STypeClassInfo >> methodTypes [
	^ methodTypes
]

{ #category : #accessing }
STypeClassInfo >> remainingOrAllMethods: aSymbol [
	^ aSymbol = #others
		ifTrue: [ | methods |
			methods := self allMethods.
			STypeMethodInfo selectorsFilter do: [ :key | methods := methods reject: key ].
			methods ]
		ifFalse: [ self allMethods ]
]

{ #category : #'accessing - read only' }
STypeClassInfo >> reportFrequencyByFilter: aSelector [
	^ (self filteredMethodsBy: aSelector) size
]

{ #category : #accessing }
STypeClassInfo >> scalars [ 
	^ scalars 
]

{ #category : #actions }
STypeClassInfo >> typeClassMethod: aAssoc [
	self addClassMethod: (STypeMethodInfo type: aAssoc)
]

{ #category : #actions }
STypeClassInfo >> typeMethod: aAssoc [
	self addMethod: (STypeMethodInfo type: aAssoc)
]

{ #category : #accessing }
STypeClassInfo >> typeName [
	^ typeName
]

{ #category : #accessing }
STypeClassInfo >> typeName: anObject [
	typeName := anObject
]

{ #category : #writing }
STypeClassInfo >> writeDataCSV: neoCSVWriter using: methods [
	methods
		do: [ :aMethod | 
			neoCSVWriter
				nextPut: (Array with: typeName printString) , aMethod dataCSV ]
]
