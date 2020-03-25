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
	testCase := SSTestCase with: utility typeInfoSStack4.
	testCase addFactoryMessage: #SStack ofSelector: #newStackWith:.
	expression := testCase
		addFieldAccessMessage: #firstLinkStack
		from: #SStack.
	testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := #(1 4 5 ).' '_var1 := SStack newStackWith: _var0.' '_var2 := _var1 firstLinkStack.' '_var3 := 5.').
	testCase addMessage: #push: from: #SStack.
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
	testCase addTargetClassName: #SFoo;addFactoryMessage: #SFoo.
	aExpression := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.').
	aExpression insertRandomMessage: aExpression using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.' '_var3 := _var1 score.')
]
