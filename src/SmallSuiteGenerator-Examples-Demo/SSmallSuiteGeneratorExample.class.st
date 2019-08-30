Class {
	#name : #SSmallSuiteGeneratorExample,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Examples-Demo'
}

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleEmptyBlockOnPackages [
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [  ].
	regex := 'SmallSuiteGenerator-Examples'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex with: SMethodCoverage .
	smallSuiteGenerator runGeneration
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnClass [
	| smallSuiteGenerator block class invariants |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	class := SSTeacher.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class with: SMethodCoverage.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnPackages [
	| smallSuiteGenerator block regex functionFitness |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	regex := 'SmallSuiteGenerator-Examples'.
	functionFitness := SMultiFitnessFunction.
	functionFitness addFitnessFunction:
			(SMethodCoverage
				coverageOf: block
				onPackagesMatching: regex);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex with: functionFitness .
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: #()
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStackOnClass [
	| smallSuiteGenerator block invariants functionFitness |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SStack newStackWith: #(1 5 3 2))
		pop;
		top;
		push: 4 ].
	functionFitness := SMultiFitnessFunction.
	functionFitness addFitnessFunction:
			(SMethodCoverage
				coverageOf: block
				onClass: SStack);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator generateTestsOf: block blockOnClass: SStack with: functionFitness.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSStackOnPackages [
	| smallSuiteGenerator block regex |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ (SStack newStackWith: #(1 5 3 2))
		pop;
		top;
		push: 4 ].
	regex := 'SmallSuiteGenerator-Examples'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex with: SStatementCoverage .
	smallSuiteGenerator runGeneration
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStudentOnClass [
	| smallSuiteGenerator block class invariants |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	class := SStudent.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class with: SStatementCoverage.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithSubclassToRun [
	| smallSuiteGenerator block class invariants functionFitness |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	class := SSTeacher.
	functionFitness := SMultiFitnessFunction.
	functionFitness addFitnessFunction:
			(SMethodCoverage
				coverageOf: block
				onClass: class);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator generateTestsOf: block blockOnClass: class with: functionFitness .
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithWrongClassToRun [
	| smallSuiteGenerator block class invariants |
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	class := SFoo.
	smallSuiteGenerator generateTestsOf: block blockOnClass: class with: SStatementCoverage.
	smallSuiteGenerator runGeneration.
	smallSuiteGenerator generateAssertionsUsing: invariants
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleWithWrongRegexToRun [
	| smallSuiteGenerator block regex functionFitness|
	smallSuiteGenerator := SSmallSuiteGenerator new.
	SSGeneratorInvariant resetNumTest.
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent ].
	functionFitness := SMultiFitnessFunction.
	functionFitness addFitnessFunction:
			(SMethodCoverage
				coverageOf: block
				onPackagesMatching: regex);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	regex := 'SmallSuiteGenerator-Fitness'.
	smallSuiteGenerator
		generateTestsOf: block
		blockOnPackagesMatching: regex with: functionFitness.
	smallSuiteGenerator runGeneration
]
