Class {
	#name : #SFieldAccessMessageTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SFieldAccessMessageTest >> testCopy [
	| expression copy |
	expression := SFieldAccessMessage new
		receiver:
			(SVariable new
				id: 0;
				returnType: #SStack);
		selector: #firstLinkStack.
	self assert: expression printString equals: '_var0 firstLinkStack'.
	copy := expression copy.
	copy value receiver varName: '_sstack'.
	copy value receiver id: 4.
	self assert: copy printString equals: '_sstack4 firstLinkStack'.
	copy value selector: #lastLinkStack.
	self assert: copy printString equals: '_sstack4 lastLinkStack'.
	self assert: expression printString equals: '_var0 firstLinkStack'
]

{ #category : #tests }
SFieldAccessMessageTest >> testInsertAsParameterUsing [
	| testCase expression insertedExpression |
	testCase := (SSTestCase with: utility typeInfoSStack4)
		targetClassName: (self fullSymbolOf: #SStack).
	testCase addFactoryMessage: (self fullSymbolOf: #SStack) usingSelector: #newStackWith:.
	expression := testCase
		addFieldAccessMessage: #firstLinkStack
		from: (self fullSymbolOf: #SStack).
	testCase addLiteral: (self fullSymbolOf: #SmallInteger).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
								with: '_var0 := #(1 4 5 ).'
								with: ('_var1 := ', (self fullNameOfClass: 'SStack')asString,' newStackWith: _var0.')
								with: '_var2 := _var1 firstLinkStack.' 
								with: '_var3 := 5.').
	testCase addMessage: #push: from: (self fullSymbolOf: #SStack).
	insertedExpression := expression
		insertAsParameter: expression
		using: testCase.
	self
		assert: insertedExpression printString
		equals: '_var5 := _var1 push: _var2.'
]

{ #category : #tests }
SFieldAccessMessageTest >> testInsertRandomMessageUsing [
	| testCase aExpression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: (self fullSymbolOf: #SFoo);
	addFactoryMessage: (self fullSymbolOf: #SFoo).
	aExpression := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: ('_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.')
									with: '_var2 := _var1 score.').
	aExpression insertRandomMessage: aExpression using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: (Array 
								with: '_var0 := 7.3.'
								with: ('_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.')
								with: '_var2 := _var1 score.'
								with: '_var3 := _var1 score.')
]
