Class {
	#name : #SSmallSuiteGeneratorExample,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Examples'
}

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleEmptyBlockOnPackages [	
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ ].
	regex := 'SmallSuiteExamp*'.
	smallSuiteGenerator
				generateTestsOf: block
				blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleRTAMItemOnClass [
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
	smallSuiteGenerator generateTestsFrom: block blockOn: class classMutating: { SSAssertionGeneratorTest } testCasesUsing: {  } operatorsAnd: AllTestsMethodsRunningMutantEvaluationStrategy new.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleRTAMItemOnPackages [	
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
	smallSuiteGenerator runGeneration.
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleRTBorderAttachPointOnClass [
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
SSmallSuiteGeneratorExample >> exampleRTBorderAttachPointOnPackages [	
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ RTBorderAttachPoint instance offset: 4 ].
	regex := 'Roassal2-Cor*'.
	smallSuiteGenerator
				generateTestsOf: block
				blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleRTBoxOnClass [
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

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleRTBoxOnPackages [	
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ RTBox new
				defaultWidth;
				borderStyle ].
	regex := 'Roassal2-Cor*'.
	smallSuiteGenerator
				generateTestsOf: block
				blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleRTDirectedLineOnClass [
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
SSmallSuiteGeneratorExample >> exampleRTDirectedLineOnPackages [
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
SSmallSuiteGeneratorExample >> exampleRTLineSegmentOnClass [
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
SSmallSuiteGeneratorExample >> exampleRTLineSegmentOnPackages [	
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
	smallSuiteGenerator runGeneration.
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnClass [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	class := SSTeacher.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnPackages [	
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ].
	regex := 'SmallSuiteExamp*'.
	smallSuiteGenerator
				generateTestsOf: block
				blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStackOnClass [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ (SStack newStackWith: {1 . 5 . 3 . 2})
		pop;
		top;
		push: 4 ].
	class := SStack.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSStackOnPackages [	
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ (SStack newStackWith: {1 . 5 . 3 . 2})
				pop;
				top;
				push: 4 ].
	regex := 'SmallSuiteExamp*'.
	smallSuiteGenerator
				generateTestsOf: block
				blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStudentOnClass [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	class := SStudent.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithSubclassToRun [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	class := SSTeacher.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithWrongClassToRun [
	| smallSuiteGenerator block class invariants kindsRefactoring |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	kindsRefactoring := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	class := SFoo.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator
		generateAssertionsUsing: invariants
		invariantsAndApplyPrettyCodeWith: kindsRefactoring
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleWithWrongRegexToRun [	
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ (SStudent name: 'Ann' with: 34)
						nickname;
						idStudent ].
	regex := 'Roassal2-Cor*'.
	smallSuiteGenerator
				generateTestsOf: block
				blockOnPackagesMatching: regex.
	smallSuiteGenerator runGeneration.
]
