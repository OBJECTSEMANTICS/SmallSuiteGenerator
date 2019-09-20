Class {
	#name : #SGAEngineTest,
	#superclass : #TestCase,
	#instVars : [
		'engine'
	],
	#category : #'SmallSuiteGenerator-Tests-GeneticAlgorithm'
}

{ #category : #actions }
SGAEngineTest >> runOnClass: aClass withBlock: aBlock andFitness: aClassFitness [
	"	SSGeneratorInvariant resetNumTest."

	self settingEngineOnClass: aClass withBlock: aBlock.
	engine
		fitness: (aClassFitness coverageOf: aBlock onClass: aClass);
		run
]

{ #category : #running }
SGAEngineTest >> setUp [ 
	engine := SGAEngine new
]

{ #category : #actions }
SGAEngineTest >> settingEngineOnClass: aClass withBlock: aBlock [
	engine
		populationSize: 10;
		numberOfStatements: 10;
		blockToExecute: aBlock;
		endForMaxNumberOfGeneration: 10;
		typeInfo:
			(SSGenerator profile: engine blockToExecute onClass: aClass)
				asTypeInfo
]

{ #category : #running }
SGAEngineTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove.
	SMultiFitnessFunction clean.
	SCoverageWithProfiler allSubclassesDo: #clean
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassSSTeacherUsingSMethodCoverage [
	| first last classFitness |
	classFitness := SMethodCoverage.
	self
		runOnClass: SSTeacher
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: classFitness.
	first := engine logs first fittestTestCase fitness at: classFitness nameFunction.
	last := engine logs last fittestTestCase fitness at: classFitness nameFunction.
	self assert: first <= last.
	self assert: first >= 20.	"20 = (1/5) * 100"
	self assert: last equals: 80	"80 = (4/5) * 100"
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassSSTeacherUsingSMultiFitnessFunction [
	| firstFitness lastFitness function block nameFunction |
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	self settingEngineOnClass: SSTeacher withBlock: block.
	function := SMultiFitnessFunction.
	function
		addFitnessFunction: (SMethodCoverage coverageOf: block onClass: SSTeacher);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	engine
		fitness: function;
		run.
	firstFitness := engine logs first fittestTestCase fitness.
	lastFitness := engine logs last fittestTestCase fitness.
	nameFunction := SMethodCoverage nameFunction.
	self
		assert: (firstFitness at: nameFunction) <= (lastFitness at: nameFunction).
	self assert: (firstFitness at: nameFunction) >= 20.	"20 = (1/5) * 100"
	self assert: (lastFitness at: nameFunction) equals: 80.	"80 = (4/5) * 100"
	nameFunction := SStatementCoverage nameFunction.
	self
		assert: (firstFitness at: nameFunction) <= (lastFitness at: nameFunction).	
	self assert: (firstFitness at: nameFunction) >= 37.5.	"37.5 = (3/8) * 100"
	self assert: (lastFitness at: nameFunction) >= 87.5	"87.5 = (7/8) * 100"
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassSSTeacherUsingSStatementCoverage [
	| first last classFitness |
	classFitness := SStatementCoverage.
	self
		runOnClass: SSTeacher
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: classFitness.
	first := engine logs first fittestTestCase fitness at: classFitness nameFunction .
	last := engine logs last fittestTestCase fitness at: classFitness nameFunction.
	self assert: first <= last.
	self assert: first >= 37.5.	"37.5 = (3/8) * 100"
	self assert: last >= 87.5	"87.5 = (7/8) * 100"
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassSStudentManual [
	| testSuite block utility |
	utility := SUtilityTypeInfo new.
	block := [ SStudent new
		scoreStudent: 34;
		scoreStudent;
		idStudent].
	testSuite := utility testSuiteSStudentManual.
	engine
		populationSize: 3;
		numberOfStatements: 10;
		blockToExecute: block;
		endForMaxNumberOfGeneration: 10;
		typeInfo: utility typeInfosSStudent first;
		initializePopulationWith: testSuite;
		fitness: (SStatementCoverage coverageOf: block onClass: SStudent).
	engine run
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassUsingSMultiFitnessFunctionAndWeightedSumMethod [
	| firstFitness lastFitness function block nameFunction functions |
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	self settingEngineOnClass: SSTeacher withBlock: block.
	function := SMultiFitnessFunction.
	functions := Array
		with: (SMethodCoverage coverageOf: block onClass: SSTeacher)
		with: (SStatementCoverage profiler: SMethodCoverage profiler).
	function
		addFitnessFunction: functions first;
		addFitnessFunction: functions second.
	function
		selectorMethod:
			(SWeightedSumMethod
				weights: #(0.7 0.3);
				functions: functions).
	engine
		fitness: function;
		run.
	firstFitness := engine logs first fittestTestCase fitness.
	lastFitness := engine logs last fittestTestCase fitness.
	nameFunction := SMethodCoverage nameFunction.
	self
		assert: (firstFitness at: nameFunction) <= (lastFitness at: nameFunction).
	self assert: (firstFitness at: nameFunction) >= 20.	"20 = (1/5) * 100"
	self assert: (lastFitness at: nameFunction) equals: 80.	"80 = (4/5) * 100"
	nameFunction := SStatementCoverage nameFunction.
	self
		assert: (firstFitness at: nameFunction) <= (lastFitness at: nameFunction).
	self assert: (firstFitness at: nameFunction) >= 37.5.	"37.5 = (3/8) * 100"
	self assert: (firstFitness at: nameFunction) >= 87.5	"87.5 = (7/8) * 100"
]