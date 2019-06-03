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
