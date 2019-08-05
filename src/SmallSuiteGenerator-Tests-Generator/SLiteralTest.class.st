Class {
	#name : #SLiteralTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Generator-Nodes'
}

{ #category : #tests }
SLiteralTest >> testCopy [
	| testCase expression copy |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	expression := testCase addLiteral: #ByteString.
	self assert: expression printString equals: '_var0 := ''hello''.'.
	copy := expression copy.
	copy value value: 'world'.
	self assert: copy printString equals: '_var0 := ''world''.'.
	copy variable varName: '_string'.
	copy variable id: 2.
	self assert: copy printString equals: '_string2 := ''world''.'.
	self assert: expression printString equals: '_var0 := ''hello''.'
]

{ #category : #tests }
SLiteralTest >> testInsertAsParameterUsing [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	testCase addLiteral: #ByteString.
	aExpression := testCase addLiteral: #ByteString.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := ''hello''.' . '_var1 := ''hello''.' . '_var2 := 7.3.'.
			'_var3 := SFoo score: _var2.'}.
	testCase addMessage: #return: from: #SFoo.
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self
		assert: insertedExpression printString
		equals: '_var4 := _var3 return: _var1.'
]
