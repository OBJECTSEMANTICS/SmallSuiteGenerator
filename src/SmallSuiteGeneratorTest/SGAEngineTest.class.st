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
SGAEngineTest >> testExampleStackOnClass [
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
				calculateCoverage: testCase
				using: coverageProfiler ] ];
		run.
	self
		assertCollection: engine logs first fittestTestCase fitness associations
		hasSameElements:
			{('methodCoverage' -> 0.54).
			('statementCoverage' -> 0.4)}.
	self
		assertCollection: (engine logs at: 10) fittestTestCase fitness associations
		hasSameElements:
			{('methodCoverage' -> 0.54).
			('statementCoverage' -> 0.4)}
]
