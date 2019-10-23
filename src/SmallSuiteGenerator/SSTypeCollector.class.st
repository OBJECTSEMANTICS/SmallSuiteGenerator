Class {
	#name : #SSTypeCollector,
	#superclass : #S2Profiler,
	#instVars : [
		'scalars'
	],
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSTypeCollector class >> profile: aBlock onPackagesMatching: regex [

	^ (self new profile: aBlock onPackagesMatching: regex) asTypeInfo.
]

{ #category : #hooks }
SSTypeCollector class >> spyClassForPackage [
	 ^ SSTypeCollectorPackage
]

{ #category : #initialization }
SSTypeCollector >> addScalar: anObject [
	| value objectName |
	objectName := anObject class name.
	"objectName := anObject isClass
		ifTrue: [ anObject name ]
		ifFalse: [ anObject class name ]."
	value := scalars at: objectName ifAbsentPut: [ Set new ].
	value add: anObject
]

{ #category : #accessing }
SSTypeCollector >> asTypeInfo [
	| typeInfo |
	typeInfo := STypeInfo new.
	self allClasses do: [ :aSpyClass | aSpyClass fillTypesOn: typeInfo ].
	typeInfo scalars: scalars copy.
	^ typeInfo
]

{ #category : #initialization }
SSTypeCollector >> initialize [
	super initialize.
	scalars := Dictionary new
]

{ #category : #initialization }
SSTypeCollector >> isScalar: anObject [
	self allClassesAsDictionary
		at: anObject class name
		ifAbsent: [ ^ true ].
	^ false
]

{ #category : #initialization }
SSTypeCollector >> scalars [
	^ scalars.
]
