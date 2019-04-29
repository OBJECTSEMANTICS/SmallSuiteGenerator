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
	| value stringObject |
	stringObject := [ STON toString: anObject ]
				on: STONWriterError
				do: [ nil ].
	stringObject ifNotNil: [ value := scalars at: anObject class name ifAbsentPut: [ Set new ].
	value
		add: stringObject ].
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
