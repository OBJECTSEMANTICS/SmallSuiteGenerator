Class {
	#name : #SInspectorAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #tests }
SInspectorAssertionTest >> testPrintString [
	| assertions result possibleResults |
	assertions := SInspectorAssertion applyOn: 'foo' with: SFoo new.
	result := assertions first printString.
	possibleResults := OrderedCollection new
		add: 'self assert: foo returnNum equals: 4';
		add: 'self assert: foo returnString equals: ''Hello''';
		add: 'self assert: foo returnFloat equals: 2.3';
		yourself.
	self assert: (possibleResults includes: result)
]
