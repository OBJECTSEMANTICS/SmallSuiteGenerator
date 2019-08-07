Class {
	#name : #SGAEngineExample,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Examples-Demo'
}

{ #category : #actions }
SGAEngineExample >> clean [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove.
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSSTeacherOnClass [
	| engine |
	engine := self
		runOnClass: SSTeacher
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: SMethodCoverage.
	self assert: engine logs first fittestTestCase fitness >= 20.	"20 = (1/5) * 100"
	self assert: engine logs last fittestTestCase fitness equals: 80.	"80 = (4/5) * 100"
	engine := self
		runOnClass: SSTeacher
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: SStatementCoverage.
	self assert: engine logs last fittestTestCase fitness >= 37.5.	"37.5 = (3/8) * 100"
	self assert: engine logs last fittestTestCase fitness >= 87.5.	"87.5 = (7/8) * 100"
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSSTeacherOnPackage [
	|engine |
	engine :=
	self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: SMethodCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: SStatementCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSStackOnClass [
	|engine |
	engine := 
	self
		runOnClass: SStack
		withBlock: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		andFitness: SMethodCoverage.
	self assert: engine logs first fittestTestCase fitness >= 14.28.	"14.28 = (1/7) * 100 round: 2"
	self assert: engine logs last fittestTestCase fitness >= 57.14.	"57.14 = (4/7) * 100 round: 2"
	engine := self
		runOnClass: SStack
		withBlock: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		andFitness: SStatementCoverage.
	self assert: engine logs first fittestTestCase fitness >= 21.05.	"21.05 = (4/19) * 100 round: 2"
	self assert: engine logs last fittestTestCase fitness >= 73.68.	"73.68 = (14/19) * 100 round: 2"
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSStackOnPackage [
	| engine |
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SStack newStackWith: #(2  4  6  1))
				push: 8;
				pop;
				top ]
		andFitness: SMethodCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SStack newStackWith: #(2  4  6  1))
				push: 8;
				pop;
				top ]
		andFitness: SStatementCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSStudentOnClass [
	|engine|
	engine := 
	self
		runOnClass: SStudent
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		andFitness: SMethodCoverage.
	self assert: engine logs first fittestTestCase fitness >= 20.
	self assert: engine logs last fittestTestCase fitness equals: 100.
	engine := self
		runOnClass: SStudent
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		andFitness: SStatementCoverage.
	self assert: engine logs first fittestTestCase fitness >= 37.5.
	self assert: engine logs last fittestTestCase fitness equals: 100.
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSStudentOnPackage [
	|engine|
	engine := 
	self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		andFitness: SMethodCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		andFitness: SStatementCoverage.
	self
		assert:
			engine logs first fittestTestCase fitness
				<= engine logs last fittestTestCase fitness.
	self clean
]

{ #category : #actions }
SGAEngineExample >> runOnClass: aClass withBlock: aBlock andFitness: aClassFitness [
	|engine |
	engine := SGAEngine new.
	SSGeneratorInvariant resetNumTest.
	engine
		populationSize: 30;
		numberOfStatements: 15;
		blockToExecute: aBlock.
	engine
		typeInfo:
			(SSGenerator profile: engine blockToExecute onClass: aClass)
				asTypeInfo;
		fitness: [ :aTestCase | 
			| fitness |
			fitness := aClassFitness new
				profiler:
					(SBProfiler new
						profileInstrumented: engine blockToExecute onClass: aClass;
						yourself).
			fitness run: aTestCase ];
		endForMaxNumberOfGeneration: 15;
		run.
	^ engine
]

{ #category : #actions }
SGAEngineExample >> runOnPackagesMatching: regex withBlock: aBlock andFitness: aClassFitness [
	|engine |
	engine := SGAEngine new.
	SSGeneratorInvariant resetNumTest.
	engine
		populationSize: 30;
		numberOfStatements: 15;
		blockToExecute: aBlock;
		typeInfo: [ :blockToExecute | 
			(SSGenerator profile: blockToExecute onPackagesMatching: regex)
				asTypeInfo ];
		fitness: [ :aTestCase | 
			| fitness |
			fitness := aClassFitness new
				profiler:
					(SBProfiler new
						profileInstrumented: engine blockToExecute
							onPackagesMatching: regex;
						yourself).
			fitness run: aTestCase ];
		endForMaxNumberOfGeneration: 15;
		run.
		^ engine
]
