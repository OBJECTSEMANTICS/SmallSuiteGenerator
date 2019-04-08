Class {
	#name : #SCalculatorCoverageTest,
	#superclass : #TestCase,
	#instVars : [
		'calculatorCoverage'
	],
	#category : #'SmallSuiteGeneratorTest-Coverage'
}

{ #category : #running }
SCalculatorCoverageTest >> setUp [
	calculatorCoverage := SCalculatorCoverage new.
]

{ #category : #running }
SCalculatorCoverageTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil
]

{ #category : #tests }
SCalculatorCoverageTest >> testCalculateCoverage [
	| aBlock result originProfiler testCaseProfiler |
	aBlock := [ | aStack |
	aStack := SStack newStackWith: {2 . 4 . 6 . 1}.
	aStack push: 8.
	aStack pop.
	aStack top ].
	result := calculatorCoverage calculateCoverage: aBlock onClass: SStack.
	originProfiler := result first.
	testCaseProfiler := result second.
	self assert: (originProfiler at: 'noOfExecutedMethods') equals: 4.
	self
		assert: (testCaseProfiler at: 'noOfExecutedMethods') > 0.
	self assert: (originProfiler at: 'noAllStatements') equals: 19.
	self assert: (testCaseProfiler at: 'noAllStatements') > 0.
	self assert: (originProfiler at: 'noOfExecutedStatements') equals: 14.
	self assert: (testCaseProfiler at: 'noOfExecutedStatements') > 0.
]

{ #category : #tests }
SCalculatorCoverageTest >> testCalculateCoverageRTAMItem [
	| listTestCase coverage |
	listTestCase := STestCaseTest listTestCaseRTAMItem.
	coverage := listTestCase first coverageOnClass: RTAMItem.
	self assert: (coverage at: 'noOfExecutedMethods') equals: 3.
	self assert: (coverage at: 'noOfExecutedStatements') equals: 8.
	self assert: (coverage at: 'noAllMethods') equals: 14.
	self assert: (coverage at: 'noAllStatements') equals: 19.
]
