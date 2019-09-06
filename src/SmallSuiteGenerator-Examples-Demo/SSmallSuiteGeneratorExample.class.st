Class {
	#name : #SSmallSuiteGeneratorExample,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Examples-Demo'
}

{ #category : #accessing }
SSmallSuiteGeneratorExample >> clear [
	SMultiFitnessFunction clear.
	SCoverageWithProfiler allSubclassesDo: #clear.
	SSmallSuiteGenerator resetInstance.
]

{ #category : #accessing }
SSmallSuiteGeneratorExample >> clearProfiler [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove.
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleEmptyBlockOnPackages [
	| smallSuiteGenerator block regex funcFitness |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	SSGeneratorInvariant resetNumTest.
	block := [  ].
	regex := 'SmallSuiteGenerator-Examples'.
	smallSuiteGenerator seed: block onPackagesMatching: regex.
	funcFitness := SMethodCoverage.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator run.
	self clearProfiler
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnClass [
	| smallSuiteGenerator block aClass invariants funcFitness |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	aClass := SSTeacher.
	smallSuiteGenerator seed: block onClass: aClass.
	funcFitness := SMethodCoverage coverageOf: block onClass: aClass.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator run.
	smallSuiteGenerator generateTestsWith: invariants.
	self clearProfiler
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnPackages [
	| smallSuiteGenerator block regex functionFitness |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator instance.
	SSGeneratorInvariant resetNumTest.
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	regex := 'SmallSuiteGenerator-Examples'.
	smallSuiteGenerator seed: block onPackagesMatching: regex.
	functionFitness := SMultiFitnessFunction.
	functionFitness
		addFitnessFunction: (SMethodCoverage coverageOf: block onPackagesMatching: regex);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator fitness: functionFitness.
	smallSuiteGenerator run.
	smallSuiteGenerator generateTestsWith: #().
	self clearProfiler
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStackOnClass [
	| smallSuiteGenerator block invariants aClass functionFitness grapher |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SStack newStackWith: #(1 5 3 2))
		pop;
		top;
		push: 4 ].
	aClass := SStack.
	smallSuiteGenerator seed: block onClass: aClass.
	functionFitness := SMultiFitnessFunction.
	functionFitness
		addFitnessFunction: (SMethodCoverage coverageOf: block onClass: aClass);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator fitness: functionFitness.
	smallSuiteGenerator run.
	smallSuiteGenerator generateTestsWith: invariants.
	grapher := smallSuiteGenerator visualize.
	self clearProfiler.
	^ grapher
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSStackOnPackages [
	| smallSuiteGenerator block regex funcFitness grapher |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator instance.
	SSGeneratorInvariant resetNumTest.
	block := [ (SStack newStackWith: #(1 5 3 2))
		pop;
		top;
		push: 4 ].
	regex := 'SmallSuiteGenerator-Examples'.
	smallSuiteGenerator seed: block onPackagesMatching: regex.
	funcFitness := SStatementCoverage
		coverageOf: block
		onPackagesMatching: regex.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator run.
	smallSuiteGenerator generateTestsWith: #().
	grapher := smallSuiteGenerator visualize.
	self clearProfiler.
	^ grapher
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStudentOnClass [
	| smallSuiteGenerator block aClass invariants funcFitness |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	aClass := SStudent.
	smallSuiteGenerator seed: block onClass: aClass.
	funcFitness := SStatementCoverage coverageOf: block onClass: aClass.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator run.
	smallSuiteGenerator generateTestsWith: invariants.
	self clearProfiler
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithSubclassToRun [
	| smallSuiteGenerator block aClass invariants functionFitness |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator instance.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	aClass := SSTeacher.
	smallSuiteGenerator seed: block onClass: aClass.
	functionFitness := SMultiFitnessFunction.
	functionFitness
		addFitnessFunction: (SMethodCoverage coverageOf: block onClass: aClass);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator fitness: functionFitness.
	smallSuiteGenerator run.
	smallSuiteGenerator generateTestsWith: invariants.
	self clearProfiler
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithWrongClassToRun [
	| smallSuiteGenerator block aClass invariants funcFitness |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator newInstance.
	SSGeneratorInvariant resetNumTest.
	invariants := #().
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent;
		scoreStudent: 45;
		scoreStudent ].
	aClass := SFoo.
	smallSuiteGenerator seed: block onClass: aClass.
	funcFitness := SStatementCoverage coverageOf: block onClass: aClass.
	smallSuiteGenerator fitness: funcFitness.
	smallSuiteGenerator run.
	smallSuiteGenerator generateTestsWith: invariants.
	self clearProfiler
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleWithWrongRegexToRun [
	| smallSuiteGenerator block regex functionFitness |
	self clear.
	smallSuiteGenerator := SSmallSuiteGenerator instance.
	SSGeneratorInvariant resetNumTest.
	block := [ (SStudent name: 'Ann' with: 34)
		nickname;
		idStudent ].
	regex := 'SmallSuiteGenerator-Fitness'.
	smallSuiteGenerator seed: block onPackagesMatching: regex.
	functionFitness := SMultiFitnessFunction.
	functionFitness
		addFitnessFunction: (SMethodCoverage coverageOf: block onPackagesMatching: regex);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	smallSuiteGenerator fitness: functionFitness.
	smallSuiteGenerator run.
	self clearProfiler
]
