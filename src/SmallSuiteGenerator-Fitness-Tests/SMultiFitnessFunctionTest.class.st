Class {
	#name : #SMultiFitnessFunctionTest,
	#superclass : #TestCase,
	#instVars : [
		'function',
		'utility',
		'fitnessFunctions'
	],
	#category : #'SmallSuiteGenerator-Fitness-Tests'
}

{ #category : #running }
SMultiFitnessFunctionTest >> setUp [
	function := SMultiFitnessFunction.
	function clean.
	fitnessFunctions := Array
		with: SMethodCoverage
		with: SStatementCoverage.
	utility := SUtilityTypeInfo new
]

{ #category : #running }
SMultiFitnessFunctionTest >> tearDown [
	fitnessFunctions do: #clean.
	function
		clean;
		reset.
	super tearDown
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testComputeFitnessOnFactoryMessage [
	| aTestCase res |
	aTestCase := SSTestCase with: utility typeInfoSFoo1.
	aTestCase addFactoryMessage.
	function
		addFitnessFunction:
			(SMethodCoverage
				coverageOf: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onClass: SFoo);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	res := (function computeFitness: aTestCase) values.
	self assertCollection: res hasSameElements: #(33.33 28.57)
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testComputeFitnessOnFieldAccessMessage [
	| aTestCase res |
	aTestCase := SSTestCase with: utility typeInfoSFoo1.
	aTestCase addFieldAccessMessage: #score from: #SFoo.
	function
		addFitnessFunction:
			(SMethodCoverage
				coverageOf: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onClass: SFoo);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	res := (function computeFitness: aTestCase) values.
	self assertCollection: res hasSameElements: #(44.44 35.71)
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testComputeFitnessOnLiteral [
	| aTestCase res |
	aTestCase := SSTestCase with: utility typeInfoSFoo1.
	aTestCase addLiteral.
	function
		addFitnessFunction:
			(SMethodCoverage
				coverageOf: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onClass: SFoo);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	res := (function computeFitness: aTestCase) values.
	self assertCollection: res hasSameElements: #(0 0)
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testComputeFitnessOnMessage [
	| aTestCase res |
	aTestCase := SSTestCase with: utility typeInfoSFoo1.
	aTestCase addMessage: #returnFloat from: #SFoo.
	function
		addFitnessFunction:
			(SMethodCoverage
				coverageOf: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onClass: SFoo);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	res := (function computeFitness: aTestCase) values.
	self assertCollection: res hasSameElements: #(44.44 42.86)
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testIsBetterThan [
	| testCase1 testCase2 functions |
	testCase1 := utility testSuiteSStudentManual second.
	testCase2 := utility testSuiteSStudentManual second.
	testCase2 addFieldAccessMessage: #scoreStudent from: #SStudent.
	function
		addFitnessFunction:
			(SMethodCoverage
				coverageOf: [ SStudent new
						scoreStudent: 4;
						idStudent ]
				onClass: SStudent);
		addFitnessFunction: (SStatementCoverage profiler: SMethodCoverage profiler).
	functions := function allFitnessFunction.
	testCase1 computeFitness: functions first.
	testCase1 computeFitness: functions second.
	testCase2 computeFitness: functions first.
	testCase2 computeFitness: functions second.
	self deny: (function is: testCase1 betterThan: testCase2).
	self assert: (function is: testCase2 betterThan: testCase1)
]