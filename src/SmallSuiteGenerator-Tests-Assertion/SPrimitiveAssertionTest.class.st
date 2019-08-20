Class {
	#name : #SPrimitiveAssertionTest,
	#superclass : #SUnitTestCase,
	#category : #'SmallSuiteGenerator-Tests-Assertion'
}

{ #category : #tests }
SPrimitiveAssertionTest >> testPrintString [
	| assertions |
	assertions := SPrimitiveAssertion applyOn: 'name' with: 'hello world' of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: name equals: ''hello world'''.
	assertions := SPrimitiveAssertion applyOn: 'number' with: 1 of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: number equals: 1'.
	assertions := SPrimitiveAssertion applyOn: 'float' with: 23.56 of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: float equals: 23.56'.
	assertions := SPrimitiveAssertion applyOn: 'bool' with: true of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: bool equals: true'.
	assertions := SPrimitiveAssertion applyOn: 'array' with: #() of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: array equals: #()'
]

{ #category : #tests }
SPrimitiveAssertionTest >> testPrintStringNoLiterals [
	| assertions |
	assertions := SPrimitiveAssertion
		applyOn: 'coll'
		with: OrderedCollection new
		of: nil.
	self assert: assertions isEmpty.
	assertions := SPrimitiveAssertion
		applyOn: 'stack'
		with: Stack new
		of: nil.
	self assert: assertions isEmpty.
	assertions := SPrimitiveAssertion
		applyOn: 'dict'
		with: Dictionary new of: nil.
	self assert: assertions isEmpty.
	assertions := SPrimitiveAssertion
		applyOn: 'foo'
		with: SFoo new
		of: nil.
	self assert: assertions isEmpty
]
