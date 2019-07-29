Class {
	#name : #SMessageTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Generator-Nodes'
}

{ #category : #tests }
SMessageTest >> testInsertAsParameterUsing [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	testCase addFactoryMessage.
	testCase addLiteral: #ByteString.
	aExpression := testCase addMessage: #returnString from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var1 returnString.'}.
	testCase addMessage: #return: from: #SFoo.
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self
		assert:
			({'_var4 := _var1 return: _var3.'}
				includes: insertedExpression printString)
]

{ #category : #tests }
SMessageTest >> testInsertMethodMessageUsing [
	| testCase message |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	message := testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var1 return: _var2.'}.
	message insertMethodMessage: message using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var1 return: _var2.'.
			'_var4 := _var1 return: _var2.'}
]
