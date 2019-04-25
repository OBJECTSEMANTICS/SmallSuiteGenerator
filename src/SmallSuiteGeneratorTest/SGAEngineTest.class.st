Class {
	#name : #SGAEngineTest,
	#superclass : #TestCase,
	#instVars : [
		'engine'
	],
	#category : #'SmallSuiteGeneratorTest-GeneticAlgorithm'
}

{ #category : #running }
SGAEngineTest >> setUp [ 
	engine := SGAEngine new.
]

{ #category : #running }
SGAEngineTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove
]

{ #category : #tests }
SGAEngineTest >> testExampleSSTeacherOnClass [
	| fitness |
	engine
		populationSize: 15;
		numberOfStatements: 10;
		blockToExecute: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id  ];
		generatorProfiler:
				[ :blockToExecute | SSGenerator profile: blockToExecute onClass: SSTeacher ];
		coverageProfiler: [ :blockToExecute | 
			SBProfiler new
				profileInstrumented: blockToExecute onClass: SSTeacher;
				yourself ];
		fitnessBlock: [ :coverageProfiler | 
			[ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ] ];
		run.
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 20.
	self assert: (fitness at: 'statementCoverage') >= 37.5.
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 100.
	self assert: (fitness at: 'statementCoverage') >= 100
]

{ #category : #tests }
SGAEngineTest >> testExampleSStudentOnClass [
	| fitness |
	engine
		populationSize: 15;
		numberOfStatements: 10;
		blockToExecute: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ];
		generatorProfiler:
				[ :blockToExecute | SSGenerator profile: blockToExecute onClass: SStudent ];
		coverageProfiler: [ :blockToExecute | 
			SBProfiler new
				profileInstrumented: blockToExecute onClass: SStudent;
				yourself ];
		fitnessBlock: [ :coverageProfiler | 
			[ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ] ];
		run.
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 20.
	self assert: (fitness at: 'statementCoverage') >= 37.5.
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 100.
	self assert: (fitness at: 'statementCoverage') >= 100
]

{ #category : #tests }
SGAEngineTest >> testExampleStackOnClass [
	| fitness |
	engine
		populationSize: 30;
		numberOfStatements: 10;
		blockToExecute: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ];
		generatorProfiler:
				[ :blockToExecute | SSGenerator profile: blockToExecute onClass: SStack ];
		coverageProfiler: [ :blockToExecute | 
			SBProfiler new
				profileInstrumented: blockToExecute onClass: SStack;
				yourself ];
		fitnessBlock: [ :coverageProfiler | 
			[ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ] ];
		run.
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 57.14.
	self assert: (fitness at: 'statementCoverage') >= 73.68.
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 57.14.
	self assert: (fitness at: 'statementCoverage') >= 84.21
]
