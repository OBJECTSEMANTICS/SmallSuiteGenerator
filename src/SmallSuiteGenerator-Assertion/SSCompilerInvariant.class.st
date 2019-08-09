Class {
	#name : #SSCompilerInvariant,
	#superclass : #Object,
	#instVars : [
		'evaluator',
		'testCase',
		'invariants'
	],
	#category : #'SmallSuiteGenerator-Assertion-Invariant'
}

{ #category : #testing }
SSCompilerInvariant >> analyze: aContext [
	| filteredInvariants |
	filteredInvariants := OrderedCollection new.
	aContext tempNames
		doWithIndex: [ :varName :index | 
			filteredInvariants
				addAll:
					(evaluator
						apply: invariants
						invariantsTo: varName
						varNameWith: (aContext namedTempAt: index)
						valueIn: testCase) ].
	^ filteredInvariants
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
SSCompilerInvariant >> executeMethodUsing: aTestCase testCaseAnd: classInvariants [
	testCase := aTestCase.
	invariants := classInvariants.
	^ self compiledTest
]

{ #category : #initialization }
SSCompilerInvariant >> initialize [
	evaluator := SSEvaluatorInvariant new.
	invariants := OrderedCollection new.
]
