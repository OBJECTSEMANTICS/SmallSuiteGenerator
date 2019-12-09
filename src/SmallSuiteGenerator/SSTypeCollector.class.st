"
SSTypeCollector is a subclass of Profiler that collects project types

Instance Variables
	scalars:		<Dictionary>
"
Class {
	#name : #SSTypeCollector,
	#superclass : #SLProfiler,
	#instVars : [
		'scalars'
	],
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSTypeCollector class >> profile: aBlock onPackagesMatching: regex [

	^ (self profile: aBlock inPackagesMatching: regex) asTypeInfo.
]

{ #category : #hooks }
SSTypeCollector class >> spyClassForPackage [
	 ^ SSTypeCollectorPackage
]

{ #category : #hooks }
SSTypeCollector class >> typeNameOf: anObject [
	^ anObject name
]

{ #category : #initialization }
SSTypeCollector >> addScalar: anObject [
	| value  |
	value := scalars at: (self class typeNameOf: anObject class) ifAbsentPut: [ Set new ].
	value add: anObject
]

{ #category : #accessing }
SSTypeCollector >> asTypeInfo [
	| typeInfo |
	typeInfo := STypeInfo new.
	self allClasses do: [ :aSpyClass | 
		aSpyClass className = 'BlockClosure' ifFalse: [ 
			aSpyClass fillTypesOn: typeInfo ] ].
	typeInfo joinScalars: scalars copy.
	^ typeInfo
]

{ #category : #initialization }
SSTypeCollector >> initialize [
	super initialize.
	scalars := Dictionary new
]

{ #category : #initialization }
SSTypeCollector >> isScalar: anObject [
	(anObject class name includesAll: 'BlockClosure')
		ifTrue: [ ^ true ].
	self allClassesAsDictionary
		at: (self class typeNameOf: anObject class)
		ifAbsent: [ ^ true ].
	^ false
]

{ #category : #initialization }
SSTypeCollector >> scalars [
	^ scalars.
]
