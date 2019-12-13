Class {
	#name : #SSTestRunnerTest,
	#superclass : #TestCase,
	#instVars : [
		'utility',
		'testRunner'
	],
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #running }
SSTestRunnerTest >> setUp [ 
	testRunner := SSTestRunner new.
	utility := SUtilityTypeInfo new.
]

{ #category : #tests }
SSTestRunnerTest >> testCompileUsingParsing [
	| testCase numStatementsBefore |
	testCase := utility testCaseSFoo.
	numStatementsBefore := testCase length.
	self shouldnt: [ testRunner compile: testCase usingParsing: #parseTree ] raise: Error.
	self assert: testCase length < numStatementsBefore.
]

{ #category : #tests }
SSTestRunnerTest >> testRun [ 
	| testCase |
	testCase := utility testCaseSFoo.
	testRunner compile: testCase usingParsing: #parseTree.
	testCase generateAssertions: 
		(Array with: SInspectorAssertion
		with: SComparisonAssertion 
		with: SPrimitiveAssertion 
		with: SStringAssertion ).
	self should: [ testRunner run: testCase ] raise: SError.
]
