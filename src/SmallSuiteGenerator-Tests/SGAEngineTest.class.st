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
SGAEngineTest >> profilerOf: symbol [
	(S2CInstrumentator onPackagesMatching: symbol)
		applyOn: profiler.
	(profiler allMethods select: #isNotMethodExtension)
		do: #installGhosts
		displayingProgress: 'Instrumenting ' , symbol.
]

{ #category : #actions }
SGAEngineTest >> runOnClass: aClass withBlock: aBlock andFitness: aClassFitness [
	"	SSGeneratorInvariant resetNumTest."

	self settingEngineOnClass: aClass withBlock: aBlock.
	"engine
		fitness: (aClassFitness coverageOf: aBlock onClass: aClass);
		run"
]

{ #category : #actions }
SGAEngineTest >> runOnPackagesMatching: regex withBlock: aBlock baseClassName: symbol andFitness: aClass [
	"	SSGeneratorInvariant resetNumTest."

	self settingOnPackagesMatching: regex withBlock: aBlock and: symbol.
	"engine
		fitness: (aClass coverageOf: aBlock onPackagesMatching: regex);
		run"
]

{ #category : #running }
SGAEngineTest >> setUp [
	super setUp.
	"engine := SGAEngine new.
	profiler := SBProfiler new.
	utility := SUtilityTypeInfo new"
]

{ #category : #actions }
SGAEngineTest >> settingEngineOnClass: aClass withBlock: aBlock [
	engine
		populationSize: 10;
		numberOfStatements: 10;
		blockToExecute: aBlock;
		numberOfIterations: 5;
		typeInfo:
			(SSTypeCollector profile: engine blockToExecute onClass: aClass)
				asTypeInfo;
		targetClassName: aClass name
]

{ #category : #actions }
SGAEngineTest >> settingOnPackagesMatching: regex withBlock: aBlock and: symbol [
	engine
		populationSize: 10;
		numberOfStatements: 10;
		blockToExecute: aBlock;
		numberOfIterations: 5;
		typeInfo:
			(SSTypeCollector
				profile: engine blockToExecute
				onPackagesMatching: regex) asTypeInfo;
		targetClassName: symbol
]

{ #category : #running }
SGAEngineTest >> tearDown [
	"profiler cleanInstrumentation"

	"S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove"

	"SMultiFitnessFunction
		clean;
		reset."
	super tearDown 

	
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassSSTeacherUsingSMethodCoverage [
	"| first last functionFitness typeInfo targetPackageRegex |
	targetPackageRegex := 'SmallSuiteGenerator-Scenario'.
	typeInfo := STON fromString: utility typeInfoStringSSTeacher1.
	self profilerOf: targetPackageRegex.
	functionFitness := SMethodCoverage new profiler: profiler.
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
	self assert: first <= last.
	self assert: first >= 20.	""20 = (1/5) * 100""
	self assert: last equals: 80	""80 = (4/5) * 100"""
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassSSTeacherUsingSMultiFitnessFunction [
	"| firstFitness lastFitness function block nameFunction |
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	self settingEngineOnClass: SSTeacher withBlock: block.
	function := SMultiFitnessFunction.
	profiler := nil.
	function
		add: (SMethodCoverage new profiler: profiler) weight: 1;
		add: (SStatementCoverage new profiler: profiler) weight: 1.
	engine
		fitness: function;
		run.
	firstFitness := engine logs first fittestTestCase fitness.
	lastFitness := engine logs last fittestTestCase fitness.
	nameFunction := 'method-coverage'.
	self
		assert: (firstFitness at: nameFunction) <= (lastFitness at: nameFunction).
	self assert: (firstFitness at: nameFunction) >= 20.	""20 = (1/5) * 100""
	self assert: (lastFitness at: nameFunction) equals: 80.	""80 = (4/5) * 100""
	nameFunction := 'block-coverage'.
	self
		assert: (firstFitness at: nameFunction) <= (lastFitness at: nameFunction).
	self assert: (firstFitness at: nameFunction) >= 37.5.	""37.5 = (3/8) * 100""
	self assert: (lastFitness at: nameFunction) >= 87.5	""87.5 = (7/8) * 100"""
]

{ #category : #tests }
SGAEngineTest >> testRunOnClassSSTeacherUsingSStatementCoverage [
	"| first last classFitness |
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
	first := engine logs first fittestTestCase fitness
		at: classFitness functionName.
	last := engine logs last fittestTestCase fitness
		at: classFitness functionName.
	self assert: first <= last.
	self assert: first >= 37.5.	""37.5 = (3/8) * 100""
	self assert: last >= 87.5	""87.5 = (7/8) * 100"""
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
SGAEngineTest >> testRunOnClassUsingSMultiFitnessFunctionAndWeightedSumMethod [
	"| firstFitness lastFitness function block nameFunction |
	block := [ (SSTeacher name: 'Ann' with: 34)
		name;
		nickname;
		yearsWorkExperience;
		idTeacher;
		id ].
	self settingEngineOnClass: SSTeacher withBlock: block.
	function := SMultiFitnessFunction.
	engine
		fitness: function;
		run.
	firstFitness := engine logs first fittestTestCase fitness.
	lastFitness := engine logs last fittestTestCase fitness.
	nameFunction := SMethodCoverage new functionName.
	self
		assert: (firstFitness at: nameFunction) <= (lastFitness at: nameFunction).
	self assert: (firstFitness at: nameFunction) >= 20.	""20 = (1/5) * 100""
	self assert: (lastFitness at: nameFunction) equals: 80.	""80 = (4/5) * 100""
	nameFunction := SStatementCoverage new functionName.
	self
		assert: (firstFitness at: nameFunction) <= (lastFitness at: nameFunction).
	self assert: (firstFitness at: nameFunction) >= 37.5.	""37.5 = (3/8) * 100""
	self assert: (firstFitness at: nameFunction) >= 87.5"	"87.5 = (7/8) * 100"""
]

{ #category : #tests }
SGAEngineTest >> testRunUsingBaseClassNameSFoo [
	"| first last classFitness |
	classFitness := SMethodCoverage.
	self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SFoo score: 4)
				score;
				returnCollection;
				returnString;
				score: 5;
				return:
					((SStudent name: 'Emily')
						nickname;
						scoreStudent;
						yourself) ]
		baseClassName: #SFoo
		andFitness: classFitness.
	first := engine logs first fittestTestCase fitness
		at: classFitness nameFunction.
	last := engine logs last fittestTestCase fitness
		at: classFitness nameFunction.
	self assert: first <= last"
]

{ #category : #tests }
SGAEngineTest >> testRunUsingBaseClassNameSSTeacher [
	"| first last classFitness |
	classFitness := SMethodCoverage.
	self
		runOnPackagesMatching: 'SmallSuiteGenerator-Scenario'
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		baseClassName: #SSTeacher
		andFitness: classFitness.
	first := engine logs first fittestTestCase fitness
		at: classFitness functionName.
	last := engine logs last fittestTestCase fitness
		at: classFitness functionName.
	self assert: first <= last"
]
