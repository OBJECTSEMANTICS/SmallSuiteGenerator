Class {
	#name : #SSmallSuiteGeneratorExample,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SSmallSuiteGeneratorExample >> clean [
	Spy2 clean.
S2Profiler remove.
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleEmptyBlockOnPackages [
	|facade|
	self clean.
	facade := SConfiguration classTestCaseFactory.
	^ facade new
		typeInfo:
			(SSTypeCollector
				profile: [  ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario');
		fitness: SMethodCoverage new;
		targetClassName: #SFoo;
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnClass [
	| typeInfo facade|
	self clean.
	facade := SConfiguration classTestCaseFactory.
	typeInfo := SSTypeCollector
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onClass: SSTeacher.
	^ facade new
		typeInfo: typeInfo;
		fitness: SMethodCoverage new;
		targetClassName: #SSTeacher;
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSSTeacherOnPackages [
	| typeInfo facade |
	self clean.
	facade := SConfiguration classTestCaseFactory.
	typeInfo := SSTypeCollector
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'.
	^ facade new
		typeInfo: typeInfo;
		fitness:
			(SMultiFitnessFunction new
				with: SMethodCoverage new;
				with: SStatementCoverage new);
		targetClassName: #SSTeacher;
		targetPackagesRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStackOnClass [
	| typeInfo facade |
	self clean.
	facade := SConfiguration classTestCaseFactory.
	typeInfo := SSTypeCollector
		profile: [ (SStack newStackWith: #(1 5 3 2))
				pop;
				top;
				push: 4 ]
		onClass: SStack.
	^ facade new
		typeInfo: typeInfo;
		fitness:
			(SMultiFitnessFunction new
				with: SMethodCoverage new;
				with: SStatementCoverage new);
		targetClassName: #SStack;
		targetPackagesRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleSStackOnPackages [
	| typeInfo facade |
	self clean.
	facade := SConfiguration classTestCaseFactory.
	typeInfo := SSTypeCollector
		profile: [ (SStack newStackWith: #(1 5 3 2))
				pop;
				top;
				push: 4 ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'.
	^ facade new
		typeInfo: typeInfo;
		fitness: SStatementCoverage new;
		targetClassName: #SStack;
		targetPackagesRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleSStudentOnClass [
	| typeInfo facade |
	self clean.
	facade := SConfiguration classTestCaseFactory.
	typeInfo := SSTypeCollector
		profile: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		onClass: SStudent.
	^ facade new
		typeInfo: typeInfo;
		fitness: SStatementCoverage new;
		targetClassName: #SStudent;
		targetPackagesRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithSubclassToRun [
	| typeInfo facade |
	self clean.
	facade := SConfiguration classTestCaseFactory.
	typeInfo := SSTypeCollector
		profile: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario2'.
	^ facade new
		typeInfo: typeInfo;
		fitness:
			(SMultiFitnessFunction new
				with: SMethodCoverage new;
				with: SStatementCoverage new);
		targetClassName: #SStudent;
		targetPackagesRegex: 'SmallSuiteGenerator-Scenario2';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
SSmallSuiteGeneratorExample >> exampleWithWrongClassToRun [
	| typeInfo facade |
	self clean.
	facade := SConfiguration classTestCaseFactory.
	typeInfo := SSTypeCollector
		profile: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		onClass: SFoo.
	^ facade new
		typeInfo: typeInfo;
		fitness: SStatementCoverage new;
		targetClassName: #SStudent;
		targetPackagesRegex: 'SmallSuiteGenerator-Scenario2';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onPackages' }
SSmallSuiteGeneratorExample >> exampleWithWrongRegexToRun [
	| typeInfo facade |
	self clean.
	facade := SConfiguration classTestCaseFactory.
	typeInfo := SSTypeCollector
		profile: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'.
	^ facade new
		typeInfo: typeInfo;
		fitness:
			(SMultiFitnessFunction new
				with: SMethodCoverage new;
				with: SStatementCoverage new);
		targetClassName: #SStudent;
		targetPackagesRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]
