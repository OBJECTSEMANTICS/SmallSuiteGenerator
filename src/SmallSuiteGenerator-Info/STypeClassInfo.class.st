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
STypeClassInfo class >> newFrom: aClassName and: aTypeInfo [
	^ self new
		typeName: aClassName;
		typeInfo: aTypeInfo
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

{ #category : #private }
STypeClassInfo >> accessMessages [
	^ methodTypes values select: #isQuick
]

{ #category : #adding }
STypeClassInfo >> addClassMethod: methodTypeInfo [
	methodTypeInfo typeInfo: typeInfo.
	classMethodTypes at: methodTypeInfo selector 
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
	methodTypeInfo typeInfo: typeInfo.
	methodTypes
		at: methodTypeInfo selector
		ifPresent: [ :methInfo | methInfo joinWith: methodTypeInfo ]
		ifAbsentPut: [methodTypeInfo]
]

{ #category : #adding }
STypeClassInfo >> addMethods: methodTypeInfos [
	methodTypeInfos
		do: [ :aMethodType | 
			self addMethod: aMethodType ]
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

{ #category : #testing }
STypeClassInfo >> includesSelector: aSelector ofAccess: aBoolean [
	^ methodTypes detect: [ :methType | methType selector = aSelector and: [ methType isQuick = aBoolean ] ] ifFound: [ true ] ifNone: [ false ]
]

{ #category : #initialization }
STypeClassInfo >> initialize [
	methodTypes := Dictionary new.
	classMethodTypes := Dictionary new
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
	^ methodTypes values reject: #isQuick
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
