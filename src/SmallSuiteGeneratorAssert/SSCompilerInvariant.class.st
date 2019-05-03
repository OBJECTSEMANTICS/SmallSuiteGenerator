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
		| _var0 _var1 _var3 _var4 _var5 _var6 _var7 _var2 _var8 _var9 |
_var0 := 45.
_var1 := SStudent new.
_var3 := _var1 idStudent.
_var4 := _var1 scoreStudent: _var0.
_var5 := _var1 scoreStudent.
_var6 := _var1 nickname.
_var7 := _var1 scoreStudent: _var0.
_var2 := _var1 scoreStudent: _var5.
_var8 := _var1 scoreStudent.
_var9 := '''$student_An\'''.
^ self analyze: thisContext
]

{ #category : #'as yet unclassified' }
SSCompilerInvariant >> executeMethodTest [
	^ self compiledTest 
]

{ #category : #'as yet unclassified' }
SSCompilerInvariant >> executeMethodUsing: aTestCase [
	testCase := aTestCase.
	^ self compiledTest
]

{ #category : #initialization }
SSCompilerInvariant >> initialize [ 
	evaluator := SSEvaluatorInvariant new.
]
