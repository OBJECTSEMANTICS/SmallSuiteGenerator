Class {
	#name : #SInspectorAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #tests }
SInspectorAssertionTest >> testPrintString [
	| assertions result possibleResults profile testCase |
	assertions := SInspectorAssertion
		applyOn: 'foo'
		with: SFoo new
		of: nil.
	self assert: assertions isEmpty.
	profile := SSGenerator
		profile: [ (SFoo score: 4) returnNum; returnString; returnFloat; score ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
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

{ #category : #tests }
SInspectorAssertionTest >> testPrintStringRTLineSegment [
	| assertions profile testCase |
	profile := SSGenerator
		profile: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		onClass: RTLineSegment.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	assertions := SInspectorAssertion
		applyOn: 'rtLine'
		with: (RTLineSegment from: 4 @ 9 to: 5 @ 18)
		of: testCase.
	self assert: assertions first printString isNotEmpty
]
