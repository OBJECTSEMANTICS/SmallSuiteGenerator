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
SGAEngineTest >> testExampleSStudentOnClass [
	| fitness |
	engine
		populationSize: 30;
		numberOfStatements: 10;
		blockToExecute: [ (SStudent name: 'Ann' with: 34)
						age: 34;
						identifier;
						nickname: 'Ann34';
						fullIdentifier ];
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
	self halt.
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 57.14.
	self assert: (fitness at: 'statementCoverage') >= 73.68.
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 57.14.
	self assert: (fitness at: 'statementCoverage') >= 84.21
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
		run.self halt.
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 57.14.
	self assert: (fitness at: 'statementCoverage') >= 73.68.
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 57.14.
	self assert: (fitness at: 'statementCoverage') >= 84.21
]
