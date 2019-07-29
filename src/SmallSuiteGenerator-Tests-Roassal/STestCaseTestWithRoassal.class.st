Class {
	#name : #STestCaseTestWithRoassal,
	#superclass : #TestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #running }
STestCaseTestWithRoassal >> setUp [ 	
	utility := SUtilityRoassal new
]

{ #category : #tests }
STestCaseTestWithRoassal >> testInsertAsParameterUsingOnRTAMItem [
	| testCase auxExpr expression |
	testCase := SSTestCase with: utility typeInfosRTAMItem first.
	expression := testCase addFactoryMessage.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := SFoo new.' . '_var1 := SFoo new.'}.
	auxExpr := testCase addMessage.
	auxExpr value
		receiver: (testCase statementOfVarName: '_var1') variable.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_var2 := _var1 return: _var0.'
]

{ #category : #tests }
STestCaseTestWithRoassal >> testInsertAsParameterUsingOnRTBorderAttachPoint [
	| testCase auxExpr expression |
	testCase := SSTestCase with: utility typeInfosRTBorderAttachPoint first.
	expression := testCase addFactoryMessage.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := SFoo new.' . '_var1 := SFoo new.'}.
	auxExpr := testCase addMessage.
	auxExpr value
		receiver: (testCase statementOfVarName: '_var1') variable.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_var2 := _var1 return: _var0.'
]

{ #category : #tests }
STestCaseTestWithRoassal >> testInsertAsParameterUsingOnRTBox [
	| testCase auxExpr expression |
	testCase := SSTestCase
		with: utility typeInfoRTBox first.
	expression := testCase addFactoryMessage.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := SFoo new.' . '_var1 := SFoo new.'}.
	auxExpr := testCase addMessage.
	auxExpr value
		receiver: (testCase statementOfVarName: '_var1') variable.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_var2 := _var1 return: _var0.'
]

{ #category : #tests }
STestCaseTestWithRoassal >> testInsertAsParameterUsingOnRTDirectedLine [
	| testCase auxExpr expression |
	testCase := SSTestCase with: utility typeInfosRTDirectedLine first.
	expression := testCase addFactoryMessage.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := SFoo new.' . '_var1 := SFoo new.'}.
	auxExpr := testCase addMessage.
	auxExpr value
		receiver: (testCase statementOfVarName: '_var1') variable.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_var2 := _var1 return: _var0.'
]

{ #category : #tests }
STestCaseTestWithRoassal >> testInsertAsParameterUsingOnRTLineSegment [
	| testCase auxExpr expression |
	testCase := SSTestCase with: utility typeInfosRTLineSegment first.
	expression := testCase addFactoryMessage.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := SFoo new.' . '_var1 := SFoo new.'}.
	auxExpr := testCase addMessage.
	auxExpr value
		receiver: (testCase statementOfVarName: '_var1') variable.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_var2 := _var1 return: _var0.'
]
