Class {
	#name : #SSCompilerInvariant,
	#superclass : #SObject,
	#instVars : [
		'evaluator',
		'testCase',
		'invariants'
	],
	#category : #'SmallSuiteGenerator-Invariant'
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

{ #category : #testing }
SSCompilerInvariant >> compiledTest [
		| _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 |
_var0 := #('abcd' 'efg' 'hij' 'klmn').
_var1 := #('abcd' 'efg' 'hij' 'klmn').
_var2 := SStack newStackWith: _var0.
_var3 := 'opqr'.
_var4 := _var2 push: _var3.
_var5 := 'opqr'.
_var6 := SStack newStackWith: _var0.
_var7 := SStack newStackWith: _var1.
_var8 := _var2 initialize.
_var9 := SStack newStackWith: _var0.
_var10 := SStack newStackWith: _var1.
_var11 := 'opqr'.
_var12 := #('abcd' 'efg' 'hij' 'klmn').
_var13 := SStack newStackWith: _var12.
_var14 := SStack newStackWith: _var1.
^ self analyze: thisContext
]

{ #category : #actions }
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
