Class {
	#name : #SLiteralTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SLiteralTest >> testCopy [
	| literal copy |
	literal := (SLiteral value: 'hello') returnType: #ByteString.
	self assert: literal printString equals: '''hello'''.
	copy := literal copy.
	copy value: 'world'.
	self assert: copy printString equals: '''world'''
]

{ #category : #tests }
SLiteralTest >> testEqual [
	|literal|
	literal := SLiteral value: 1.
	self assert: (SLiteral value: 1) equals: literal.
	literal value: 3.
	self deny: (SLiteral value: -3) equals: literal.
	literal value: #().
	self assert: (SLiteral value: #()) equals: literal.
	literal value: SStudent new.
	self assert: (SLiteral value: SStudent new) equals: literal
]

{ #category : #tests }
SLiteralTest >> testInsertAsParameterUsing [
	| testCase expression insertedExpression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addLiteral: #ByteString.
	expression := testCase addLiteral: #ByteString.
	testCase addFactoryMessage:#SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := ''hello''.' '_var1 := ''hello''.' '_var2 := 7.3.' '_var3 := SFoo score: _var2.').
	testCase addMessage: #return: from: #SFoo.
	insertedExpression := expression
		insertAsParameter: expression
		using: testCase.
	self
		assert: insertedExpression printString
		equals: '_var4 := _var3 return: _var1.'
]

{ #category : #tests }
SLiteralTest >> testInsertParameterOn [
	| testCase expression insertedExpression |
	testCase := SSTestCase with: utility typeInfoSFoo5.
	testCase addLiteral: #SStudent.
	testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ' , SStudent new storeString , '.'
				with: '_var1 := SFoo new.'
				with: '_var2 := _var1 return: _var0.').
	expression := testCase addLiteral: #SStudent.
	self
		should: [ insertedExpression := expression
				insertAsParameter: expression
				using: testCase ]
		raise: SError.
	testCase addMessage: #return: from: #SFoo.
	self
		shouldnt: [ insertedExpression := expression
				insertAsParameter: expression
				using: testCase ]
		raise: SError.
	self
		assert: insertedExpression printString
		equals: '_var4 := _var1 return: _var3.'
]

{ #category : #tests }
SLiteralTest >> testReferenceTo [
	|literal|
	literal := SLiteral value: 1.
	self assert: ((SLiteral new value: 1) referenceTo: #SmallInteger).
	literal value: SStudent new.
	self
		assert: ((SLiteral new value: SStudent new) referenceTo: #SStudent)
]
