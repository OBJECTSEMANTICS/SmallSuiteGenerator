Class {
	#name : #SMessageTest,
	#superclass : #SUnitTestCase,
	#category : #'SmallSuiteGenerator-Tests-Nodes'
}

{ #category : #tests }
SMessageTest >> testCopy [
	| testCase expression copy |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	expression := testCase addMessage: #return: from: #SFoo.
	self
		assert: expression printString
		equals: '_var3 := _var1 return: _var2.'.

	copy := expression copy.
	copy value args first id: 5.
	self assert: copy printString equals: '_var3 := _var1 return: _var5.'.
	copy value receiver varName: '_sfoo'.
	copy value receiver id: 4.
	self
		assert: copy printString
		equals: '_var3 := _sfoo4 return: _var5.'.
	copy value selector: #returnValue:.
	self
		assert: copy printString
		equals: '_var3 := _sfoo4 returnValue: _var5.'.
	copy variable varName: '_value'.
	copy variable id: 6.
	self
		assert: copy printString
		equals: '_value6 := _sfoo4 returnValue: _var5.'.
	self
		assert: expression printString
		equals: '_var3 := _var1 return: _var2.'
]

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
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.'  '_var3 := _var1 returnString.').
	testCase addMessage: #return: from: #SFoo.
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self
		assert:
			(#('_var4 := _var1 return: _var3.')
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
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.'  '_var3 := _var1 return: _var2.').
	message insertMethodMessage: message using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.'  '_var1 := SFoo score: _var0.'
			'_var2 := ''hello''.'  '_var3 := _var1 return: _var2.'
			'_var4 := _var1 return: _var2.')
]
