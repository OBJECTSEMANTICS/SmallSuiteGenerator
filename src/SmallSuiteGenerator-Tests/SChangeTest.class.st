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
		addTargetClassName: (self fullSymbolOf: #ArrayedCollection);
		addFactoryMessage;
		addLiteral;
		addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: ('_var0 := ', (self fullNameOfClass: 'ArrayedCollection')asString,' new.')
									with: '_var1 := ''hello''.'
									with: ('_var2 := ', (self fullNameOfClass: 'ArrayedCollection')asString,' new.')).
	changed := testCase changeStatementOfClassName: (self fullSymbolOf: #ArrayedCollection).
	self assert: changed equals: false.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var1 := ''hello''.')
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFactoryMessageWithMoreThanOneLiteral [
	| testCase expression expressionChanged |
	testCase := (SSTestCase with: utility typeInfoSFoo1) addTargetClassName: (self fullSymbolOf: #SFoo).
	testCase
		addLiteral: (self fullSymbolOf: #SmallFloat64);
		addLiteral: (self fullSymbolOf: #SmallFloat64).
	expression := testCase addFactoryMessage: (self fullSymbolOf: #SFoo) ofSelector: #score:.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: #('_var0 := 7.3.' '_var1 := 7.3.').
	self
		assert:
			((Array with: '_var3 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var2.')
				includes: expression printString).
	expressionChanged := testCase changeStatementOfVarName: '_var2'.
	self
		assert:
			(#('_var2 := 679.9.')
				includes: expressionChanged printString).
	self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFactoryMessageWithOneLiteral [
	| testCase expressionChanged |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf: #SFoo);
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3.'
									with: ('_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var0.')).
	expressionChanged := testCase changeStatementOfVarName: '_var1'.
	self
		assert: ((Array
									with: ('_var0 := ',(self fullNameOfClass: 'SFoo')asString,' new.')
									with: ('_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var2.'))
				includes: expressionChanged printString).
				self assert: testCase validReferences
]

{ #category : #'mutation-change' }
SChangeTest >> testChangeStatementOfFieldAccessMessage [
	| testCase exprField exprFieldChanged |
	testCase := SSTestCase with: utility typeInfoSStack4.
	testCase addTargetClassName: (self fullSymbolOf: #SStack);
	addFactoryMessage: (self fullSymbolOf: #SStack) ofSelector: #newStack.
	exprField := (testCase
		addFieldAccessMessage: #firstLinkStack
		from: (self fullSymbolOf: #SStack)) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: ('_var0 := ',(self fullNameOfClass: 'SStack')asString,' newStack.')
									with: '_var1 := _var0 firstLinkStack.').
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
	testCase := SSTestCase with: utility typeInfoSStack4.
	exprLiteral := (testCase addLiteral: (self fullSymbolOf: #SmallInteger)) copy.
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
	testCase := SSTestCase with: utility typeInfoSStack4.
	testCase addTargetClassName: (self fullSymbolOf: #SStack);
	addFactoryMessage: (self fullSymbolOf: #SStack) ofSelector: #newStack.
	exprMessage := (testCase addMessage: #pop from: (self fullSymbolOf: #SStack)) copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: ('_var0 := ',(self fullNameOfClass: 'SStack')asString,' newStack.')
									with: '_var1 := _var0 pop.').
	exprLiteralChanged := testCase changeStatement: exprMessage.
	self
		assert:
			(#('_var1 := _var0 top.' '_var1 := _var0 push: _var2.' '_var1 := _var3 pop.' '_var1 := _var2 pop.')
				includes: exprLiteralChanged printString).
	self assert: testCase validReferences
]
