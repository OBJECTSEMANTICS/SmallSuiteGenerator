Class {
	#name : #SSGenerator,
	#superclass : #S2Profiler,
	#instVars : [
		'scalars'
	],
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSGenerator class >> spyClassForPackage [
	 ^ SSGeneratorPackage
]

{ #category : #initialization }
SSGenerator >> addScalar: anObject [
	| value |
	value := scalars at: anObject class name ifAbsentPut: [ Set new ].
	value add: anObject
]

{ #category : #accessing }
SSGenerator >> asTypeInfo [
	| typeInfo |
	typeInfo := STypeInfo new.
	self allClasses do: [ :aSpyClass | aSpyClass fillTypesOn: typeInfo ].
	typeInfo types at: 'scalars' put: scalars copy.
	^ typeInfo
]

{ #category : #accessing }
SSGenerator >> classes: collectionClass [
	allClassesAsDictionaryCache := IdentityDictionary new.
	collectionClass 
		do: [ :cls | allClassesAsDictionaryCache at: cls className put: cls ].
	allClassesCache := collectionClass 
]

{ #category : #initialization }
SSGenerator >> initialize [
	super initialize.
	scalars := Dictionary new
]

{ #category : #initialization }
SSGenerator >> isScalar: anObject [
	self allClassesAsDictionary
		at: anObject class name
		ifAbsent: [ ^ true ].
	^ false
]

{ #category : #accessing }
SSGenerator >> methods: aOrdCollection [
	allMethodsCache := aOrdCollection 
]

{ #category : #accessing }
SSGenerator >> packages: aDictionary [
	self
		assert: (aDictionary values allSatisfy: [ :each | each class = SSGeneratorPackage ])
		description: 'Items must be of class SSGeneratorPackage'.
	packages := aDictionary 
]

{ #category : #initialization }
SSGenerator >> scalars [
	^ scalars.
]
