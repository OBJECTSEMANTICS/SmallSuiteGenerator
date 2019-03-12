Class {
	#name : #SSCompilerInvariant,
	#superclass : #Object,
	#instVars : [
		'evaluator'
	],
	#category : #'SmallSuiteGeneratorAssert-Invariant'
}

{ #category : #testing }
SSCompilerInvariant >> analyze: aContext [
	| invariants |
	invariants := OrderedCollection new.
	aContext tempNames doWithIndex: [ :title :index | 
		invariants addAll: (evaluator applyRule: title to: (aContext namedTempAt: index)).
	].
	^ invariants
]

{ #category : #compiling }
SSCompilerInvariant >> compile: aBlock [
	self class compile: ('compiledTest
		',aBlock body formattedCode)
]

{ #category : #'as yet unclassified' }
SSCompilerInvariant >> compiledTest [
		| _var1 _var2 |
_var1 := Stack new.
_var2 := _var1 push: 1.
^ self analyze: thisContext
]

{ #category : #'as yet unclassified' }
SSCompilerInvariant >> executeMethodTest [
	^ self compiledTest 
]

{ #category : #initialization }
SSCompilerInvariant >> initialize [ 
	evaluator := SSEvaluatorInvariant new.
]
