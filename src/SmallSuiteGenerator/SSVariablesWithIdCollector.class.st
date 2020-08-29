Class {
	#name : #SSVariablesWithIdCollector,
	#superclass : #SSVisitor,
	#instVars : [
		'variablesWithId'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #initialization }
SSVariablesWithIdCollector >> initialize [
	super initialize.
	variablesWithId := OrderedCollection new.
]

{ #category : #accessing }
SSVariablesWithIdCollector >> variablesWithId [
	^ variablesWithId
]

{ #category : #visiting }
SSVariablesWithIdCollector >> visit: sNode [
	sNode accept: self
]

{ #category : #'visiting-core' }
SSVariablesWithIdCollector >> visitVariable: aVariable [
	aVariable id ifNotNil: [ variablesWithId add: aVariable ]
]
