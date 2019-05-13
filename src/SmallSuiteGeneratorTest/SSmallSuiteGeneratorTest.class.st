Class {
	#name : #SSmallSuiteGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'smallSuiteGenerator'
	],
	#category : #'SmallSuiteGeneratorTest-Facade'
}

{ #category : #running }
SSmallSuiteGeneratorTest >> setUp [
	super setUp.
	SSmallSuiteGenerator resetInstance.
	smallSuiteGenerator := SSmallSuiteGenerator instance.
	SSGeneratorInvariant resetNumTest
]

{ #category : #running }
SSmallSuiteGeneratorTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove.
	super tearDown 
]

{ #category : #tests }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassSStack [
	|  prevFitness postFitness |
	smallSuiteGenerator
		generateTestsOf: [ (SStack newStackWith: {1 . 5 . 3 . 2})
				pop;
				top;
				push: 4 ]
		blockOnClass: SStack.
	smallSuiteGenerator runGeneration.
	self assert: smallSuiteGenerator engine populationSize equals: 30.
	self assert:smallSuiteGenerator  engine logs size equals: 15.	"numberOfGenerations"
	prevFitness := smallSuiteGenerator engine logs first fittestTestCase fitness.
	postFitness := (smallSuiteGenerator engine logs at: 7) fittestTestCase fitness.
	self
		assert:
			(prevFitness at: 'methodCoverage')
				<= (postFitness at: 'methodCoverage').
	self
		assert:
			(prevFitness at: 'statementCoverage')
				<= (postFitness at: 'statementCoverage').
	prevFitness := postFitness.
	postFitness := smallSuiteGenerator engine logs last fittestTestCase fitness.
	self
		assert:
			(prevFitness at: 'methodCoverage')
				<= (postFitness at: 'methodCoverage').
	self
		assert:
			(prevFitness at: 'statementCoverage')
				<= (postFitness at: 'statementCoverage')
]

{ #category : #tests }
SSmallSuiteGeneratorTest >> testGenerateTestsOnClassSStudent [
	|  prevFitness postFitness |
	smallSuiteGenerator
		generateTestsOf: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		blockOnClass: SStudent.
	smallSuiteGenerator runGeneration.
	self assert: smallSuiteGenerator engine populationSize equals: 30.
	self assert:smallSuiteGenerator  engine logs size equals: 15.	"numberOfGenerations"
	prevFitness := smallSuiteGenerator engine logs first fittestTestCase fitness.
	postFitness := (smallSuiteGenerator engine logs at: 7) fittestTestCase fitness.
	self
		assert:
			(prevFitness at: 'methodCoverage')
				<= (postFitness at: 'methodCoverage').
	self
		assert:
			(prevFitness at: 'statementCoverage')
				<= (postFitness at: 'statementCoverage').
	prevFitness := postFitness.
	postFitness := smallSuiteGenerator engine logs last fittestTestCase fitness.
	self
		assert:
			(prevFitness at: 'methodCoverage')
				<= (postFitness at: 'methodCoverage').
	self
		assert:
			(prevFitness at: 'statementCoverage')
				<= (postFitness at: 'statementCoverage')
]
