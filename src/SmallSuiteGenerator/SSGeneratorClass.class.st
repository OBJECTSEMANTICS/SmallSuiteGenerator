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
SSGeneratorClass >> fillTypesOn: aTypeInfo [
	| aTypeClass instanceMethods classMethods|
	aTypeClass := STypeClassInfo newFrom: self className and: aTypeInfo.
	instanceMethods := (self methods reject:#isTest) select:#wasExecuted.
	classMethods :=(self metaclassSpy methods reject:#isTest) select:#wasExecuted.
	aTypeClass addMethods: (instanceMethods collect: #asTypeInfo);
		addClassMethods: (classMethods collect: #asTypeInfo).
	aTypeInfo addClassInfo: aTypeClass
]
