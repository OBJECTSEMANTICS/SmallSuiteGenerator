Class {
	#name : #SCalculatorCoverageTestWithRoassal,
	#superclass : #TestCase,
	#instVars : [
		'calculatorTest'
	],
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #running }
SCalculatorCoverageTestWithRoassal >> setUp [ 
	calculatorTest := SCalculatorCoverageTest new
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageClassRTAMItem [
	| aBlock |
	aBlock := [ RTAMItem basicNew
		itemName: 'Bonus Card';
		row: 'France';
		column: 'Customer Relationship';
		color: Color lightGreen ].
	"28.57 = (4/14) * 100"
	"21.05 = (4/19) * 100"
	calculatorTest 
		assertCoverageB: aBlock
		onClass: RTAMItem
		withValues: {28.57 . 21.05}
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageClassRTBorderAttachPoint [
	"25 = (2/8) * 100 round: 2"

	"9.68 = (3/31) * 100 round: 2"

	calculatorTest 
		assertCoverageB: [ RTBorderAttachPoint new offset: 4 ]
		onClass: RTBorderAttachPoint
		withValues: {25 . 9.68}
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageClassRTBox [
	"20 = (1/5) * 100 round: 2"

	"(2/9) * 100 round: 2"

	calculatorTest 
		assertCoverageB: [ RTBox new
				defaultWidth;
				borderStyle ]
		onClass: RTBox
		withValues: {20 . 22.22}
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageClassRTDirectedLine [
	"60 = (3/5) * 100 round: 2"

	"54.55 = (6/11) * 100 round: 2"

	calculatorTest 
		assertCoverageB: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		onClass: RTDirectedLine
		withValues: {60 . 54.55}
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageClassRTLineSegment [
	"23.53 = (8/34) * 100 round: 2"

	"13.46 = (14/104) * 100 round: 2"

	calculatorTest 
		assertCoverageB: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		onClass: RTLineSegment
		withValues: {23.53 . 13.46}
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageOnPackagesRTAMItem [
	calculatorTest 
		assertCoverageOfTestSuite: [ RTAMItem new
				itemName: 'Bonus Card';
				color: Color lightCyan ]
		onPackages: 'Roassal2'
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageOnPackagesRTAMItemSimpleInstruction [
	calculatorTest 
		assertCoverageOfTestSuite: [ RTAMItem basicNew ]
		onPackages: 'Roassal2'
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageOnPackagesRTBorderAttachPoint [
	calculatorTest 
		assertCoverageOfTestSuite: [ RTBorderAttachPoint new offset: 4 ]
		onPackages: 'Roassal2-Cor*'
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageOnPackagesRTDirectedLine [
	calculatorTest 
		assertCoverageOfTestSuite: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		onPackages: 'Roassal2-Cor*'
]

{ #category : #tests }
SCalculatorCoverageTestWithRoassal >> testCoverageOnPackagesRTLineSegment [
	calculatorTest 
		assertCoverageOfTestSuite: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		onPackages: 'Roassal2-Cor*'
]
