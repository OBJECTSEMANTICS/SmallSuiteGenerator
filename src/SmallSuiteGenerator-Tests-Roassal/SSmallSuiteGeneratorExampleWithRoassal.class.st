Class {
	#name : #SSmallSuiteGeneratorExampleWithRoassal,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTAMItemOnClass [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ RTAMItem new
		itemName: 'Bonus Card';
		row: 'France';
		column: 'Customer Relationship';
		color: Color lightGreen ].
	class := RTAMItem.
	"smallSuiteGenerator generateTestsOf: block blockOnClass: class."
	smallSuiteGenerator
		generateTestsFrom: block
		blockOn: class
		classMutating: {SSAssertionGeneratorTest}
		testCasesUsing: {}
		operatorsAnd: AllTestsMethodsRunningMutantEvaluationStrategy new.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
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
		color: Color lightGreen ].
	regex := 'Roassal2'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTBorderAttachPointOnClass [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ RTBorderAttachPoint instance offset: -4.12 ].
	class := RTBorderAttachPoint.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
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
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ RTBox new
		defaultWidth;
		borderStyle ].
	class := RTBox.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTDirectedLineOnClass [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ RTDirectedLine instance
		pointsFrom: 1 @ 3 To: 3 @ 5;
		offset: 6.5 ].
	class := RTDirectedLine.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTDirectedLineOnPackages [
	| smallSuiteGenerator block regex invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
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
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTLineSegmentOnClass [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
		angleInDeg;
		angleInRad;
		cotan;
		bottom ].
	class := RTLineSegment.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
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
