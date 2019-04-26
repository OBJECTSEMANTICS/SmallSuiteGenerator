Class {
	#name : #SGAEngineTest,
	#superclass : #TestCase,
	#instVars : [
		'engine'
	],
	#category : #'SmallSuiteGeneratorTest-GeneticAlgorithm'
}

{ #category : #tests }
SGAEngineTest >> runOnClass: aClass withBlock: aBlock ofPopulationSize: populationSize and: numStatements [
	engine
		populationSize: populationSize;
		numberOfStatements: numStatements;
		blockToExecute: aBlock;
		generatorProfiler:
				[ :blockToExecute | SSGenerator profile: blockToExecute onClass: aClass];
		coverageProfiler: [ :blockToExecute | 
			SBProfiler new
				profileInstrumented: blockToExecute onClass: aClass;
				yourself ];
		fitnessBlock: [ :coverageProfiler | 
			[ :testCase | 
			SCalculatorCoverage
				calculateCoverageOf: testCase
				using: coverageProfiler ] ];
		run.
]

{ #category : #tests }
SGAEngineTest >> runOnPackagesMatching: regex withBlock: aBlock ofPopulationSize: populationSize and: numStatements [
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
		run
]

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

{ #category : #'tests-class fitness' }
SGAEngineTest >> testExampleRTAMItemOnClass [
	| fitness |
	self
		runOnClass: RTAMItem
		withBlock: [ RTAMItem new
				itemName: 'Bonus Card';
				row: 'France';
				column: 'Customer Relationship';
				color: Color lightGreen ]
		ofPopulationSize: 30
		and: 10.
	"7.14 = (1/14) * 100"
	"31.58 = (6/19) * 100"
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 7.14.
	self assert: (fitness at: 'statementCoverage') >= 31.58.
	"35.71 = (4/14) * 100"
	"52.63 = (10/19) * 100"
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') equals: 35.71.
	self assert: (fitness at: 'statementCoverage') equals: 52.63
]

{ #category : #'tests-packages fitness' }
SGAEngineTest >> testExampleRTAMItemOnPackage [
	| fitnessFirst fitnessLast |
	self runOnPackagesMatching: 'Roassal2' withBlock: [ RTAMItem new
				itemName: 'Bonus Card';
				row: 'France';
				column: 'Customer Relationship';
				color: Color lightGreen ] ofPopulationSize: 30 and: 10. 
	fitnessFirst := engine logs first fittestTestCase fitness.
	fitnessLast := engine logs last fittestTestCase fitness.
	self
		assert:
			(fitnessFirst at: 'methodCoverage')
				<= (fitnessLast at: 'methodCoverage').
	self
		assert:
			(fitnessFirst at: 'statementCoverage')
				<= (fitnessLast at: 'statementCoverage')
]

{ #category : #'tests-class fitness' }
SGAEngineTest >> testExampleRTBorderAttachPointOnClass [
	| fitness |
	self
		runOnClass: RTBorderAttachPoint
		withBlock: [ RTBorderAttachPoint instance offset: 4 ]
		ofPopulationSize: 30
		and: 10.
	"At least the constructor must be initialized"
	"12.5 = (1/8) * 100"
	"6.45 = (2/31) * 100"
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 12.5.
	self assert: (fitness at: 'statementCoverage') >= 6.45.
	"25 = (2/8) * 100 round: 2"
	"9.68 = (3/31) * 100 round: 2"
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') equals: 25.
	self assert: (fitness at: 'statementCoverage') equals: 9.68
]

{ #category : #'tests-packages fitness' }
SGAEngineTest >> testExampleRTBorderAttachPointPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ RTBorderAttachPoint instance offset: 4 ]
		ofPopulationSize: 30
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
				<= (fitnessLast at: 'statementCoverage')
]

{ #category : #'tests-class fitness' }
SGAEngineTest >> testExampleRTBoxOnClass [
	| fitness |
	self
		runOnClass: RTBox
		withBlock: [ RTBox new
				defaultWidth;
				borderStyle ]
		ofPopulationSize: 30
		and: 10.
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') equals: 20.
	self assert: (fitness at: 'statementCoverage') equals: 22.22.
	"20 = (1/5) * 100"
	"22.22 = (2/9) * 100"
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') equals: 20.
	self assert: (fitness at: 'statementCoverage') equals: 22.22
]

{ #category : #'tests-packages fitness' }
SGAEngineTest >> testExampleRTBoxOnPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ RTBox new
				defaultWidth;
				borderStyle ]
		ofPopulationSize: 30
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
				<= (fitnessLast at: 'statementCoverage')
]

{ #category : #'tests-class fitness' }
SGAEngineTest >> testExampleRTDirectedLineOnClass [
	| fitness |
	self
		runOnClass: RTDirectedLine
		withBlock: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		ofPopulationSize: 30
		and: 10.
		"20 = (1/5) * 100 round: 2"
	"18.18 = (2/11) * 100 round: 2"
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 20.
	self assert: (fitness at: 'statementCoverage') >= 18.18.
		"60 = (3/5) * 100 round: 2"
	"54.55 = (6/11) * 100 round: 2"
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') equals: 60.
	self assert: (fitness at: 'statementCoverage') equals: 54.55
]

{ #category : #'tests-packages fitness' }
SGAEngineTest >> testExampleRTDirectedLineOnPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ RTDirectedLine instance
				pointsFrom: 1 @ 3 To: 3 @ 5;
				offset: 6.5 ]
		ofPopulationSize: 30
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
				<= (fitnessLast at: 'statementCoverage')
]

{ #category : #'tests-class fitness' }
SGAEngineTest >> testExampleRTLineSegmentOnClass [
	| fitness |
	self
		runOnClass: RTLineSegment
		withBlock: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		ofPopulationSize: 30
		and: 10.
	"2.94 = (1/34) * 100 round: 2"
	"2.88 = (3/104) * 100 round: 2"
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 2.94.
	self assert: (fitness at: 'statementCoverage') >= 2.88.
		"23.53 = (8/34) * 100 round: 2"
	"13.46 = (14/104) * 100 round: 2"
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 23.53.
	self assert: (fitness at: 'statementCoverage') >= 13.46
]

{ #category : #'tests-packages fitness' }
SGAEngineTest >> testExampleRTLineSegmentOnPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'Roassal2-Cor*'
		withBlock: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
				angleInDeg;
				angleInRad;
				cotan;
				bottom ]
		ofPopulationSize: 30
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
				<= (fitnessLast at: 'statementCoverage')
]

{ #category : #'tests-class fitness' }
SGAEngineTest >> testExampleSSTeacherOnClass [
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
	self assert: (fitness at: 'statementCoverage') >= 87.5
]

{ #category : #'tests-packages fitness' }
SGAEngineTest >> testExampleSSTeacherOnPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'SmallSuiteExamp*'
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id  ]
		ofPopulationSize: 30
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
				<= (fitnessLast at: 'statementCoverage')
]

{ #category : #'tests-class fitness' }
SGAEngineTest >> testExampleSStackOnClass [
	| fitness |
	self
		runOnClass: SStack
		withBlock: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		ofPopulationSize: 30
		and: 10.
	"14.28 = (1/7) * 100 round: 2"
	"21.05 = (4/19) * 100 round: 2"
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 14.28.
	self assert: (fitness at: 'statementCoverage') >= 21.05.
	"57.14 = (4/7) * 100 round: 2"
	"73.68 = (14/19) * 100 round: 2"
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 57.14.
	self assert: (fitness at: 'statementCoverage') >= 73.68
]

{ #category : #'tests-packages fitness' }
SGAEngineTest >> testExampleSStackOnPackage [
	| fitnessFirst fitnessLast |
	self runOnPackagesMatching: 'SmallSuiteExamp*' withBlock: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ] ofPopulationSize: 30 and: 10.
	fitnessFirst := engine logs first fittestTestCase fitness.
	fitnessLast := engine logs last fittestTestCase fitness.
	self
		assert:
			(fitnessFirst at: 'methodCoverage')
				<= (fitnessLast at: 'methodCoverage').
	self
		assert:
			(fitnessFirst at: 'statementCoverage')
				<= (fitnessLast at: 'statementCoverage')
]

{ #category : #'tests-class fitness' }
SGAEngineTest >> testExampleSStudentOnClass [
	| fitness |
	self
		runOnClass: SStudent
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		ofPopulationSize: 30
		and: 10.
	fitness := engine logs first fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') >= 20.
	self assert: (fitness at: 'statementCoverage') >= 37.5.
	fitness := engine logs last fittestTestCase fitness.
	self assert: (fitness at: 'methodCoverage') equals: 100.
	self assert: (fitness at: 'statementCoverage') equals: 100
]

{ #category : #'tests-packages fitness' }
SGAEngineTest >> testExampleSStudentOnPackage [
	| fitnessFirst fitnessLast |
	self
		runOnPackagesMatching: 'SmallSuiteExamp*'
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		ofPopulationSize: 30
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
				<= (fitnessLast at: 'statementCoverage')
]
