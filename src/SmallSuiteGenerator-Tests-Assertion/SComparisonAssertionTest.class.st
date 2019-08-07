Class {
	#name : #SComparisonAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Assertion'
}

{ #category : #tests }
SComparisonAssertionTest >> testPrintString [
	| assertions |
	assertions := SComparisonAssertion
		applyOn: 'name'
		with: 'hello world'
		of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: name className equals: ''ByteString'''.
	assertions := SComparisonAssertion applyOn: 'number' with: 1 of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: number className equals: ''SmallInteger'''.
	assertions := SComparisonAssertion applyOn: 'float' with: 23.56 of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: float className equals: ''SmallFloat64'''.
	assertions := SComparisonAssertion applyOn: 'bool' with: true of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: bool className equals: ''True'''.
	assertions := SComparisonAssertion applyOn: 'array' with: #() of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: array className equals: ''Array'''
]
