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
	^ (arrMethods
		collect: [ :method | method selector -> method asTypeInfo ]) asDictionary .
]

{ #category : #'as yet unclassified' }
SSGeneratorClass >> factoryMethods [
	^ self metaclassSpy methods select:#isFactory.
]

{ #category : #'as yet unclassified' }
SSGeneratorClass >> fillTypesOn: aTypeInfo [
	aTypeInfo addMethodsOf: self className with: self allMethods.
	"aTypeInfo
		addClassMethodsOf: self className
		with: self metaclassSpy methods"
]
