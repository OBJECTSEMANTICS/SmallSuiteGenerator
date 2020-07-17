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
	testCase targetClassName: (self fullSymbolOf: #SFoo);
	addLiteral: (self fullSymbolOf: #ByteString).
	expression := testCase addLiteral: (self fullSymbolOf: #ByteString).
	testCase addFactoryMessage: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := ''hello''.'
									with: '_var1 := ''hello''.'
									with: '_var2 := 7.3.'
									with: ('_var3 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var2.')).
	testCase addMessage: #return: from: (self fullSymbolOf: #SFoo).
	insertedExpression := expression
		insertAsParameter: expression
		using: testCase.
	self
		assert: insertedExpression printString
		equals: '_var5 := _var3 return: _var1.'
]

{ #category : #tests }
SLiteralTest >> testInsertParameterOn [
	| testCase expression insertedExpression |
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase targetClassName: (self fullSymbolOf: #SFoo); 
	addLiteral: (self fullSymbolOf: #SStudent); 
	addMessage: #return: from: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ' , SStudent new storeString , '.'
				with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' new.'
				with: '_var2 := _var1 return: _var0.').
	expression := testCase addLiteral: (self fullSymbolOf: #SStudent).
	self
		should: [ insertedExpression := expression
				insertAsParameter: expression
				using: testCase ]
		raise: SError.
	testCase addMessage: #return: from: (self fullSymbolOf: #SFoo).
	self
		shouldnt: [ insertedExpression := expression
				insertAsParameter: expression
				using: testCase ]
		raise: SError.
	self
		assert: insertedExpression printString
		equals: '_var5 := _var1 return: _var3.'
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
