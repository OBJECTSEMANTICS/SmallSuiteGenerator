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
		do: [ :data | inst addTypeMethod: data ].
	dataClassMethods
		do: [ :data | inst addMethodInfoInClassMethod: data ].
	^ inst
]

{ #category : #private }
STypeClassInfo >> accessMessages [
	^ (methodTypes values select: #isQuick) select: [ :meth | meth returnType type isNotNil ]
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
STypeClassInfo >> addMethodInfoInClassMethod: aAssoc [
	self addClassMethod: (STypeMethodInfo type: aAssoc)
]

{ #category : #adding }
STypeClassInfo >> addMethods: methodTypeInfos [
	methodTypeInfos
		do: [ :aMethodType | 
			self addMethod: aMethodType ]
]

{ #category : #adding }
STypeClassInfo >> addTypeMethod: aAssoc [
	self addMethod: (STypeMethodInfo type: aAssoc)
]

{ #category : #'accessing - read only' }
STypeClassInfo >> allMethods [ 	
	^ methodTypes values , classMethodTypes values
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

{ #category : #initialization }
STypeClassInfo >> initialize [
	methodTypes := Dictionary new.
	classMethodTypes := Dictionary new
]

{ #category : #adding }
STypeClassInfo >> joinWith: otherTypeClass [
	otherTypeClass methodTypes do: [ :aMethod | 
		self addMethod: aMethod
		 ].
	otherTypeClass classMethodTypes do: [ :aMethod | self addClassMethod: aMethod ]
]

{ #category : #private }
STypeClassInfo >> messages [
	^ (methodTypes values reject: #isQuick) select: [ :meth | meth returnType type isNotNil ]
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
STypeClassInfo >> typeName [
	^ typeName
]

{ #category : #accessing }
STypeClassInfo >> typeName: anObject [
	typeName := anObject
]
