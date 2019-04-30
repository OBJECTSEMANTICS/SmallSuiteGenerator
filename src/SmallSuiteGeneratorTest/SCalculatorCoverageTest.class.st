Class {
	#name : #SCalculatorCoverageTest,
	#superclass : #TestCase,
	#instVars : [
		'calculatorCoverage'
	],
	#category : #'SmallSuiteGeneratorTest-Coverage'
}

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> assertCoverage: aBlock onClass: aClass withValues: coverages [
	| result originProfiler testSuiteProfiler |
	result := calculatorCoverage
		calculateCoverage: aBlock
		onClass: aClass
		inTestSuiteOfSize: 20.
	originProfiler := result first.
	testSuiteProfiler := result allButFirst.
	self assert: testSuiteProfiler isNotEmpty.
	self
		assert: (originProfiler at: 'methodCoverage')
		equals: coverages first.
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'methodCoverage') >= coverages first ])
				isNotEmpty.
	self
		assert: (originProfiler at: 'statementCoverage')
		equals: coverages second.
	self
		assert:
			(testSuiteProfiler
				select: [ :dict | (dict at: 'statementCoverage') >= coverages second ])
				isNotEmpty
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> assertCoverage: aBlock onPackages: regex [
	| result coverageOfOrigin coverageTestSuite |
	result := calculatorCoverage
		calculateCoverage: aBlock
		onPackagesMatching: regex
		inTestSuiteOfSize: 20.
	coverageOfOrigin := result first.
	coverageTestSuite := result allButFirst.
	self assert: coverageTestSuite isNotEmpty.
	self
		assert:
			(coverageTestSuite collect: [ :dict | dict at: 'methodCoverage' ]) max
				>= (coverageOfOrigin at: 'methodCoverage').
	self
		assert:
			(coverageTestSuite collect: [ :dict | dict at: 'statementCoverage' ])
				max >= (coverageOfOrigin at: 'statementCoverage')
]

{ #category : #running }
SCalculatorCoverageTest >> setUp [
	calculatorCoverage := SCalculatorCoverage new.
]

{ #category : #running }
SCalculatorCoverageTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassRTAMItem [
	| aBlock |
	aBlock := [ RTAMItem basicNew
		itemName: 'Bonus Card';
		row: 'France';
		column: 'Customer Relationship';
		color: Color lightGreen ].
	"28.57 = (4/14) * 100"
	"21.05 = (4/19) * 100"
	self
		assertCoverage: aBlock
		onClass: RTAMItem
		withValues: {28.57 . 21.05}
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassRTBorderAttachPoint [
	"25 = (2/8) * 100 round: 2"
	"9.68 = (3/31) * 100 round: 2"
	self
		assertCoverage: [ RTBorderAttachPoint new offset: 4 ]
		onClass: RTBorderAttachPoint
		withValues: {25 . 9.68}
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassRTBox [
	"20 = (1/5) * 100 round: 2"

	"(2/9) * 100 round: 2"

	self
		assertCoverage: [ RTBox new
				defaultWidth;
				borderStyle ]
		onClass: RTBox
		withValues: {20 . 22.22}
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassRTDirectedLine [
	"60 = (3/5) * 100 round: 2"

	"54.55 = (6/11) * 100 round: 2"

	self
		assertCoverage: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		onClass: RTDirectedLine
		withValues: {60 . 54.55}
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassRTLineSegment [
	"23.53 = (8/34) * 100 round: 2"

	"13.46 = (14/104) * 100 round: 2"

	self
		assertCoverage: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
						angleInDeg;
						angleInRad;
						cotan;
						bottom ]
		onClass: RTLineSegment
		withValues: {23.53 . 13.46}
]

{ #category : #'coverage-onClass' }
SCalculatorCoverageTest >> testCoverageClassSStack [
	"57.14 = (4/7) * 100 round: 2"
	"73.68 = (14/19) * 100 round: 2"
	self
		assertCoverage: [ | aStack |
			aStack := SStack newStackWith: {2 . 4 . 6 . 1}.
			aStack push: 8.
			aStack pop.
			aStack top ]
		onClass: SStack
		withValues: {57.14 . 73.68}
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesRTAMItem [
	self
		assertCoverage: [ RTAMItem new
				itemName: 'Bonus Card';
				color: Color lightCyan ]
		onPackages: 'Roassal2'
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesRTAMItemSimpleInstruction [
	self assertCoverage: [ RTAMItem basicNew ] onPackages: 'Roassal2'.
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesRTBorderAttachPoint [
	self
		assertCoverage: [ RTBorderAttachPoint new offset: 4 ]
		onPackages: 'Roassal2-Cor*'
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesRTBox [
	self
		assertCoverage: [RTBox new
				defaultWidth;
				borderStyle  ]
		onPackages: 'Roassal2-Cor*'
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesRTDirectedLine [
	self
		assertCoverage: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		onPackages: 'Roassal2-Cor*'
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesRTLineSegment [
	self
		assertCoverage: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		onPackages: 'Roassal2-Cor*'
]

{ #category : #'coverage-onPackages' }
SCalculatorCoverageTest >> testCoverageOnPackagesSStack [
	self assertCoverage: [ (SStack newStackWith: {2 . 4 . 6 . 1})
		push: 8;
		pop;
		top ] onPackages: 'SmallSuiteExamp*'.
]
