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
	testCase addTargetClassName: #SFoo;addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.').
	numExprsBefore := testCase numberStatements.
	expression := testCase statementOfVarName: '_aByteString2'.
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
	testCase addTargetClassName: #SFoo;addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.').
	expression := testCase statementOfVarName: '_aByteString2'.
	testCase removeExpressionWithoutRepairing: expression.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.')
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
	testCase addTargetClassName: #SFoo;addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.').
	expression := testCase statementOfVarName: '_aByteString2'.
	self should: [ testCase repair: expression ] raise: SError.
	testCase removeFromStatements: expression.
	self assert: (testCase repair: expression) isEmpty.
	expression := testCase statementOfVarName: '_aByteString3'.
	self
		assertCollection: (expression value args collect: #printString)
		hasSameElements: #('_aByteString4').
	self
		assert:
			(((testCase subStatementsFrom: 1 toPrevIndexOf: expression)
				collect: #printString)
				includesAny: #('_aByteString4 := ''hello''.' '_aByteString4 := _aSFoo1 returnString.'))
]
