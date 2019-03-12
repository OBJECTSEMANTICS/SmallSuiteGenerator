Class {
	#name : #SInspectorAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #tests }
SInspectorAssertionTest >> testPrintString [ 
	| assertions result possibleResults |
	assertions := SInspectorAssertion applyOn: 'student' with: SStudent new.
	result := assertions first printString.
	possibleResults := OrderedCollection new
	add: 'self assert: student returnNum equals: 4';
	add: 'self assert: student returnString equals: ''Hello''';
	add: 'self assert: student returnFloat equals: 2.3';
	yourself.
	self assert: (possibleResults includes: result).
]
