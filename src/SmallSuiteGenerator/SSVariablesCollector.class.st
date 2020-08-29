Class {
	#name : #SSVariablesCollector,
	#superclass : #SSVisitor,
	#instVars : [
		'variablesWithId'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #initialization }
SSVariablesCollector >> initialize [
	super initialize.
	variablesWithId := OrderedCollection new.
]

{ #category : #accessing }
SSVariablesCollector >> variablesWithId [
	^ variablesWithId
]

{ #category : #visiting }
SSVariablesCollector >> visit: sNode [
	sNode accept: self
]

{ #category : #'visiting-core' }
SSVariablesCollector >> visitVariable: aVariable [
	aVariable id ifNotNil: [ variablesWithId add: aVariable ]
]
