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
SSGeneratorClass >> factoryMethods [
	^ self metaclassSpy methods select:#isFactory.
]

{ #category : #'as yet unclassified' }
SSGeneratorClass >> fillTypesOn: aTypeInfo [
	| aTypeClass aClassName |
	aClassName := self className.
	aTypeClass := STypeClassInfo newFrom: aClassName and: aTypeInfo.
	aTypeClass
		addMethods: (self methods collect: #asTypeInfo).
	aTypeClass
		addClassMethods: (self metaclassSpy methods collect: #asTypeInfo).
	aTypeInfo addClassInfo: aTypeClass
]
