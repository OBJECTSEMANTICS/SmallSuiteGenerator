Class {
	#name : #SSCompilerInvariant,
	#superclass : #Object,
	#instVars : [
		'evaluator',
		'testCase'
	],
	#category : #'SmallSuiteGeneratorAssert-Invariant'
}

{ #category : #testing }
SSCompilerInvariant >> analyze: aContext [
	| invariants |
	invariants := OrderedCollection new.
	aContext tempNames
		doWithIndex: [ :title :index | 
			invariants
				addAll: (evaluator applyRule: title to: (aContext namedTempAt: index) of: testCase) ].
	^ invariants
]

{ #category : #compiling }
SSCompilerInvariant >> compile: aBlock [
	self class compile: ('compiledTest
		',aBlock body formattedCode)
]

{ #category : #'as yet unclassified' }
SSCompilerInvariant >> compiledTest [
]

{ #category : #'as yet unclassified' }
SSCompilerInvariant >> executeMethodTest [
	^ self compiledTest 
]

{ #category : #'as yet unclassified' }
SSCompilerInvariant >> executeMethodUsing: aTestCase [
	testCase := aTestCase.
	^ self compiledTest
	"^ [ self compiledTest ]
		on: Exception
		do: [ #() ]"
]

{ #category : #initialization }
SSCompilerInvariant >> initialize [ 
	evaluator := SSEvaluatorInvariant new.
]
