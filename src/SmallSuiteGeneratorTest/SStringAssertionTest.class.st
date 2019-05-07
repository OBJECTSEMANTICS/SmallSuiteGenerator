Class {
	#name : #SStringAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #tests }
SStringAssertionTest >> testPrintString [
	| assertions |
	assertions := SStringAssertion applyOn: 'name' with: 'hello world' of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: name asString equals: ''hello world'''.
	assertions := SStringAssertion applyOn: 'number' with: 1 of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: number asString equals: ''1'''.
	assertions := SStringAssertion applyOn: 'string' with: '<asdf>!213$' of: nil.
	self
		assert: assertions first printString
		equals: ('self assert: string asString equals: ', '''<asdf>!213$''').
	assertions := SStringAssertion applyOn: 'float' with: 23.56 of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: float asString equals: ''23.56'''.
	assertions := SStringAssertion applyOn: 'bool' with: true of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: bool asString equals: ''true'''.
	assertions := SStringAssertion applyOn: 'array' with: #() of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: array asString equals: ''#()'''
]

{ #category : #tests }
SStringAssertionTest >> testPrintStringComplexObject [
	| assertions value |
	value := OrderedCollection new.
	assertions := SStringAssertion applyOn: 'var' with: value of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: var asString equals: ''' , value asString , ''''.
	value := Dictionary new.
	assertions := SStringAssertion applyOn: 'dict' with: value of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: dict asString equals: ''' , value asString , ''''.
	value := Stack new.
	assertions := SStringAssertion applyOn: 'stack' with: value of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: stack asString equals: ''' , value asString , ''''.
	value := OrderedCollection new
		add: 12;
		add: 34;
		add: -1;
		yourself.
	assertions := SStringAssertion applyOn: 'var' with: value of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: var asString equals: ''' , value asString , ''''.
	value := Dictionary new
		at: 1 put: 23;
		at: 2 put: 34;
		yourself.
	assertions := SStringAssertion applyOn: 'dict' with: value of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: dict asString equals: ''' , value asString , ''''.
	value := Stack new
		add: 3;
		add: 45;
		yourself.
	assertions := SStringAssertion applyOn: 'stack' with: value of: nil.
	self
		assert: assertions first printString
		equals: 'self assert: stack asString equals: ''' , value asString , ''''.
	value := Array with: 'abc' with: 'def' with: 'ghij'.
	assertions := SStringAssertion applyOn: 'array' with: value of: nil.
	self
		assert: assertions first printString
		equals:
			'self assert: array asString equals: ''#(''''abc'''' ''''def'''' ''''ghij'''')'''
]
