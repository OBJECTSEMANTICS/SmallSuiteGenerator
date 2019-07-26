Class {
	#name : #SInvariantsInRoassal,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #tests }
SInvariantsInRoassal >> testPrintStringRTLineSegment [
	| assertions typeInfo testCase |
	typeInfo := SUtilityRoassal new typeInfosRTLineSegment second.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage .
	testCase addMessage.
	assertions := SInspectorAssertion
		applyOn: 'rtLine'
		with: (RTLineSegment from: 4 @ 9 to: 5 @ 18)
		of: testCase.
	self assert: assertions first printString isNotEmpty
]
