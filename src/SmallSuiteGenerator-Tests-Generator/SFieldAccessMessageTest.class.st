Class {
	#name : #SFieldAccessMessageTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Generator-Nodes'
}

{ #category : #tests }
SFieldAccessMessageTest >> testInsertAsParameterUsing [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSStack.
	testCase addFactoryMessage: #SStack ofSelector: #newStackWith:.
	aExpression := testCase
		addFieldAccessMessage: #firstLinkStack
		from: #SStack.
	testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := #(1 4 5 ).' . '_var1 := SStack newStackWith: _var0.'.
			'_var2 := _var1 firstLinkStack.' . '_var3 := 5.'}.
	testCase addMessage: #push: from: #SStack.
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self
		assert: insertedExpression printString
		equals: '_var4 := _var1 push: _var2.'
]

{ #category : #tests }
SFieldAccessMessageTest >> testInsertRandomMessageUsing [
	| testCase aExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	aExpression := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := _var1 score.'}.
	aExpression insertRandomMessage: aExpression using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := _var1 score.' . '_var3 := _var1 score.'}
]