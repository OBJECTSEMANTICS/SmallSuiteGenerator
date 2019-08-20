Class {
	#name : #SInspectorAssertionTest,
	#superclass : #SUnitTestCase,
	#category : #'SmallSuiteGenerator-Tests-Assertion'
}

{ #category : #tests }
SInspectorAssertionTest >> testPrintString [
	| assertions result possibleResults typeInfo testCase |
	assertions := SInspectorAssertion
		applyOn: 'foo'
		with: SFoo new
		of: nil.
	self assert: assertions isEmpty.
	typeInfo  := SUtilityTypeInfo new typeInfosSFoo third.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase addMessage.
	assertions := SInspectorAssertion
		applyOn: 'foo'
		with: SFoo new
		of: testCase.
	result := assertions first printString.
	possibleResults := OrderedCollection new
		add: 'self assert: foo returnNum equals: 4';
		add: 'self assert: foo returnString equals: ''Hello''';
		add: 'self assert: foo returnFloat equals: 2.3';
		add: 'self assert: foo score equals: 0';
		yourself.
	self assert: (possibleResults includes: result)
]
