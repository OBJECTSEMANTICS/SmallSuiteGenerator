Class {
	#name : #SAssertionTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SAssertionTest >> testAssertComparison [
	| test |
	test := SSTestCase new.
	test
		addStatements:
			(self
				parse:
					'_var0 := 1.
			 _var1 := 1.
			 _var2 := Point x: _var0 y: _var1.
			 _var3 := Point x: _var1 y: _var0.').
	test generateAssertions: (Array with: SComparisonAssertion).
	self assert: test assertions size equals: 2.
	self
		assert: test assertions first printString
		equals: 'self assert: _var0 equals: _var1.'.
	self
		assert: test assertions second printString
		equals: 'self assert: _var2 equals: _var3.'
]

{ #category : #tests }
SAssertionTest >> testAssertComparison2 [
	| test |
	test := SSTestCase new.
	test
		addStatements:
			(self
				parse:
					'_var0 := 1.
			 _var1 := 2.
			 _var2 := Point x: _var0 y: _var1.
			 _var3 := Point x: _var1 y: _var0.').
	test generateAssertions: (Array with: SComparisonAssertion).
	self assert: test assertions size equals: 2.
	self
		assert: test assertions first printString
		equals: 'self deny: _var0 equals: _var1.'.
	self
		assert: test assertions second printString
		equals: 'self deny: _var2 equals: _var3.'
]

{ #category : #tests }
SAssertionTest >> testAssertInspector [
	| test |
	test := SSTestCase new.
	test
		addStatements:
			(self
				parse:
					'_var0 := 1.
			 _var1 := 2.
			 _var3 := Point x: _var1 y: _var0.').
	test generateAssertions: (Array with: SInspectorAssertion).
	self assert: test assertions size equals: 2.
	self
		assert: test assertions first printString
		equals: 'self assert: _var3 x equals: 2.'.
	self
		assert: test assertions second printString
		equals: 'self assert: _var3 y equals: 1.'
]

{ #category : #tests }
SAssertionTest >> testAssertPrimitive [
	| test |
	test := SSTestCase new.
	test
		addStatements:
			(self
				parse:
					'_var0 := 1.
			 _var1 := 2.
			 _var3 := Point x: _var1 y: _var0.').
	test generateAssertions: (Array with: SPrimitiveAssertion).
	self assert: test assertions size equals: 2.
	self
		assert: test assertions first printString
		equals: 'self assert: _var0 equals: 1.'.
	self
		assert: test assertions second printString
		equals: 'self assert: _var1 equals: 2.'
]

{ #category : #tests }
SAssertionTest >> testAssertString [
	| test |
	test := SSTestCase new.
	test
		addStatements:
			(self
				parse:
					'_var0 := 1.
			 _var1 := 2.
			 _var3 := Point x: _var1 y: _var0.').
	test generateAssertions: (Array with: SStringAssertion).
	self assert: test assertions size equals: 1.
	self
		assert: test assertions first printString
		equals: 'self assert: _var3 printString equals: ''(2@1)''.'
]

{ #category : #tests }
SAssertionTest >> testExecutionContext [
	|test context|
	test := SSTestCase new.
	test addStatements: (self parse:
			'_var0 := 1.
			 _var1 := 2.
			 _var2 := Point x: _var0 y: _var1.').
	context := test analyze.
	self assert: (context at:'_var0') equals: 1.
	self assert: (context at:'_var1') equals: 2.
	self assert: (context at:'_var2') equals: (1@2).
]
