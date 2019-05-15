Class {
	#name : #SSmallSuiteGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'smallSuiteGenerator'
	],
	#category : #'SmallSuiteGeneratorTest-Facade'
}

{ #category : #running }
SSmallSuiteGeneratorTest >> setUp [
	super setUp.
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest
]

{ #category : #running }
SSmallSuiteGeneratorTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove.
	super tearDown 
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOf: block blockUsing: aClass classAnd: invariants [
	smallSuiteGenerator generateTestsOf: block blockOnClass: aClass.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateInvariants: invariants
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOf: block blockUsingPackagesMatching: regex regexAnd: invariants [
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateInvariants: invariants
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnClassRTAMItem [
	self
		testGenerateInvariantsOf: [ RTAMItem new
				itemName: 'Bonus[Card';
				row: 'F;ranceAmklsd-@sdf';
				column: 'Customer (R*elatio%$nship';
				color: Color lightGreen ]
		blockUsing: RTAMItem classAnd: {  }
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnClassRTBorderAttachPoint [
	self
		testGenerateInvariantsOf: [ RTBorderAttachPoint instance offset: -4.12 ]
		blockUsing: RTBorderAttachPoint classAnd: {  }
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnClassRTBox [
	self
		testGenerateInvariantsOf: [ RTBox new
				defaultWidth;
				borderStyle ]
		blockUsing: RTBox classAnd: {  }
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnClassRTDirectedLine [
	self
		testGenerateInvariantsOf: [ RTDirectedLine instance
				pointsFrom: -1 @ 3 To: 3 @ -5;
				offset: 6.512341234 ]
		blockUsing: RTDirectedLine classAnd: {  }
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnClassRTLineSegment [
	self
		testGenerateInvariantsOf: [ (RTLineSegment from: 4 @ -9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		blockUsing: RTLineSegment classAnd: {  }
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnClassSSTeacher [
	self
		testGenerateInvariantsOf: [ (SSTeacher name: 'Ann!' with: 3.233)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		blockUsing: SSTeacher classAnd: {  }
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnClassSStack [
	self
		testGenerateInvariantsOf: [ (SStack newStackWith: {'asdf' . 5 . 'efgh' . 2})
				pop;
				top;
				push: 4 ]
		blockUsing: SStack classAnd: {  }
]

{ #category : #'test-class invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnClassSStudent [
	self
		testGenerateInvariantsOf: [ (SStudent name: 'Ann' with: -34.234)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		blockUsing: SStudent classAnd: {  }
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnPackagesMatchingRTAMItem [
	self
		testGenerateInvariantsOf: [ RTAMItem new
				itemName: 'Bonus Card!)asd-';
				row: ':>France';
				column: 'Customer.Relationship?';
				color: Color transparent ]
		blockUsingPackagesMatching: 'Roassal2' regexAnd: {  }
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnPackagesMatchingRTBorderAttachPoint [
	self
		testGenerateInvariantsOf: [ RTBorderAttachPoint instance offset: 4 ]
		blockUsingPackagesMatching: 'Roassal2-Cor*' regexAnd: {  }
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnPackagesMatchingRTBox [
	self
		testGenerateInvariantsOf: [ RTBox new
				defaultWidth;
				borderStyle ]
		blockUsingPackagesMatching: 'Roassal2-Cor*' regexAnd: {  }
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnPackagesMatchingRTDLineSegment [
	self
		testGenerateInvariantsOf: [ (RTLineSegment from: -4.12 @ 9 to: 9.5 @ -18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		blockUsingPackagesMatching: 'Roassal2-Cor*' regexAnd: {  }
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnPackagesMatchingRTDirectedLine [
	self
		testGenerateInvariantsOf: [ RTDirectedLine instance
				pointsFrom: 1 @ -3 To: 3.312 @ -5;
				offset: 6.5 ]
		blockUsingPackagesMatching: 'Roassal2-Cor*' regexAnd: {  }
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnPackagesMatchingSSTeacher [
	self
		testGenerateInvariantsOf: [ (SSTeacher name: 'An*(n}' with: -312.12321)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		blockUsingPackagesMatching: 'SmallSuiteExamp*' regexAnd: {  }
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnPackagesMatchingSStack [
	self
		testGenerateInvariantsOf: [ (SStack
				newStackWith:
				{Color veryDarkGray.
			Color transparent.
			3.
			6.5.
			-8})
				pop;
				top;
				push: 4 ]
		blockUsingPackagesMatching: 'SmallSuiteExamp*' regexAnd: {  }
]

{ #category : #'test-packages invariants' }
SSmallSuiteGeneratorTest >> testGenerateInvariantsOnPackagesMatchingSStudent [
	self
		testGenerateInvariantsOf: [ (SStudent name: 'Ann@323' with: -34)
				nickname;
				idStudent;
				scoreStudent: -45.12;
				scoreStudent ]
		blockUsingPackagesMatching: 'SmallSuiteExamp*' regexAnd: {  }
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOf: block blockOnClass: class [
	self
		shouldnt: [ smallSuiteGenerator
				generateTestsOf: block
				blockOnClass: class ]
		raise: Error.
	self shouldnt: [ smallSuiteGenerator runGeneration ] raise: Error.
	self assert: smallSuiteGenerator engine logs isNotEmpty.
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOf: block blockOnPackagesMatching: regex [
	self
		shouldnt: [ smallSuiteGenerator
				generateTestsOf: block
				blockOnPackagesMatching: regex ]
		raise: Error.
	smallSuiteGenerator runGeneration.
	self assert: smallSuiteGenerator engine logs isNotEmpty
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassRTAMItem [
	self
		testGenerateTestsOf: [ RTAMItem new
				itemName: 'Bonus Card';
				row: 'France';
				column: 'Customer Relationship';
				color: Color lightGreen]
		blockOnClass: RTAMItem
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassRTBorderAttachPoint [
	self
		testGenerateTestsOf: [ RTBorderAttachPoint instance offset: 4 ]
		blockOnClass: RTBorderAttachPoint.
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassRTBox [
	self
		testGenerateTestsOf: [ RTBox new
				defaultWidth;
				borderStyle ]
		blockOnClass: RTBox
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassRTDirectedLine [
	self
		testGenerateTestsOf: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		blockOnClass: RTDirectedLine
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassRTLineSegment [
	self
		testGenerateTestsOf: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		blockOnClass: RTLineSegment
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassSSTeacher [
	self
		testGenerateTestsOf: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		blockOnClass: SSTeacher
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassSStack [
	self
		testGenerateTestsOf: [ (SStack newStackWith: {1 . 5 . 3 . 2})
				pop;
				top;
				push: 4 ]
		blockOnClass: SStack
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassSStudent [
	| aBlock |
	aBlock := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	self testGenerateTestsOf: aBlock blockOnClass: SStudent.
	"the engine has been previously run"
	self
		should: [ self testGenerateTestsOf: aBlock blockOnClass: SStudent ]
		raise: Exception.
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassWithAnotherClassToRun [
	"test with wrong class"
		| arrFitness |
	smallSuiteGenerator generateTestsOf: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ] blockOnClass: SFoo.
	smallSuiteGenerator runGeneration.
	arrFitness := smallSuiteGenerator engine logs collect: [ :log | log fittestTestCase fitness ].
	self assert: (arrFitness collect: [:fitness | fitness at: 'methodCoverage']) max equals: 11.11. "1 / 9"
	self assert: (arrFitness collect: [:fitness | fitness at: 'statementCoverage']) max equals: 7.14. "1 / 14"
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassWithAnotherSubclassToRun [
	"test with wrong class"
	| arrFitness |
	smallSuiteGenerator
		generateTestsOf: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		blockOnClass: SSTeacher.
	smallSuiteGenerator runGeneration.
	arrFitness := smallSuiteGenerator engine logs
		collect: [ :log | log fittestTestCase fitness ].
	self
		assert: (arrFitness collect: [ :fitness | fitness at: 'methodCoverage' ]) max
		equals: 20.	"1 / 5"
	self
		assert:
			(arrFitness collect: [ :fitness | fitness at: 'statementCoverage' ])
				max
		equals: 37.5 	"3 / 8"
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassWithEmptyBlock [
	"test with empty block"

	| arrFitness |
	smallSuiteGenerator generateTestsOf: [  ] blockOnClass: SStudent.
	smallSuiteGenerator runGeneration.
	arrFitness := smallSuiteGenerator engine logs
		collect: [ :log | log fittestTestCase fitness ].
	self
		assert: (arrFitness collect: [ :fitness | fitness at: 'methodCoverage' ]) max
		equals: 20.	"1 / 5"
	self
		assert:
			(arrFitness collect: [ :fitness | fitness at: 'statementCoverage' ])
				max
		equals: 37.5	"1 / 8"
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassWithNilBlock [
	self
		should: [ self testGenerateTestsOf: nil blockOnClass: SStudent ]
		raise: Exception.
]

{ #category : #'tests-class' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassWithNilClass [
	self
		should: [ self
				testGenerateTestsOf: [ (SStudent name: 'Ann' with: 34) nickname ]
				blockOnClass: nil ]
		raise: Exception
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingRTAMItem [
	"test with another class"

	self
		testGenerateTestsOf: [ RTAMItem new
				itemName: 'Bonus Card';
				row: 'France';
				column: 'Customer Relationship';
				color: Color lightGreen ]
		blockOnPackagesMatching: 'Roassal2'
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingRTBorderAttachPoint [
	"test with another class"

	self
		testGenerateTestsOf: [ RTBorderAttachPoint instance offset: 4 ]
		blockOnPackagesMatching: 'Roassal2-Cor*'
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingRTBox [
	"test with another class"

	self
		testGenerateTestsOf: [ RTBox new
				defaultWidth;
				borderStyle ]
		blockOnPackagesMatching: 'Roassal2-Cor*'
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingRTDirectedLine [
	"test with another class"
	self testGenerateTestsOf: [ RTDirectedLine instance
						pointsFrom: 1 @ 3 To: 3 @ 5;
						offset: 6.5 ] blockOnPackagesMatching: 'Roassal2-Cor*'.
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingRTLineSegment [
	"test with another class"
	self testGenerateTestsOf: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
						angleInDeg;
						angleInRad;
						cotan;
						bottom ] blockOnPackagesMatching: 'Roassal2-Cor*'.
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingSSTeacher [
	"test with another class"

	self
		testGenerateTestsOf: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		blockOnPackagesMatching: 'SmallSuiteExamp*'
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingSStack [
	"test with another class"

	self
		testGenerateTestsOf: [ (SStack newStackWith: {1 . 5 . 3 . 2})
				pop;
				top;
				push: 4 ]
		blockOnPackagesMatching: 'SmallSuiteExamp*'
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingSStudent [

	| block |
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	self
		testGenerateTestsOf: block
		blockOnPackagesMatching: 'SmallSuiteExamp*'.
	self
		should: [ self
				testGenerateTestsOf: block
				blockOnPackagesMatching: 'SmallSuiteExamp*' ]
		raise: Exception
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingWithAnotherPackage [
	"test with another package. If the block does not match with the package, just is considered the package and the generator creates default constructors of classes of packages"

	self testGenerateTestsOf: [ (SStudent name: 'Ann' with: 34)
						nickname;
						idStudent ] blockOnPackagesMatching: 'Roassal2-Cor*'.
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingWithEmptyBlock [
	"test with empty block"
	self
		testGenerateTestsOf: [  ]
		blockOnPackagesMatching: 'SmallSuiteExamp*'.
	
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingWithInvalidRegex [
	"test with nil or empty regex"

	self
		should: [ self
				testGenerateTestsOf: [ (SStudent name: 'Ann' with: 34) nickname ]
				blockOnPackagesMatching: nil ]
		raise: Exception.
	self
		should: [ self
				testGenerateTestsOf: [ (SStudent name: 'Ann' with: 34) nickname ]
				blockOnPackagesMatching: '' ]
		raise: Exception
]

{ #category : #'test-packages' }
SSmallSuiteGeneratorTest >> testGenerateTestsOnPackagesMatchingWithNilBlock [
	"test with nil block"

	self
		should: [ self testGenerateTestsOf: nil blockOnPackagesMatching: 'SmallSuiteExamp*' ]
		raise: Exception
]
