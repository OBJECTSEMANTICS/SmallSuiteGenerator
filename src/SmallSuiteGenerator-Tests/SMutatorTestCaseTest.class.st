Class {
	#name : #SMutatorTestCaseTest,
	#superclass : #TestCase,
	#instVars : [
		'mutator',
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #running }
SMutatorTestCaseTest >> setUp [
	mutator := SMutatorTestCase new.
	utility := SUtilityTypeInfo new.
]

{ #category : #tests }
SMutatorTestCaseTest >> testRemoveArgsMethod [
	| testCase expression numExprsBefore numExprsAfter |
	testCase := SSTestCase with: utility typeInfosSFoo first.
	mutator := SMutatorTestCase with: testCase.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	numExprsBefore := testCase numberStatements.
	expression := testCase statementOfVarName: '_var2'.
	mutator removeExpression: expression.
	numExprsAfter := testCase numberStatements.
	self assert: numExprsAfter equals: numExprsBefore
]

{ #category : #tests }
SMutatorTestCaseTest >> testRemoveExpression [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfosSFoo first.
	mutator := SMutatorTestCase with: testCase.
	expression := testCase addLiteral.
	mutator removeExpression: expression.
	self assert: testCase statements isEmpty
]

{ #category : #tests }
SMutatorTestCaseTest >> testRemoveExpressionWithoutRepairing [
	| testCase expression  |
	testCase := SSTestCase with: utility typeInfosSFoo first.
	mutator := SMutatorTestCase with: testCase.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	expression := testCase statementOfVarName: '_var2'.
	mutator removeExpressionWithoutRepairing: expression.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' ).
]

{ #category : #tests }
SMutatorTestCaseTest >> testRemoveInEmptyTestCase [
	| testCase |
	testCase := SSTestCase with: utility typeInfosSFoo first.
	mutator := SMutatorTestCase with: testCase.
	self should: [ mutator removeExpression: nil ] raise: SError
]

{ #category : #tests }
SMutatorTestCaseTest >> testRepair [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfosSFoo first.
	mutator := SMutatorTestCase with: testCase.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	expression := testCase statementOfVarName: '_var2'.
	self should: [ mutator repair: expression ] raise: SError.
	testCase removeFromStatements: expression.
	self assert: (mutator repair: expression) isEmpty.
	expression := testCase statementOfVarName: '_var3'.
	self
		assertCollection: (expression value args collect: #printString)
		hasSameElements: #('_var4').
	self
		assert:
			(((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString) includes: '_var4 := ''hello''.')
]

{ #category : #tests }
SMutatorTestCaseTest >> testValidateTestCase [
	self should: [mutator validateTestCase] raise: SError.
	mutator testCase: nil.
	self should: [mutator validateTestCase] raise: SError.
	mutator testCase: (SSTestCase with: nil).
	self should: [mutator validateTestCase] raise: SError
]
