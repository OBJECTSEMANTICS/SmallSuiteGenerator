Class {
	#name : #SFactoryMessageTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SFactoryMessageTest >> testCopy [
	| testCase expression copy |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	expression := testCase addFactoryMessage.
	self
		assert: expression printString
		equals: '_var1 := SFoo score: _var0.'.
	copy := expression copy.
	self assert: copy printString equals: expression printString.
	copy value args first id: 1.
	self assert: copy printString equals: '_var1 := SFoo score: _var1.'.
	
	copy value receiver varName: #SStudent.
	self
		assert: copy printString
		equals: '_var1 := SStudent score: _var1.'.
	copy value selector: #name:.
	self
		assert: copy printString
		equals: '_var1 := SStudent name: _var1.'.
	copy variable varName: '_assignment'.
	copy variable id: 3.
	self
		assert: copy printString
		equals: '_assignment3 := SStudent name: _var1.'.
	self
		assert: expression printString
		equals: '_var1 := SFoo score: _var0.'
]

{ #category : #tests }
SFactoryMessageTest >> testInsertAsParameterUsing [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo2.
	aExpression := testCase addFactoryMessage.
	testCase addMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := SFoo new.'  '_var1 := _var0 return: _var0.').
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self
		assert:
			(#('_var1 := _var0 return: _var0.')
				includes: insertedExpression printString)
]

{ #category : #tests }
SFactoryMessageTest >> testInsertMethodMessageUsing [
	| testCase aExpression |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	aExpression := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.'  '_var1 := SFoo score: _var0.').
	self
		should: [ aExpression insertMethodMessage: aExpression using: testCase ]
		raise: SError
]

{ #category : #tests }
SFactoryMessageTest >> testInsertRandomMessageUsing [
	| testCase factoryMessage |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	factoryMessage := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	factoryMessage insertRandomMessage: factoryMessage using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			#('_var0 := 7.3.' '_var2 := SFoo score: _var0.' '_var1 := SFoo score: _var0.')
]
