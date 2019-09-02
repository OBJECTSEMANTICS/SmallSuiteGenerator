Class {
	#name : #SSmallSuiteGeneratorExampleWithRoassal,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTAMItemOnClass [
	| smallSuiteGenerator block invariants aClass funcFitness |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTAMItem new
		itemName: 'Bonus Card';
		row: 'France';
		column: 'Customer Relationship';
		color: Color lightGreen ].
	aClass := RTAMItem.
	smallSuiteGenerator generateTestsOf: block blockOnClass: aClass.
	funcFitness := SMethodCoverage coverageOf: block onClass: aClass.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTAMItemOnPackages [
	| smallSuiteGenerator block regex funcFitness |
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
	funcFitness := SStatementCoverage.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: #()
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTBorderAttachPointOnClass [
	| smallSuiteGenerator block invariants aClass funcFitness |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTBorderAttachPoint instance offset: -4.12 ].
	aClass := RTBorderAttachPoint.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnClass: aClass.
	funcFitness := SStatementCoverage coverageOf: block onClass: aClass.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTBorderAttachPointOnPackages [
	| smallSuiteGenerator block regex funcFitness |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ RTBorderAttachPoint instance offset: 4 ].
	regex := 'Roassal2-Cor*'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex.
	funcFitness :=  SStatementCoverage.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator runGeneration
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTBoxOnClass [
	| smallSuiteGenerator block invariants aClass funcFitness |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTBox new
		defaultWidth;
		borderStyle ].
	aClass := RTBox.
	smallSuiteGenerator generateTestsOf: block blockOnClass: aClass.
	funcFitness := SMethodCoverage coverageOf: block onClass: aClass.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTDirectedLineOnClass [
	| smallSuiteGenerator block invariants functionFitness |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ RTDirectedLine instance
		pointsFrom: 1 @ 3 To: 3 @ 5;
		offset: 6.5 ].
	smallSuiteGenerator
		generateTestsOf: block
		blockOnClass: RTDirectedLine.
	functionFitness := SMultiFitnessFunction.
	functionFitness
		addFitnessFunction: (SMethodCoverage coverageOf: block onClass: RTDirectedLine);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator fitness: functionFitness.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTDirectedLineOnPackages [
	| smallSuiteGenerator block regex invariants funcFitness|
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
	funcFitness := SMethodCoverage.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTLineSegmentOnClass [
	| smallSuiteGenerator block invariants funcFitness aClass |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
		angleInDeg;
		angleInRad;
		cotan;
		bottom ].
	aClass := RTLineSegment.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnClass: aClass.
	funcFitness := SStatementCoverage coverageOf: block onClass: aClass.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExampleWithRoassal >> exampleRTLineSegmentOnPackages [
	| smallSuiteGenerator block regex functionFitness |
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
	functionFitness := SMultiFitnessFunction.
	functionFitness
		addFitnessFunction: (SMethodCoverage coverageOf: block onPackagesMatching: regex);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator fitness: functionFitness.
	smallSuiteGenerator runGeneration
]
