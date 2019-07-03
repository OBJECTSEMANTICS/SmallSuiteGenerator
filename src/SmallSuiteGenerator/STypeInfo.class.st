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
STypeInfo class >> typeInfo: aInstance [
	^ self subclassResponsibility
]

{ #category : #adding }
STypeInfo >> addClassInfo: aTypeClassInfo [
	types at: aTypeClassInfo typeName put: aTypeClassInfo 
]

{ #category : #accessing }
STypeInfo >> classes [
	classes ifNil:[
		classes := types keys collect:[ :className | Smalltalk at: className].
		].
	^ classes.
]

{ #category : #lookup }
STypeInfo >> copyFrom: aCoverageAnlysisResult [
	| clone |
	clone := self class new
	"filter data according the other typeInfo of mutalk or othher class, or just analisysOfMutalk to dont depend another project "
]

{ #category : #lookup }
STypeInfo >> factoryMethods: aClass [
	| className |
	className := aClass name.
	types
		at: className
		ifPresent: [ :classInfo | 
			^ classInfo classMethodTypes associations
				select: [ :assoc | assoc value returnType = className ] thenCollect: [ :assoc | assoc value ] ]
		ifAbsent: [ ^ self error: 'this class has no type info' ]
]

{ #category : #lookup }
STypeInfo >> filterFrom: aCoverageAnlysisResult [
	
]

{ #category : #initialization }
STypeInfo >> initialize [
	super initialize.
	types := Dictionary new.
	scalars := Dictionary new
]

{ #category : #accessing }
STypeInfo >> noneAbstractClasses [
	noneAbstractClasses ifNil:[
		noneAbstractClasses := self classes reject:[ :class| class isAbstract].
		].
	^ noneAbstractClasses.
]

{ #category : #accessing }
STypeInfo >> randomNoneAbstractClass [
	self assert: types isNotEmpty description: 'There is not a class'.
	^ self noneAbstractClasses shuffle anyOne
]

{ #category : #accessing }
STypeInfo >> scalars [
	^ scalars 
]

{ #category : #accessing }
STypeInfo >> scalars: aDictionary [
	scalars := aDictionary
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
