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
	| aTypeClass |
	aTypeClass := STypeClassInfo newFrom: self className and: aTypeInfo.
	aTypeClass addMethods: (self methods collect: #asTypeInfo);
		addClassMethods: (self metaclassSpy methods collect: #asTypeInfo).
	aTypeInfo addClassInfo: aTypeClass
]
