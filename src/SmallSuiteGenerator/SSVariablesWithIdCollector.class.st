"
SSVariablesWithIdCollector collect all references of variables in a sentence, with the objective of not having reference errors in the construction of the testCase.
"
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
