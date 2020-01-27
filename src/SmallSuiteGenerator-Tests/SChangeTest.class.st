Class {
	#name : #SChangeTest,
	#superclass : #SSTestCaseTest,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFactoryMessageWithAbstractClass [
	| testCase changed |
	testCase := (SSTestCase with: utility typeInfoArrayedCollection).
	testCase
		addTargetClassName: #ArrayedCollection;
		addFactoryMessage;
		addLiteral;
		addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_anArrayedCollection0 := ArrayedCollection new.' '_aByteString1 := ''hello''.' '_anArrayedCollection2 := ArrayedCollection new.').
	changed := testCase changeStatementOfClassName: #ArrayedCollection.
	self assert: changed equals: false.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aByteString1 := ''hello''.')
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFactoryMessageWithMoreThanOneLiteral [
	| testCase expression expressionChanged |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase
		addLiteral: #SmallFloat64;
		addLiteral: #SmallFloat64.
	expression := testCase addFactoryMessage: #SFoo ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: #('_aSmallFloat640 := 7.3.' '_aSmallFloat641 := 7.3.').
	self
		assert:
			(#('_aSFoo2 := SFoo score: _aSmallFloat640.' '_aSFoo2 := SFoo score: _aSmallFloat641.')
				includes: expression printString).
	expressionChanged := testCase changeStatementOfVarName: '_aSFoo2'.
	self
		assert:
			(#('_aSFoo2 := SFoo score: _aSmallFloat640.' '_aSFoo2 := SFoo score: _aSmallFloat641.' '_aSFoo2 := SFoo new.')
				includes: expressionChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFactoryMessageWithOneLiteral [
	| testCase expressionChanged |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.').
	expressionChanged := testCase changeStatementOfVarName: '_aSFoo1'.
	self
		assert:
			(#('_aSFoo1 := SFoo new.' '_aSFoo1 := SFoo score: _aSmallFloat642.')
				includes: expressionChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFieldAccessMessage [
	| testCase exprField exprFieldChanged |
	testCase := SSTestCase with: utility typeInfoSStack4.
	testCase addTargetClassName: #SStack;
	addFactoryMessage: #SStack ofSelector: #newStack.
	exprField := (testCase
		addFieldAccessMessage: #firstLinkStack
		from: #SStack) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSStack0 := SStack newStack.' '_aSmallInteger1 := _aSStack0 firstLinkStack.').
	exprFieldChanged := testCase changeStatement: exprField.
	self
		assert:
			(#('_aSmallInteger1 := _aSStack0 lastLinkStack.' '_aSmallInteger1 := _aSStack3 firstLinkStack.' '_aSmallInteger1 := _aSStack2 firstLinkStack.')
				includes: exprFieldChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfLiteral [
	| testCase exprLiteral exprLiteralChanged |
	testCase := SSTestCase with: utility typeInfoSStack4.
	exprLiteral := (testCase addLiteral: #SmallInteger) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallInteger0 := 5.').
	exprLiteralChanged := testCase changeStatementOfVarName: '_aSmallInteger0'.
	self deny: exprLiteral equals: exprLiteralChanged.
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfMessage [
	| testCase exprMessage exprLiteralChanged |
	testCase := SSTestCase with: utility typeInfoSStack4.
	testCase addTargetClassName: #SStack;
	addFactoryMessage: #SStack ofSelector: #newStack.
	exprMessage := (testCase addMessage: #pop from: #SStack) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSStack0 := SStack newStack.' '_aSmallInteger1 := _aSStack0 pop.').
	exprLiteralChanged := testCase changeStatement: exprMessage.
	self
		assert:
			(#('_aSmallInteger1 := _aSStack0 top.' '_aSmallInteger1 := _aSStack0 push: _aSmallInteger2.' '_aSmallInteger1 := _aSStack3 pop.' '_aSmallInteger1 := _aSStack2 pop.')
				includes: exprLiteralChanged printString).
	self assert: testCase validReferences
]
