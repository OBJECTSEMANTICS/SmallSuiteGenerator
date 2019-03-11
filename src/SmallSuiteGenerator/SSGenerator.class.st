Class {
	#name : #SSGenerator,
	#superclass : #S2Profiler,
	#instVars : [
		'instrumentedClasses',
		'scalars'
	],
	#category : #'SmallSuiteGenerator-Model'
}

{ #category : #hooks }
SSGenerator class >> spyClassForPackage [
	 ^ SSGeneratorPackage
]

{ #category : #initialization }
SSGenerator >> addScalar: anObject [
	| value |
	value := scalars
		at: anObject class name
		ifAbsentPut: [ Set new ].
	value add: anObject storeString.
]

{ #category : #initialization }
SSGenerator >> initialize [
	super initialize.
	instrumentedClasses := Dictionary new.
	scalars := Dictionary new.
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
