Class {
	#name : #SGAEngineTest,
	#superclass : #TestCase,
	#instVars : [
		'engine',
		'profiler',
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #actions }
SGAEngineTest >> profilerOf: string [
	profiler := self aSLProfilerCoverage profilerForPackagesMatching: string.
	profiler beforeProfiling
]

{ #category : #running }
SGAEngineTest >> setUp [
	super setUp.
	engine := SGAEngine new.
	profiler := self aSLProfilerCoverage new.
	utility := SUtilityTypeInfo new
]

{ #category : #running }
SGAEngineTest >> tearDown [
	[profiler uninstall] on: Error do: [].
	super tearDown
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassSStudentManual [
	"| testSuite block utility |
	utility := SUtilityTypeInfo new.
	block := [ SStudent new
		scoreStudent: 34;
		scoreStudent;
		idStudent ].
	testSuite := utility testSuiteSStudentManual.
	engine
		populationSize: 3;
		numberOfStatements: 10;
		blockToExecute: block;
		endForMaxNumberOfGeneration: 10;
		typeInfo: utility typeInfosSStudent first;
		initializePopulationWith: testSuite;
		fitness: (SStatementCoverage coverageOf: block onClass: SStudent).
	engine run"
]

{ #category : #tests }
SGAEngineTest >> testRunOnPackagesMatchingSFoo [
	| first last functionFitness  targetPackageRegex typeInfo targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	targetPackageRegex := 'SmallSuiteGenerator-Scenario'.
	typeInfo := utility typeInfoSFooOnPackage1.
	self profilerOf: targetPackageRegex.
	functionFitness := SMethodCoverage new profiler: profiler.
	functionFitness targetClass: targetClass;
	 typeInfo: typeInfo.
	engine
		targetPackageRegex: targetPackageRegex;
		typeInfo: typeInfo; 	" STON fromString: utility typeInfoStringSFoo3."
		targetClassName: targetClass;
		fitness: functionFitness;
		populationSize: 5;
		numberOfGenerations: 5;
		populationSize: 10;
		run.
	first := engine logs first fittestTestCase fitness
		at: functionFitness functionName.
	last := engine logs last fittestTestCase fitness
		at: functionFitness functionName.
	self assert: first > 0.
	self assert: first <= last
]

{ #category : #tests }
SGAEngineTest >> testRunOnPackagesSSTeacherUsingMethodCoverage [
	| first last functionFitness targetPackageRegex typeInfo targetClass |
	targetClass := #SSTeacher fullClassNameSymbol.
	targetPackageRegex := 'SmallSuiteGenerator-Scenario'.
	
	typeInfo := utility typeInfoSSTeacherOnPackage1.
	self profilerOf: targetPackageRegex.
	functionFitness := SMethodCoverage new profiler: profiler.
	functionFitness targetClass: targetClass;
	 typeInfo: typeInfo.
	engine
		targetPackageRegex: targetPackageRegex;
		typeInfo: typeInfo; "STON fromString: utility typeInfoStringSSTeacher1."
		fitness: functionFitness;
		targetClassName: targetClass;
		populationSize: 10;
		numberOfGenerations: 5;
		run.
	first := engine logs first fittestTestCase fitness
		at: functionFitness functionName.
	last := engine logs last fittestTestCase fitness
		at: functionFitness functionName.
	self assert: first > 0.	"20 = (1/5) * 100"
	self assert: first <= last	"80 = (4/5) * 100"
]

{ #category : #tests }
SGAEngineTest >> testRunOnPackagesSSTeacherUsingStatementCoverage [
	| first last functionFitness targetPackageRegex typeInfo targetClass |
	targetClass := #SSTeacher fullClassNameSymbol.
	targetPackageRegex := 'SmallSuiteGenerator-Scenario'.	
	typeInfo := utility typeInfoSSTeacherOnPackage1.
	self profilerOf: targetPackageRegex.
	functionFitness := SStatementCoverage new profiler: profiler.
	functionFitness targetClass: targetClass;
	 typeInfo: typeInfo.
	engine
		targetPackageRegex: targetPackageRegex;
		typeInfo: typeInfo;
		fitness: functionFitness;
		targetClassName: targetClass;
		populationSize: 10;
		numberOfGenerations: 5;
		run.
	first := engine logs first fittestTestCase fitness
		at: functionFitness functionName.
	last := engine logs last fittestTestCase fitness
		at: functionFitness functionName.
	self assert: first > 0.	"37.5 = (3/8) * 100"
	self assert: first <= last	"87.5 = (7/8) * 100"
]
