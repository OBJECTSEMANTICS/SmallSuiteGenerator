Class {
	#name : #SSGeneratorClass,
	#superclass : #S2Class,
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #hooks }
SSGeneratorClass class >> spyClassForMethod [
	 ^ SSGeneratorMethod
]

{ #category : #'as yet unclassified' }
SSGeneratorClass >> dictInfoMethodsFrom: arrMethods [
	| dict  |
	dict := Dictionary new.
	arrMethods do: [ :method | dict at: method selector put: method asTypeInfo ].
	^ dict
	
]

{ #category : #'as yet unclassified' }
SSGeneratorClass >> factoryMethods [
	^ self metaclassSpy methods select:#isFactory.
]

{ #category : #'as yet unclassified' }
SSGeneratorClass >> fillTypesOn: aTypeInfo [
	| meths |
	"dict := Dictionary new.
	dict := self dictInfoMethodsFrom: self allMethods."
	aTypeInfo types
		at: self className
		put: (self dictInfoMethodsFrom: self allMethods).
	"self allMethods
		do: [ :method | dict at: method selector put: method asTypeInfo ]."
	meths := self metaclassSpy methods.
	meths
		ifNotEmpty: [ aTypeInfo types
				at: self metaclassSpy className
				put: (self dictInfoMethodsFrom: meths) ]
]
