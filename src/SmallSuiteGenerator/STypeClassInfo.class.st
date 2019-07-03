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

{ #category : #private }
STypeClassInfo >> accessMessages [
	^ methodTypes values select: #isQuick
]

{ #category : #adding }
STypeClassInfo >> addClassMethod: methodTypeInfo [
	methodTypeInfo typeInfo: typeInfo.
	classMethodTypes at: methodTypeInfo selector put: methodTypeInfo
]

{ #category : #adding }
STypeClassInfo >> addClassMethods: methodTypeInfos [
	methodTypeInfos
		do: [ :aMethodType | classMethodTypes at: aMethodType selector put: aMethodType ]
]

{ #category : #adding }
STypeClassInfo >> addMethod: methodTypeInfo [
	methodTypeInfo typeInfo: typeInfo.
	methodTypes at: methodTypeInfo selector put: methodTypeInfo
]

{ #category : #adding }
STypeClassInfo >> addMethods: methodTypeInfos [
	methodTypeInfos
		do: [ :aMethodType | methodTypes at: aMethodType selector put: aMethodType ]
]

{ #category : #'as yet unclassified' }
STypeClassInfo >> classMethodOf: aSelector [
	^ classMethodTypes at: aSelector
]

{ #category : #accessing }
STypeClassInfo >> classMethodTypes [
	^ classMethodTypes
]

{ #category : #initialization }
STypeClassInfo >> initialize [
	methodTypes := Dictionary new.
	classMethodTypes := Dictionary new
]

{ #category : #private }
STypeClassInfo >> messages [
	^ methodTypes reject: #isQuick
]

{ #category : #'as yet unclassified' }
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
