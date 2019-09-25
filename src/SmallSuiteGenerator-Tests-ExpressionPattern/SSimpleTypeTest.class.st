Class {
	#name : #SSimpleTypeTest,
	#superclass : #SExpressionPatternTest,
	#category : #'SmallSuiteGenerator-Tests-ExpressionPattern'
}

{ #category : #running }
SSimpleTypeTest >> setUp [ 
	"expressionPattern := SSimpleType."
]

{ #category : #tests }
SSimpleTypeTest >> testAddExpression [
	"self
		assert:
			(expressionPattern
				addExpression: (SSTestCase with: utility typeInfoSimpletype)).
	self
		shouldnt: [ expressionPattern
				addExpression: (SSTestCase with: utility typeInfoSimpletype) ]
		raise: SError.
	self
		should: [ expressionPattern
				addExpression: (SSTestCase with: utility typeInfoBlockClosureSymbol) ]
		raise: SError"
]

{ #category : #tests }
SSimpleTypeTest >> testCanMatchPattern [
	"self
		assert: (expressionPattern canMatchPattern: utility typeInfoSimpletype).
	self
		deny:
			(expressionPattern canMatchPattern: utility typeInfoBlockClosureSymbol)"
]
