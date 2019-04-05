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
	| aBlock result originProfiler offSpring1Profiler offSpring2Profiler noExecMethods noExecStmts |
	aBlock := [ | aStack |
	aStack := SStack newStackWith: {2 . 4 . 6 . 1}.
	aStack push: 8.
	aStack pop.
	aStack top ].
	result := calculatorCoverage calculateCoverage: aBlock.
	originProfiler := result first.
	offSpring1Profiler := result second.
	offSpring2Profiler := result third.
	noExecMethods := originProfiler at: 'noOfExecutedMethods'.
	self assert: noExecMethods equals: 4.
	self
		assert:
			(noExecMethods <= (offSpring1Profiler at: 'noOfExecutedMethods')
				or: [ noExecMethods <= (offSpring2Profiler at: 'noOfExecutedMethods') ]).
	self assert: (originProfiler at: 'noAllStatements') equals: 19.
	noExecStmts := originProfiler at: 'noOfExecutedStatements'.
	self assert: noExecStmts equals: 14.
	self
		assert:
			(noExecStmts < (offSpring1Profiler at: 'noOfExecutedStatements')
				or: [ noExecStmts <= (offSpring2Profiler at: 'noOfExecutedStatements') ]).
	self
		assert:
			((originProfiler at: 'statementCoverage')
				<= (offSpring1Profiler at: 'statementCoverage')
				or: [ (originProfiler at: 'statementCoverage')
						<= (offSpring2Profiler at: 'statementCoverage') ])
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
