"
STestCaseFactoryExample contains some examples to run and validate the project functionality
"
Class {
	#name : #STestCaseFactoryExample,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
STestCaseFactoryExample >> clean [
	Spy2 clean.
S2Profiler remove.
]

{ #category : #'examples - onPackages' }
STestCaseFactoryExample >> exampleEmptyBlockOnPackages [
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
STestCaseFactoryExample >> exampleSSTeacherOnClass [
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
STestCaseFactoryExample >> exampleSSTeacherOnPackages [
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
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleSStackOnClass [
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
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onPackages' }
STestCaseFactoryExample >> exampleSStackOnPackages [
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
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleSStudentOnClass [
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
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleWithSubclassToRun [
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
		targetPackageRegex: 'SmallSuiteGenerator-Scenario2';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleWithWrongClassToRun [
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
		targetPackageRegex: 'SmallSuiteGenerator-Scenario2';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]

{ #category : #'examples - onPackages' }
STestCaseFactoryExample >> exampleWithWrongRegexToRun [
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
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		visualize;
		yourself
]
