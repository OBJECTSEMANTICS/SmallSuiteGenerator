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

{ #category : #'as yet unclassified' }
SGAEngineTest >> profilerOf: string [ 
	(S2CInstrumentator onPackagesMatching: string) applyOn: profiler.
	(profiler allMethods select: #isNotMethodExtension)
		do: #installGhosts
	"displayingProgress: 'Instrumenting ' , symbol"
]

{ #category : #running }
SGAEngineTest >> setUp [
	super setUp.
	engine := SGAEngine new.
	profiler := SBProfiler new.
	utility := SUtilityTypeInfo new
]

{ #category : #running }
SGAEngineTest >> tearDown [
	"profiler cleanInstrumentation"

	profiler cleanInstrumentation.
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove. super tearDown

	"SMultiFitnessFunction
		clean;
		reset."


	"S2Profiler clean."
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
	| first last functionFitness typeInfo targetPackageRegex |
	targetPackageRegex := 'SmallSuiteGenerator-Scenario'.
	typeInfo := STON fromString: utility typeInfoStringSFoo3.
	self profilerOf: targetPackageRegex.
	functionFitness := SMethodCoverage new profiler: profiler.
	functionFitness tagetPackagesRegex: targetPackageRegex.
	engine
		typeInfo: typeInfo;
		fitness: functionFitness;
		targetClassName: #SFoo;
		numberOfIterations: 5;
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
	| first last functionFitness typeInfo targetPackageRegex |
	targetPackageRegex := 'SmallSuiteGenerator-Scenario'.
	typeInfo := STON fromString: utility typeInfoStringSSTeacher1.
	self profilerOf: targetPackageRegex.
	functionFitness := SMethodCoverage new profiler: profiler.
	functionFitness tagetPackagesRegex: targetPackageRegex.
	engine
		typeInfo: typeInfo;
		fitness: functionFitness;
		targetClassName: #SSTeacher;
		numberOfIterations: 5;
		run.
	first := engine logs first fittestTestCase fitness
		at: functionFitness functionName.
	last := engine logs last fittestTestCase fitness
		at: functionFitness functionName.
	self assert: first > 0.	"20 = (1/5) * 100"
	self assert:  first <= last.	"80 = (4/5) * 100"
]

{ #category : #tests }
SGAEngineTest >> testRunOnPackagesSSTeacherUsingStatementCoverage [
	| first last functionFitness typeInfo targetPackageRegex |
	targetPackageRegex := 'SmallSuiteGenerator-Scenario'.
	typeInfo := STON fromString: utility typeInfoStringSSTeacher1.
	self profilerOf: targetPackageRegex.
	functionFitness := SStatementCoverage new profiler: profiler.
	functionFitness tagetPackagesRegex: targetPackageRegex.
	engine
		typeInfo: typeInfo;
		fitness: functionFitness;
		targetClassName: #SSTeacher;
		numberOfIterations: 5;
		run.
	first := engine logs first fittestTestCase fitness
		at: functionFitness functionName.
	last := engine logs last fittestTestCase fitness
		at: functionFitness functionName.
	self assert: first > 0.	"37.5 = (3/8) * 100"
	self assert: first <= last	"87.5 = (7/8) * 100"
]
