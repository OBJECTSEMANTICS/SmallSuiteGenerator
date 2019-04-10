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

{ #category : #'coverage-onClass' }
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

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCalculateCoverageOnPackagesMatching [
	| aBlock result originProfiler testSuiteProfiler |
	aBlock := [ RTAMItem basicNew
		itemName: 'Bonus Card';
		row: 'France';
		column: 'Customer Relationship';
		color: Color lightGreen ].
	result := calculatorCoverage
		calculateCoverage: aBlock
		onPackagesMatching: 'Roassal2'
		inTestSuiteOfSize: 20.
	originProfiler := result first.
	testSuiteProfiler := result allButFirst.
	self assert: testSuiteProfiler isNotEmpty.
	self assert: (originProfiler at: 'methodCoverage') equals: 28.57.	"(4/14) * 100 round: 2"
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'methodCoverage') >= 28.57 ])
				isNotEmpty.
	self assert: (originProfiler at: 'statementCoverage') equals: 21.05.	"(4/19) * 100 round: 2"
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'statementCoverage') >= 21.05 ])
				isNotEmpty
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCalculateCoverageOnPackagesMatchingSimple [
	| aBlock result originProfiler testSuiteProfiler |
	aBlock := [ RTAMItem basicNew ].
	result := calculatorCoverage
		calculateCoverage: aBlock
		onPackagesMatching: 'Roassal2'
		inTestSuiteOfSize: 20.
	originProfiler := result first.
	testSuiteProfiler := result allButFirst.
	self assert: testSuiteProfiler isNotEmpty.
	self assert: (originProfiler at: 'methodCoverage') equals: 1.22.	"(56/4607) * 100 round: 2"
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'methodCoverage') >= 1.22 ])
				isNotEmpty.
	self assert: (originProfiler at: 'statementCoverage') equals: 0.31.	"(60/19108) * 100 round: 2"
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'statementCoverage') >= 0.31 ])
				isNotEmpty
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCalculateCoverageRTAMItem [
	| listTestCase coverage |
	listTestCase := STestCaseTest listTestCaseRTAMItem.
	coverage := listTestCase first coverageOnClass: RTAMItem.
	self assert: (coverage at: 'noOfExecutedMethods') equals: 3.
	self assert: (coverage at: 'noOfExecutedStatements') equals: 8.
	self assert: (coverage at: 'noAllMethods') equals: 14.
	self assert: (coverage at: 'noAllStatements') equals: 19.
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCalculateCoverageTestSuiteRTAMItem [
	| aBlock result originProfiler testSuiteProfiler |
	aBlock := [ RTAMItem basicNew
		itemName: 'Bonus Card';
		row: 'France';
		column: 'Customer Relationship';
		color: Color lightGreen ].
	result := calculatorCoverage
		calculateCoverage: aBlock
		onClass: RTAMItem
		inTestSuiteOfSize: 20.
	originProfiler := result first.
	testSuiteProfiler := result allButFirst.
	self assert: testSuiteProfiler isNotEmpty.
	self assert: (originProfiler at: 'methodCoverage') equals: 28.57.	"(4/14) * 100 round: 2"
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'methodCoverage') >= 28.57 ])
				isNotEmpty.
	self assert: (originProfiler at: 'statementCoverage') equals: 21.05.	"(4/19) * 100 round: 2"
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'statementCoverage') >= 21.05 ])
				isNotEmpty
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCalculateCoverageTestSuiteSStack [
	| aBlock result originProfiler testSuiteProfiler |
	aBlock := [ | aStack |
	aStack := SStack newStackWith: {2 . 4 . 6 . 1}.
	aStack push: 8.
	aStack pop.
	aStack top ].
	result := calculatorCoverage
		calculateCoverage: aBlock
		onClass: SStack
		inTestSuiteOfSize: 20.
	originProfiler := result first.
	testSuiteProfiler := result allButFirst.
	self assert: testSuiteProfiler isNotEmpty.
	self assert: (originProfiler at: 'methodCoverage') equals: 57.14.	"(4/7) * 100 round: 2"
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'methodCoverage') >= 57.14 ])
				isNotEmpty.
	self assert: (originProfiler at: 'statementCoverage') equals: 73.68.	"(14/19) * 100 round: 2"
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'statementCoverage') >= 73.68 ])
				isNotEmpty
]
