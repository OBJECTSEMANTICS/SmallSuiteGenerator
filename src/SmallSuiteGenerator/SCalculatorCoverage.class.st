Class {
	#name : #SCalculatorCoverage,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> calculateCoverage: aBlock [
	| originProfiler testCaseProfiler testCase1 testCase2 offSprings offSpring1Profiler offSpring2Profiler |
	originProfiler := SBProfiler
		profile: aBlock
		onPackagesMatching: 'SmallSuiteExam*'.
	testCaseProfiler := SSGenerator profile: aBlock onClass: SStack.
	testCase1 := STestCase seed: testCaseProfiler.
	testCase1 generateStatements.
	testCase2 := STestCase seed: testCaseProfiler.
	testCase2 generateStatements.
	offSprings := testCase1 crossOverWith: testCase2.
	offSpring1Profiler := self compileTestCase: offSprings first.
	offSpring2Profiler := self compileTestCase: offSprings second.
	
]
