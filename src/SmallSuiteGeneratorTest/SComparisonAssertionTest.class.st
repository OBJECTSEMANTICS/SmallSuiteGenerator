Class {
	#name : #SComparisonAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #tests }
SComparisonAssertionTest >> testPrintString [ 
	| assertions |
	assertions := SComparisonAssertion applyOn: 'name' with: 'hello world'.
	self assert: assertions first printString equals: 'self assert: name equals: ''hello world'''.
		
	assertions := SComparisonAssertion applyOn: 'number' with: 1.
	self assert: assertions first printString equals: 'self assert: number equals: 1'.
	
	assertions := SComparisonAssertion applyOn: 'float' with: 23.56.
	self assert: assertions first printString equals: 'self assert: float equals: 23.56'.
	
	assertions := SComparisonAssertion applyOn: 'bool' with: true.
	self assert: assertions first printString equals: 'self assert: bool equals: true'.
	
	assertions := SComparisonAssertion applyOn: 'array' with: #().
	self assert: assertions first printString equals: 'self assert: array equals: #()'.
]
