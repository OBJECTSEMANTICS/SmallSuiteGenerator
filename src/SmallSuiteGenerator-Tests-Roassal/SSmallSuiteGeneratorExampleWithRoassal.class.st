Class {
	#name : #SSmallSuiteGeneratorExampleWithRoassal,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTAMItemOnClass [
	| smallSuiteGenerator block  invariants |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTAMItem new
		itemName: 'Bonus Card';
		row: 'France';
		column: 'Customer Relationship';
		color: Color lightGreen ].
	smallSuiteGenerator
		generateTestsOf: block
		blockOnClass: RTAMItem.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTAMItemOnPackages [
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ RTAMItem new
		itemName: 'Bonus Card';
		row: 'France';
		column: 'Customer Relationship';
		color: Color lightGreen;
		color ].
	regex := 'Roassal2'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: #()
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTBorderAttachPointOnClass [
	| smallSuiteGenerator block invariants  |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTBorderAttachPoint instance offset: -4.12 ].
	smallSuiteGenerator generateTestsOf: block blockOnClass: RTBorderAttachPoint.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTBorderAttachPointOnPackages [
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ RTBorderAttachPoint instance offset: 4 ].
	regex := 'Roassal2-Cor*'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTBoxOnClass [
	| smallSuiteGenerator block  invariants  |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTBox new
		defaultWidth;
		borderStyle ].
	smallSuiteGenerator generateTestsOf: block blockOnClass: RTBox.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTDirectedLineOnClass [
	| smallSuiteGenerator block  invariants  |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTDirectedLine instance
		pointsFrom: 1 @ 3 To: 3 @ 5;
		offset: 6.5 ].
	smallSuiteGenerator generateTestsOf: block blockOnClass: RTDirectedLine .
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTDirectedLineOnPackages [
	| smallSuiteGenerator block regex invariants |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTDirectedLine instance
		pointsFrom: 1 @ 3 To: 3 @ 5;
		offset: 6.5 ].
	regex := 'Roassal2-Cor*'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTLineSegmentOnClass [
	| smallSuiteGenerator block invariants  |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
		angleInDeg;
		angleInRad;
		cotan;
		bottom ].
	smallSuiteGenerator generateTestsOf: block blockOnClass: RTLineSegment .
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTLineSegmentOnPackages [
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
		angleInDeg;
		angleInRad;
		cotan;
		bottom ].
	regex := 'Roassal2-Cor*'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration
]
