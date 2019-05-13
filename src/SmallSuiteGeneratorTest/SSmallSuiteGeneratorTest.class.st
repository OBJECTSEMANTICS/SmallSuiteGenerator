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
SSmallSuiteGeneratorTest >> testGenerateTestsSStack [
	|  prevFitness postFitness |
	smallSuiteGenerator
		generateTestsOf: [ (SStack newStackWith: {1 . 5 . 3 . 2})
				pop;
				top;
				push: 4 ]
		blockOnClass: SStack.
	self assert: smallSuiteGenerator engine populationSize equals: 30.
	self assert:smallSuiteGenerator  engine logs size equals: 15.	"numberOfGenerations"
	prevFitness := smallSuiteGenerator engine logs first fittest fitness.
	postFitness := (smallSuiteGenerator engine logs at: 7) fittest fitness.
	self
		assert:
			(prevFitness at: 'methodCoverage')
				<= (postFitness at: 'methodCoverage').
	self
		assert:
			(prevFitness at: 'statementCoverage')
				<= (postFitness at: 'statementCoverage').
	prevFitness := postFitness.
	postFitness := smallSuiteGenerator engine logs last fittest fitness.
	self
		assert:
			(prevFitness at: 'methodCoverage')
				<= (postFitness at: 'methodCoverage').
	self
		assert:
			(prevFitness at: 'statementCoverage')
				<= (postFitness at: 'statementCoverage')
]
