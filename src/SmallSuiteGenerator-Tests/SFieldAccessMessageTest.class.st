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
	self assert: expression printString equals: '_aSStack0 firstLinkStack'.
	copy := expression copy.
	copy value receiver varName: '_sstack'.
	copy value receiver id: 4.
	self assert: copy printString equals: '_sstack4 firstLinkStack'.
	copy value selector: #lastLinkStack.
	self assert: copy printString equals: '_sstack4 lastLinkStack'.
	self assert: expression printString equals: '_aSStack0 firstLinkStack'
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
			#('_anArray0 := #(1 4 5 ).' '_aSStack1 := SStack newStackWith: _anArray0.' '_aSmallInteger2 := _aSStack1 firstLinkStack.' '_aSmallInteger3 := 5.').
	testCase addMessage: #push: from: #SStack.
	insertedExpression := expression
		insertAsParameter: expression
		using: testCase.
	self
		assert: insertedExpression printString
		equals: '_aSmallInteger4 := _aSStack1 push: _aSmallInteger2.'
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
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo1 score.').
	aExpression insertRandomMessage: aExpression using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo1 score.' '_aSmallFloat643 := _aSFoo1 score.')
]
