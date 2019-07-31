Class {
	#name : #SCalculatorCoverageTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Coverage'
}

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> assertCoverageB: aBlock onClass: aClass withValues: coverages [
	| result coverageProfiler |
	coverageProfiler := SBProfiler new
		profileInstrumented: aBlock onClass: aClass;
		yourself.
	result := coverageProfiler dictCoverage.
	coverageProfiler cleanInstrumentation.
	self assert: (result at: 'methodCoverage') equals: coverages first.
	self assert: (result at: 'statementCoverage') equals: coverages second
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> assertCoverageOfTestSuite: aBlock onPackages: regex [
	| listCoverage coverageProfiler typeInfo testSuite coverageBlock |
	typeInfo := (SSGenerator profile: aBlock onPackagesMatching: regex)
		asTypeInfo.
	coverageProfiler := SBProfiler new
		profileInstrumented: aBlock onPackagesMatching: regex;
		yourself.
	coverageBlock := coverageProfiler dictCoverage.
	testSuite := self testSuite: typeInfo ofSize: 20.
	listCoverage := testSuite
		collect: [ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ].
	coverageProfiler cleanInstrumentation.
	self assert: listCoverage isNotEmpty.
	self
		assert:
			(listCoverage collect: [ :dict | dict at: 'methodCoverage' ]) max
				>= (coverageBlock at: 'methodCoverage').
	self
		assert:
			(listCoverage collect: [ :dict | dict at: 'statementCoverage' ]) max
				>= (coverageBlock at: 'statementCoverage')
]

{ #category : #running }
SCalculatorCoverageTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassSStack [
	"57.14 = (4/7) * 100 round: 2
	73.68 = (14/19) * 100 round: 2"

	self
		assertCoverageB: [ | aStack |
			aStack := SStack newStackWith: {2 . 4 . 6 . 1}.
			aStack push: 8.
			aStack pop.
			aStack top ]
		onClass: SStack
		withValues: {57.14 . 73.68}
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesSStack [
	self
		assertCoverageOfTestSuite: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		onPackages: 'SmallSuiteGenerator-Examples'
]

{ #category : #tests }
SCalculatorCoverageTest >> testSuite: aTypeInfo ofSize: aNumber [
	| collection |
	collection := OrderedCollection new.
	1 to: aNumber do: [ :index | 
		| testCase |
		testCase := SSTestCase with: aTypeInfo.
		testCase numMaxStatements: (10 to: 54) atRandom.
		testCase generateStatements.
		collection add: testCase ].
	^ collection
]
