Class {
	#name : #SLiteralTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests-Nodes'
}

{ #category : #tests }
SLiteralTest >> testInsertAsParameterUsing [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	testCase addMessage: #return: from: #SFoo.
	aExpression := testCase addLiteral: #ByteString.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.'. '_var1 := SFoo score: _var0.'. '_var2 := ''hello''.'. '_var3 := _var1 return: _var2.'. '_var4 := ''hello''.'}.
	testCase addMessage: #return: from: #SFoo.
	insertedExpression := aExpression insertAsParameter: aExpression using: testCase.
	self assert: insertedExpression printString equals: '_var5 := _var1 return: _var4.'.
]
