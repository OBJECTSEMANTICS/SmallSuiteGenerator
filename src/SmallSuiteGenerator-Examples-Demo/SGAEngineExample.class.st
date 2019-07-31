Class {
	#name : #SGAEngineExample,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
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
	| fitness |
	self
		runOnClass: SSTeacher
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		ofPopulationSize: 30
		numStatements: 15
		and: 10.
	"20 = (1/5) * 100"
	"37.5 = (3/8) * 100"
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 20.
	self assert: (fitness at: 'statementCoverage') >= 37.5.
	"80 = (4/5) * 100"
	"87.5 = (7/8) * 100"
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') equals: 80.
	self assert: (fitness at: 'statementCoverage') >= 87.5.
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSSTeacherOnPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'SmallSuiteExamp*'
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		ofPopulationSize: 30
		numStatements: 15
		and: 10.
	fitnessFirst := engine logs first fittestTestCase fitness.
	fitnessLast := engine logs last fittestTestCase fitness.
	self
		assert:
			(fitnessFirst at: 'methodCoverage')
				<= (fitnessLast at: 'methodCoverage').
	self
		assert:
			(fitnessFirst at: 'statementCoverage')
				<= (fitnessLast at: 'statementCoverage').
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSStackOnClass [
	| fitness |
	self
		runOnClass: SStack
		withBlock: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		ofPopulationSize: 30
		numStatements: 15
		and: 20.
	"14.28 = (1/7) * 100 round: 2"
	"21.05 = (4/19) * 100 round: 2"
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 14.28.
	self assert: (fitness at: 'statementCoverage') >= 21.05.
	"57.14 = (4/7) * 100 round: 2"
	"73.68 = (14/19) * 100 round: 2"
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 57.14.
	self assert: (fitness at: 'statementCoverage') >= 73.68.
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSStackOnPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'SmallSuiteExamp*'
		withBlock: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		ofPopulationSize: 30
		numStatements: 15
		and: 10.
	fitnessFirst := engine logs first fittestTestCase fitness.
	fitnessLast := engine logs last fittestTestCase fitness.
	self
		assert:
			(fitnessFirst at: 'methodCoverage')
				<= (fitnessLast at: 'methodCoverage').
	self
		assert:
			(fitnessFirst at: 'statementCoverage')
				<= (fitnessLast at: 'statementCoverage').
	self clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSStudentOnClass [
	| fitness |
	self
		runOnClass: SStudent
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		ofPopulationSize: 30
		numStatements: 15
		and: 10.
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 20.
	self assert: (fitness at: 'statementCoverage') >= 37.5.
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') equals: 100.
	self assert: (fitness at: 'statementCoverage') equals: 100.
	self clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSStudentOnPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'SmallSuiteExamp*'
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		ofPopulationSize: 30
		numStatements: 15
		and: 10.
	fitnessFirst := engine logs first fittestTestCase fitness.
	fitnessLast := engine logs last fittestTestCase fitness.
	self
		assert:
			(fitnessFirst at: 'methodCoverage')
				<= (fitnessLast at: 'methodCoverage').
	self
		assert:
			(fitnessFirst at: 'statementCoverage')
				<= (fitnessLast at: 'statementCoverage').
	self clean
]

{ #category : #actions }
SGAEngineExample >> runOnClass: aClass withBlock: aBlock ofPopulationSize: populationSize numStatements: numStatements and: numGenerations [
	engine := SGAEngine new.
	SSGeneratorInvariant resetNumTest.
	engine
		populationSize: populationSize;
		numberOfStatements: numStatements;
		blockToExecute: aBlock;
		generatorProfiler:
				[ :blockToExecute | SSGenerator profile: blockToExecute onClass: aClass ];
		coverageProfiler: [ :blockToExecute | 
			SBProfiler new
				profileInstrumented: blockToExecute onClass: aClass;
				yourself ];
		fitnessBlock: [ :coverageProfiler | 
			[ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ] ];
		endForMaxNumberOfGeneration: numGenerations;
		run
]

{ #category : #actions }
SGAEngineExample >> runOnPackagesMatching: regex withBlock: aBlock ofPopulationSize: populationSize numStatements: numStatements and: numGenerations [
	engine := SGAEngine new.
	SSGeneratorInvariant resetNumTest.
	engine
		populationSize: populationSize;
		numberOfStatements: numStatements;
		blockToExecute: aBlock;
		generatorProfiler:
				[ :blockToExecute | SSGenerator profile: blockToExecute onPackagesMatching: regex ];
		coverageProfiler: [ :blockToExecute | 
			SBProfiler new
				profileInstrumented: blockToExecute onPackagesMatching: regex;
				yourself ];
		fitnessBlock: [ :coverageProfiler | 
			[ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ] ];
		endForMaxNumberOfGeneration: numGenerations;
		run
]
