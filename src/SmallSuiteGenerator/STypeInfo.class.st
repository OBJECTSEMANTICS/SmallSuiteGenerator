Class {
	#name : #STypeInfo,
	#superclass : #Object,
	#instVars : [
		'types',
		'classes',
		'noneAbstractClasses'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'as yet unclassified' }
STypeInfo class >> typeInfo: aInstance [
	^ self subclassResponsibility
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
	| methodInfos className |
	className := aClass name.
	methodInfos := types
		at: className
		ifAbsent: [ ^ self error: 'this class has no type info' ].
	^ methodInfos select: [ :m | m returnType = className ].
]

{ #category : #lookup }
STypeInfo >> filterFrom: aCoverageAnlysisResult [
	
]

{ #category : #initialization }
STypeInfo >> initialize [
	super initialize.
 	types := Dictionary new.
]

{ #category : #lookup }
STypeInfo >> methodsFrom: aClassName [
	^ types at: aClassName ifAbsentPut:[ Dictionary new].
]

{ #category : #enumerating }
STypeInfo >> methodsFrom: nameReceiver toSelect: aBoolean [
	^ (types at: nameReceiver ifPresent: [ :dict | self methodsOrAccessorOf: nameReceiver toSelect: aBoolean ] ifAbsent: [#()])
]

{ #category : #enumerating }
STypeInfo >> methodsOrAccessorOf: nameReceiver toSelect: aBoolean [
	|methods |
	methods := (Smalltalk at: nameReceiver ) methods.
	methods := aBoolean
		ifTrue: [ methods select: #isQuick ]
		ifFalse: [ methods reject: #isQuick ].
	^ methods select: [ :m | m returnType notNil ].
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

{ #category : #lookup }
STypeInfo >> typeOf: aSelector from: aClassName [
	^ [(types at: aClassName) at: aSelector] on: Exception do: [ nil ]
]

{ #category : #accessing }
STypeInfo >> types [ 
	^ types
]
