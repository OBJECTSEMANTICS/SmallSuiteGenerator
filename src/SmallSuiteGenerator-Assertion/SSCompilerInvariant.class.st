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
		| _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var15 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 |
_var0 := RTBezier3Line new.
_var1 := RTDummyNode new.
_var2 := RTNoShape new.
_var3 := RTGroup new.
_var4 := 35.
_var5 := 1 to: 40.
_var6 := 206.0 @ 206.0.
_var15 := RTBezier3Line new.
_var7 := RTDraggableView basicNew
	instVarAt: 1 put: TRMouseDragStart;
	yourself.
_var8 := TRCanvas new.
_var9 := 3.
_var10 := RTCompoundElement new.
_var11 := Color
	r: 0.0
	g: 0.0
	b: 0.0
	alpha: 1.0.
_var12 := RTCompoundElement new.
_var13 := RTPolyLineSegment new.
_var14 := TRCanvas new.
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
