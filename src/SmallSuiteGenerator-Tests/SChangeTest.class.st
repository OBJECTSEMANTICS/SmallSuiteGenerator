Class {
	#name : #SChangeTest,
	#superclass : #SSTestCaseTest,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFactoryMessageWithAbstractClass [
	| testCase changed |
	testCase := SSTestCaseForTest with: utility typeInfoAthensCairo.
	testCase
		addTargetClassName: #AthensCairoCanvas;
		addFactoryMessage;
		addLiteral;
		addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := AthensCairoCanvas new.' '_var1 := ''hello''.' '_var2 := AthensCairoCanvas new.').
	changed := testCase changeStatementOfClassName: #AthensCairoCanvas.
	self assert: changed equals: false.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var1 := ''hello''.')
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFactoryMessageWithMoreThanOneLiteral [
	| testCase expression expressionChanged |
	testCase := SSTestCaseForTest with: utility typeInfoSFoo1.
	testCase
		addLiteral: #SmallFloat64;
		addLiteral: #SmallFloat64.
	expression := testCase addFactoryMessage: #SFoo ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: #('_var0 := 7.3.' '_var1 := 7.3.').
	self
		assert:
			(#('_var2 := SFoo score: _var0.' '_var2 := SFoo score: _var1.')
				includes: expression printString).
	expressionChanged := testCase changeStatementOfVarName: '_var2'.
	self
		assert:
			(#('_var2 := SFoo score: _var0.' '_var2 := SFoo score: _var1.' '_var2 := SFoo new.')
				includes: expressionChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFactoryMessageWithOneLiteral [
	| testCase expressionChanged |
	testCase := SSTestCaseForTest with: utility typeInfoSFoo1.
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	expressionChanged := testCase changeStatementOfVarName: '_var1'.
	self
		assert:
			(#('_var1 := SFoo new.' '_var1 := SFoo score: _var2.')
				includes: expressionChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFieldAccessMessage [
	| testCase exprField exprFieldChanged |
	testCase := SSTestCaseForTest with: utility typeInfoSStack4.
	testCase
		addTargetClassName: #SStack;
		addFactoryMessage: #SStack ofSelector: #newStack.
	exprField := (testCase
		addFieldAccessMessage: #firstLinkStack
		from: #SStack) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := SStack newStack.' '_var1 := _var0 firstLinkStack.').
	exprFieldChanged := testCase changeStatement: exprField.
	self
		assert:
			(#('_var1 := _var0 lastLinkStack.' '_var1 := _var3 firstLinkStack.' '_var1 := _var2 firstLinkStack.')
				includes: exprFieldChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfLiteral [
	| testCase exprLiteral exprLiteralChanged |
	testCase := SSTestCaseForTest with: utility typeInfoSStack4.
	exprLiteral := (testCase addLiteral: #SmallInteger) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 5.').
	exprLiteralChanged := testCase changeStatementOfVarName: '_var0'.
	self deny: exprLiteral equals: exprLiteralChanged.
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfMessage [
	| testCase exprMessage exprLiteralChanged |
	testCase := SSTestCaseForTest with: utility typeInfoSStack4.
	testCase
		addTargetClassName: #SStack;
		addFactoryMessage: #SStack ofSelector: #newStack.
	exprMessage := (testCase addMessage: #pop from: #SStack) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := SStack newStack.' '_var1 := _var0 pop.').
	exprLiteralChanged := testCase changeStatement: exprMessage.
	self
		assert:
			(#('_var1 := _var0 top.' '_var1 := _var0 push: _var2.' '_var1 := _var3 pop.' '_var1 := _var2 pop.')
				includes: exprLiteralChanged printString).
	self assert: testCase validReferences
]
