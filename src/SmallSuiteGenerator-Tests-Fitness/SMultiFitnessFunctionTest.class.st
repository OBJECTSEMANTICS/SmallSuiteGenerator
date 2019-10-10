Class {
	#name : #SMultiFitnessFunctionTest,
	#superclass : #TestCase,
	#instVars : [
		'function',
		'utility',
		'fitnessFunctions'
	],
	#category : #'SmallSuiteGenerator-Tests-Fitness'
}

{ #category : #running }
SMultiFitnessFunctionTest >> setUp [
	function := SMultiFitnessFunction.
	fitnessFunctions := Array
		with: SMethodCoverage
		with: SStatementCoverage.
	utility := SUtilityTypeInfo new
]

{ #category : #running }
SMultiFitnessFunctionTest >> tearDown [
	super tearDown.
	function reset
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testComputeFitnessOnFactoryMessage [
	| aTestCase res |
	aTestCase := SSTestCase with: utility typeInfosSFoo first.
	aTestCase addFactoryMessage.
	function
		isOnClass: true;
		inputData: (Array with: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ] with: SFoo);
		addFitnessFunction:
			SMethodCoverage
				;
		addFitnessFunction: SStatementCoverage.
	res := (function computeFitness: aTestCase) values.
	self assertCollection: res hasSameElements: #(33.33 28.57)
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testComputeFitnessOnFieldAccessMessage [
	| aTestCase res |
	aTestCase := SSTestCase with: utility typeInfosSFoo first.
	aTestCase addFieldAccessMessage: #score from: #SFoo.
	function
		isOnClass: true;
		inputData:
			(Array
				with: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				with: SFoo);
		addFitnessFunction: SMethodCoverage;
		addFitnessFunction: SStatementCoverage.
	res := (function computeFitness: aTestCase) values.
	self assertCollection: res hasSameElements: #(44.44 35.71)
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testComputeFitnessOnLiteral [
	| aTestCase res |
	aTestCase := SSTestCase with: utility typeInfosSFoo first.
	aTestCase addLiteral.
	function
		isOnClass: true;
		inputData: (Array with: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ] with: SFoo);
		addFitnessFunction:
			SMethodCoverage;
		addFitnessFunction: SStatementCoverage.
	res := (function computeFitness: aTestCase) values.
	self assertCollection: res hasSameElements: #(0 0)
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testComputeFitnessOnMessage [
	| aTestCase res |
	aTestCase := SSTestCase with: utility typeInfosSFoo first.
	aTestCase addMessage: #returnFloat from: #SFoo.
	function
		isOnClass: true;
		inputData: (Array with:
				[ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				with: SFoo);
		addFitnessFunction:
			SMethodCoverage;
			
		addFitnessFunction: SStatementCoverage.
	res := (function computeFitness: aTestCase) values.
	self assertCollection: res hasSameElements: #(44.44 42.86)
]

{ #category : #tests }
SMultiFitnessFunctionTest >> testIsBetterThan [
	| testCase1 testCase2 |
	testCase1 := utility testSuiteSStudentManual second.
	testCase2 := utility testSuiteSStudentManual second.
	testCase2 addFieldAccessMessage: #scoreStudent from: #SStudent.
	function
		isOnClass: true;
		inputData:
			(Array
				with: [ SStudent new
						scoreStudent: 4;
						idStudent ]
				with: SStudent);
		addFitnessFunction: SMethodCoverage;
		addFitnessFunction: SStatementCoverage.
	testCase1 computeFitness: function.
	testCase2 computeFitness: function.
	self deny: (function is: testCase1 betterThan: testCase2).
	self assert: (function is: testCase2 betterThan: testCase1)
]
