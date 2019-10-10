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
		| _var0 _var1 _var2 _var3 _var4 _var6 _var7 _var8 _var9 |
_var0 := SSTeacher new.
_var1 := SSTeacher new.
_var2 := _var0 idTeacher.
_var3 := SSTeacher new.
_var4 := _var0 nickname.
_var6 := _var0 nickname.
_var7 := _var0 yearsWorkExperience.
_var8 := _var0 nickname.
_var9 := SSTeacher new.
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
