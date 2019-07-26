Class {
	#name : #SLiteralTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests-Nodes'
}

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
