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
		| _rtamitem0 _bytStr1 _rtamitem2 _rtamitem6 _rtamitem7 _rtamitem8 _bytStr9 _rtamitem12 _rtamitem17 _rtamitem21 _rtamitem28 |
_rtamitem0 := RTAMItem new.
_bytStr1 := 'France'.
_rtamitem2 := _rtamitem0 column: _bytStr1.
_rtamitem6 := _rtamitem0 itemName: _bytStr1.
_rtamitem7 := _rtamitem0 column: 'Bonus Card'.
_rtamitem8 := _rtamitem0
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_bytStr9 := 'France'.
_rtamitem12 := _rtamitem0 row: _bytStr9.
_rtamitem17 := _rtamitem0 column: _bytStr9.
_rtamitem21 := _rtamitem0 row: 'Bonus Card'.
_rtamitem28 := _rtamitem0 initialize.
^ self analyze: thisContext
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
