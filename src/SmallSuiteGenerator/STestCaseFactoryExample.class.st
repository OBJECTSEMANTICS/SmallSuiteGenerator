"
STestCaseFactoryExample contains some examples to run and validate the project functionality
"
Class {
	#name : #STestCaseFactoryExample,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Examples'
}

{ #category : #accessing }
STestCaseFactoryExample >> clean [
	
]

{ #category : #'examples - onPackages' }
STestCaseFactoryExample >> exampleEmptyBlockOnPackages [
	|facade typeInfo|
	self clean.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
				profile: [  ]
				inPackagesMatching: 'SmallSuiteGenerator-Scenario').
	facade := SPlatform classTestCaseFactory.
	^ facade new
		typeInfo: typeInfo;
		fitness: SMethodCoverage new;
		targetClassName: #SFoo;
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleSSTeacherOnClass [
	| typeInfo facade|
	self clean.
	facade := SPlatform classTestCaseFactory.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		forClassNamed: #SSTeacher).
	^ facade new
		typeInfo: typeInfo;
		fitness: SMethodCoverage new;
		targetClassName: #SSTeacher;
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		yourself
]

{ #category : #'examples - onPackages' }
STestCaseFactoryExample >> exampleSSTeacherOnPackages [
	| typeInfo facade |
	self clean.
	facade := SPlatform classTestCaseFactory.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		inPackagesMatching: 'SmallSuiteGenerator-Scenario').
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
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleSStackOnClass [
	| typeInfo facade |
	self clean.
	facade := SPlatform classTestCaseFactory.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SStack newStackWith: #(1 5 3 2))
				pop;
				top;
				push: 4 ]
		forClassNamed: #SStack).
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
		yourself
]

{ #category : #'examples - onPackages' }
STestCaseFactoryExample >> exampleSStackOnPackages [
	| typeInfo facade |
	self clean.
	facade := SPlatform classTestCaseFactory.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SStack newStackWith: #(1 5 3 2))
				pop;
				top;
				push: 4 ]
		inPackagesMatching: 'SmallSuiteGenerator-Scenario').
	^ facade new
		typeInfo: typeInfo;
		fitness: SStatementCoverage new;
		targetClassName: #SStack;
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleSStudentOnClass [
	| typeInfo facade |
	self clean.
	facade := SPlatform classTestCaseFactory.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		forClassNamed: #SStudent).
	^ facade new
		typeInfo: typeInfo;
		fitness: SStatementCoverage new;
		targetClassName: #SStudent;
		targetPackageRegex: 'SmallSuiteGenerator-Scenario';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleWithSubclassToRun [
	| typeInfo facade |
	self clean.
	facade := SPlatform classTestCaseFactory.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		inPackagesMatching: 'SmallSuiteGenerator-Scenario2').
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
		yourself
]

{ #category : #'examples - onClass' }
STestCaseFactoryExample >> exampleWithWrongClassToRun [
	| typeInfo facade |
	self clean.
	facade := SPlatform classTestCaseFactory.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		forClassNamed: #SFoo).
	^ facade new
		typeInfo: typeInfo;
		fitness: SStatementCoverage new;
		targetClassName: #SStudent;
		targetPackageRegex: 'SmallSuiteGenerator-Scenario2';
		outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
		createTestCases;
		yourself
]

{ #category : #'examples - onPackages' }
STestCaseFactoryExample >> exampleWithWrongRegexToRun [
	| typeInfo facade |
	self clean.
	facade := SPlatform classTestCaseFactory.
	typeInfo := STypeInfo asTypeInfo: (SSTypeCollector
		profile: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent ]
		inPackagesMatching: 'SmallSuiteGenerator-Scenario').
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
		yourself
]
