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
	| value objectName |
	objectName := anObject class name.
	"objectName := anObject isClass
		ifTrue: [ anObject name ]
		ifFalse: [ anObject class name ]."
	value := scalars at: objectName ifAbsentPut: [ Set new ].
	value add: anObject
]

{ #category : #accessing }
SSGenerator >> asTypeInfo [
	| typeInfo |
	typeInfo := STypeInfo new.
	self allClasses do: [ :aSpyClass | aSpyClass fillTypesOn: typeInfo ].
	typeInfo scalars: scalars copy.
	^ typeInfo
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

{ #category : #initialization }
SSGenerator >> scalars [
	^ scalars.
]
