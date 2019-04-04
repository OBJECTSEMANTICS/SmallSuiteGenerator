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

{ #category : #tests }
SCalculatorCoverageTest >> testCalculatorCoverage [
	| aBlock result originProfiler testCaseProfiler |
	aBlock := [ | aStack |
		aStack := SStack newStackWith: { 2. 4. 6. 1 }.
		aStack push: 8.
		aStack pop.
		aStack top.	
	].
	result := calculatorCoverage calculateCoverage: aBlock.
	originProfiler := result first.
	testCaseProfiler := result second.
	
	self assert: originProfiler numberOfExecutedMethods equals: 3.
	self assert: originProfiler numberOfExecutedMethods <= testCaseProfiler numberOfExecutedMethods.
	self assert: originProfiler numberOfAllStatements equals: 27.
	self assert: originProfiler numberOfExecutedStatements equals: 23.
	self assert: originProfiler numberOfExecutedStatements < testCaseProfiler numberOfExecutedStatements.
	self assert: originProfiler statementCoverage < testCaseProfiler statementCoverage.
	
	
	
	
]
