Class {
	#name : #SCalculatorCoverageTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Fitness'
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
	testSuite := self
		testSuite: typeInfo
		ofSize: 20.
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
SCalculatorCoverageTest >> testCoverageClassSEvent [
	"83.33 = (5/6) * 100 round: 2
	75.0 = (6/8) * 100 round: 2"

	self
		assertCoverageB: [ (SEvent price: 15)
				price;
				discount ]
		onClass: SEvent
		withValues: {83.33 . 75.0}
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassSFoo [
	"77.78 = (7/9) * 100 round: 2
	71.43 = (10/14) * 100 round: 2"

	self
		assertCoverageB: [ (SFoo score: 15)
				returnCollection;
				returnFloat;
				score;
				return: #(1 5 6) ]
		onClass: SFoo
		withValues: {77.78 . 71.43}
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassSSTeacher [
	"60 = (3/5) * 100 round: 2
	75.0 = (6/8) * 100 round: 2"

	self
		assertCoverageB: [ SSTeacher new 
			nickname;
			yearsWorkExperience ]
		onClass: SSTeacher
		withValues: {60.0. 75.0}
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

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassSStudent [
	"80.00 = (4/5) * 100 round: 2
	70.50 = (6/8) * 100 round: 2"

	self
		assertCoverageB: [ SStudent new
				idStudent;
				scoreStudent: 10;
				scoreStudent ]
		onClass: SStudent
		withValues: {80.0 . 75}
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesSEvent [
	self
		assertCoverageOfTestSuite: [ (SEvent price: 15)
				price;
				discount ]
		onPackages: 'SmallSuiteGenerator-Examples'
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesSFoo [
	self
		assertCoverageOfTestSuite: [ (SFoo score: 15)
				returnCollection;
				returnFloat;
				score;
				return: #(1 5 6) ]
		onPackages: 'SmallSuiteGenerator-Examples'
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesSSTeacher [
	self
		assertCoverageOfTestSuite: [ SSTeacher new
				nickname;
				yearsWorkExperience ]
		onPackages: 'SmallSuiteGenerator-Examples'
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

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesSStudent [
	self
		assertCoverageOfTestSuite: [ SStudent new
				idStudent;
				scoreStudent: 10;
				scoreStudent ]
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
