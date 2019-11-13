Class {
	#name : #STypeClassInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'typeName',
		'methodTypes',
		'classMethodTypes'
	],
	#classInstVars : [
		'classMethodTypes'
	],
	#category : #'SmallSuiteGenerator-Info'
}

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
		ifAbsentPut: methodTypeInfo
]

{ #category : #adding }
STypeClassInfo >> addClassMethods: methodTypeInfos [
	methodTypeInfos
		do: [ :aMethodType | 
			self addClassMethod: aMethodType ]
]

{ #category : #adding }
STypeClassInfo >> addMethod: methodTypeInfo [
	"methodTypeInfo typeInfo: typeInfo."
	methodTypes
		at: methodTypeInfo selector
		ifPresent: [ :methInfo | methInfo joinWith: methodTypeInfo ]
		ifAbsentPut: [ methodTypeInfo ]
]

{ #category : #adding }
STypeClassInfo >> addMethods: methodTypeInfos [
	methodTypeInfos
		do: [ :aMethodType | 
			self addMethod: aMethodType ]
]

{ #category : #'accessing - read only' }
STypeClassInfo >> allMethods [
	^ methodTypes values , classMethodTypes values
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
STypeClassInfo >> methodOf: aSelector [
	^ methodTypes at: aSelector
]

{ #category : #accessing }
STypeClassInfo >> methodTypes [
	^ methodTypes
]

{ #category : #'as yet unclassified' }
STypeClassInfo >> remainingOrAllMethods: aSymbol [
	^ aSymbol = #others
		ifTrue: [ | methods |
			methods := self allMethods.
			STypeMethodInfo selectorsFilter do: [ :key | methods := methods reject: key ].
			methods ]
		ifFalse: [ self allMethods ]
]

{ #category : #'as yet unclassified' }
STypeClassInfo >> reportFrequencyByFilter: aSelector [
	^ (self filteredMethodsBy: aSelector) size
]

{ #category : #'as yet unclassified' }
STypeClassInfo >> typeClassMethod: aAssoc [
	self addClassMethod: (STypeMethodInfo type: aAssoc)
]

{ #category : #'as yet unclassified' }
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
				nextPut: (Array with: typeName asString) , aMethod dataCSV ]
]
