Class {
	#name : #SPrimitiveAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #tests }
SPrimitiveAssertionTest >> testPrintString [ 
	| assertions |
	assertions := SPrimitiveAssertion applyOn: 'name' with: 'hello world'.
	self assert: assertions first printString equals: 'self assert: name equals: ''hello world'''.
		
	assertions := SPrimitiveAssertion applyOn: 'number' with: 1.
	self assert: assertions first printString equals: 'self assert: number equals: 1'.
	
	assertions := SPrimitiveAssertion applyOn: 'float' with: 23.56.
	self assert: assertions first printString equals: 'self assert: float equals: 23.56'.
	
	assertions := SPrimitiveAssertion applyOn: 'bool' with: true.
	self assert: assertions first printString equals: 'self assert: bool equals: true'.
	
	assertions := SPrimitiveAssertion applyOn: 'array' with: #().
	self assert: assertions first printString equals: 'self assert: array equals: #()'.
]

{ #category : #tests }
SPrimitiveAssertionTest >> testPrintStringNoLiterals [
	| assertions |
	assertions := SPrimitiveAssertion applyOn: 'coll' with: OrderedCollection new.
	self assert: assertions isEmpty.
		
	assertions := SPrimitiveAssertion applyOn: 'stack' with: Stack new.
	self assert: assertions isEmpty.
	
	assertions := SPrimitiveAssertion applyOn: 'dict' with: Dictionary new.
	self assert: assertions isEmpty.
	
	assertions := SPrimitiveAssertion applyOn: 'sstudent' with: SStudent new.
	self assert: assertions isEmpty.
]
