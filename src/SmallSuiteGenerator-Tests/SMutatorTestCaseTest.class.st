Class {
	#name : #SMutatorTestCaseTest,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #running }
SMutatorTestCaseTest >> setUp [

	utility := SUtilityTypeInfo new.
]

{ #category : #tests }
SMutatorTestCaseTest >> testRemoveArgsMethod [
	| testCase expression numExprsBefore numExprsAfter |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	numExprsBefore := testCase numberStatements.
	expression := testCase statementOfVarName: '_var2'.
	testCase removeExpression: expression.
	numExprsAfter := testCase numberStatements.
	self assert: numExprsAfter equals: numExprsBefore
]

{ #category : #tests }
SMutatorTestCaseTest >> testRemoveExpression [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	expression := testCase addLiteral.
	testCase removeExpression: expression.
	self assert: testCase statements isEmpty
]

{ #category : #tests }
SMutatorTestCaseTest >> testRemoveExpressionWithoutRepairing [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	expression := testCase statementOfVarName: '_var2'.
	testCase removeExpressionWithoutRepairing: expression.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.')
]

{ #category : #tests }
SMutatorTestCaseTest >> testRemoveInEmptyTestCase [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	self should: [ testCase removeExpression: nil ] raise: SError
]

{ #category : #tests }
SMutatorTestCaseTest >> testRepair [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	expression := testCase statementOfVarName: '_var2'.
	self should: [ testCase repair: expression ] raise: SError.
	testCase removeFromStatements: expression.
	self assert: (testCase repair: expression) isEmpty.
	expression := testCase statementOfVarName: '_var3'.
	self
		assertCollection: (expression value args collect: #printString)
		hasSameElements: #('_var4').
	self
		assert:
			(((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString) includesAny: #('_var4 := ''hello''.' '_var4 := _var1 returnString.'))
]
