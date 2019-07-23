Class {
	#name : #SFactoryMessageTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests-Nodes'
}

{ #category : #tests }
SFactoryMessageTest >> testInsertAsParameterUsing [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo2.
	aExpression := testCase addFactoryMessage.
	testCase addMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := SFoo new.'.
			'_var1 := _var0 return: _var0.'}.
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self assert: ({'_var1 := _var0 return: _var0.'} includes: insertedExpression printString)
]

{ #category : #tests }
SFactoryMessageTest >> testInsertMethodMessageUsing [
	| testCase aExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	aExpression := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}.
	self should: [aExpression insertMethodMessage: aExpression using: testCase] raise: SError.
]

{ #category : #tests }
SFactoryMessageTest >> testInsertRandomMessageUsing [
	| testCase factoryMessage |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	factoryMessage := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}.
	factoryMessage insertRandomMessage: factoryMessage using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			{'_var0 := 7.3.' . '_var2 := SFoo score: _var0.'.
			'_var1 := SFoo score: _var0.'}
]
