Class {
	#name : #SLiteralTest,
	#superclass : #TestCase,
	#instVars : [
		'utility',
		'literal'
	],
	#category : #'SmallSuiteGenerator-Tests-Generator-Nodes'
}

{ #category : #running }
SLiteralTest >> setUp [
	utility := SUtilityTypeInfo new.
	literal := SLiteral new
]

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
SLiteralTest >> testEqual [
	literal value: 1.
	self assert: (SLiteral new value: 1) equals: literal.
	literal value: 3.
	self deny: (SLiteral new value: -3) equals: literal.
	literal value: #().
	self assert: (SLiteral new value: #()) equals: literal.
	literal value: SStudent new.
	self assert: (SLiteral new value: SStudent new) equals: literal
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
			#('_var0 := ''hello''.'  '_var1 := ''hello''.'  '_var2 := 7.3.'
			'_var3 := SFoo score: _var2.').
	testCase addMessage: #return: from: #SFoo.
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self
		assert: insertedExpression printString
		equals: '_var4 := _var3 return: _var1.'
]

{ #category : #tests }
SLiteralTest >> testInsertParameterOn [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: utility typeInfosSFoo fifth.
	testCase addLiteral: #SStudent.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array with: '_var0 := ', SStudent new storeString, '.' 
			with: '_var1 := SFoo new.' 
			with: '_var2 := _var1 return: _var0.').
	aExpression := testCase addLiteral: #SStudent.
	
	self should: [insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase] raise: SError.
	testCase addMessage: #return: from: #SFoo.
	self shouldnt: [ insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase ] raise: SError.
	self
		assert: insertedExpression printString
		equals: '_var4 := _var1 return: _var3.'
]
