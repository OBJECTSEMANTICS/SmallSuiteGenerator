Class {
	#name : #SSmallSuiteGeneratorExample,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Examples-Demo'
}

{ #category : #accessing }
SSmallSuiteGeneratorExample >> clean [
	SMultiFitnessFunction
		clean;
		reset.
	SSGeneratorInvariant resetNumTest.
	SSGeneratorInvariant resetClassOfTest 
	"SSAssertionGeneratorTest methodsDo: #removeFromSystem"
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleEmptyBlockOnPackages [
	| smallSuiteGenerator block regex funcFitness |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	SSGeneratorInvariant resetNumTest.
	block := [  ].
	regex := 'SmallSuiteGenerator-Examples'.
	smallSuiteGenerator
		seed: block;
		profilingOnPackagesMatching: regex.
	funcFitness := SMethodCoverage.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator run
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnClass [
	| smallSuiteGenerator |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	smallSuiteGenerator
		seed: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ];
		profilingOnClass: SSTeacher.
	smallSuiteGenerator fitness: SMethodCoverage.
	^ smallSuiteGenerator run
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnPackages [
	| smallSuiteGenerator |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	smallSuiteGenerator
		seed: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ];
		profilingOnPackagesMatching: 'SmallSuiteGenerator-Examples';
		fitness:
			(SMultiFitnessFunction
				with: SMethodCoverage;
				with: SStatementCoverage).
	^ smallSuiteGenerator run
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStackOnClass [
	| smallSuiteGenerator |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	smallSuiteGenerator
		seed: [ (SStack newStackWith: #(1 5 3 2))
				pop;
				top;
				push: 4 ];
		profilingOnClass: SStack;
		fitness:
			(SMultiFitnessFunction
				with: SMethodCoverage;
				with: SStatementCoverage).
	^ smallSuiteGenerator run
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSStackOnPackages [
	| smallSuiteGenerator |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	smallSuiteGenerator
		seed: [ (SStack newStackWith: #(1 5 3 2))
				pop;
				top;
				push: 4 ];
		profilingOnPackagesMatching: 'SmallSuiteGenerator-Examples';
		fitness: SStatementCoverage.
	^ smallSuiteGenerator run
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStudentOnClass [
	| smallSuiteGenerator |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	smallSuiteGenerator
		seed: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ];
		profilingOnClass: SStudent;
		fitness: SStatementCoverage.
	^ smallSuiteGenerator run
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithSubclassToRun [
	| smallSuiteGenerator |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	smallSuiteGenerator
		seed: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ];
		profilingOnClass: SSTeacher;
		fitness:
			(SMultiFitnessFunction
				with: SMethodCoverage;
				with: SStatementCoverage).
	^ smallSuiteGenerator run
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithWrongClassToRun [
	| smallSuiteGenerator |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	smallSuiteGenerator
		seed: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ];
		profilingOnClass: SFoo;
		fitness: SStatementCoverage.
	^ smallSuiteGenerator run
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleWithWrongRegexToRun [
	| smallSuiteGenerator |
	self clean.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	smallSuiteGenerator
		seed: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent ];
		profilingOnPackagesMatching: 'SmallSuiteGenerator-Fitness';
		fitness:
			(SMultiFitnessFunction
				with: SMethodCoverage;
				with: SStatementCoverage).
	^ smallSuiteGenerator run
]
