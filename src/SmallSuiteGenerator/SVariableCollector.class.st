Class {
	#name : #SVariableCollector,
	#superclass : #SVisitor,
	#instVars : [
		'variables'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #initalize }
SVariableCollector >> initialize [
	super initialize.
	variables := Set new.
]

{ #category : #visiting }
SVariableCollector >> visitVariable: aVariable [
	""

	variables add: aVariable
]
