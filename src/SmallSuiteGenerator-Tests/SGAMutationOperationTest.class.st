Class {
	#name : #SGAMutationOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'operation',
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #running }
SGAMutationOperationTest >> setUp [
	super setUp.
	operation := SGAMutationOperation new randomGenerator: SConfiguration newRandomGenerator.
	utility := SUtilityTypeInfo new
]

{ #category : #tests }
SGAMutationOperationTest >> testMutation [
	| testCase mutatedTestCase |
	testCase := SSTestCaseForTest with: utility typeInfoSStack3.
	testCase numMaxStatements: 10.
	testCase
		addTargetClassName: #SStack;
		generateStatements.
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase validReferences
]

{ #category : #tests }
SGAMutationOperationTest >> testMutationSSteacher [
	| typeInfo testCase mutatedTestCase |
	typeInfo := utility typeInfoSSTeacher1.
	testCase := SSTestCaseForTest with: typeInfo.
	testCase
		addTargetClassName: #SSTeacher;
		generateStatements.
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase validReferences
]

{ #category : #tests }
SGAMutationOperationTest >> testMutationSStudentManual [
	| testCase mutatedTestCase testSuite |
	testSuite := utility testSuiteSStudentManual.
	testCase := testSuite first.
	"testCase generateStatements."
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase validReferences.
	testCase := testSuite second.
	"testCase generateStatements."
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase validReferences
]

{ #category : #tests }
SGAMutationOperationTest >> testMutationSStudentWithValidReferences [
	| testCase mutatedTestCase testSuite |
	testSuite := utility testSuiteSStudentManual.
	testCase := testSuite third.
	"testCase generateStatements."
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase validReferences.
	testCase := testSuite third.
	"testCase generateStatements."
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase validReferences
]
