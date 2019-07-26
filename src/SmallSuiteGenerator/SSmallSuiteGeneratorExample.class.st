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
