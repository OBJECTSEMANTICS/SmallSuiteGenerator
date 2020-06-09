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
	SPlatform resetRandomGenerator.
	operation := SGAMutationOperation new.
	utility := SUtilityTypeInfo new
]

{ #category : #tests }
SGAMutationOperationTest >> testMutation [
	| testCase mutatedTestCase |
	testCase := SSTestCase with: utility typeInfoSStack3.
	testCase numMaxStatements: 10.
	testCase
		addTargetClassName: (self fullSymbolOf: #SStack);
		generateStatements.
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase validReferences
]

{ #category : #tests }
SGAMutationOperationTest >> testMutationSSteacher [
	| typeInfo testCase mutatedTestCase |
	typeInfo := utility typeInfoSSTeacher1.
	testCase := SSTestCase with: typeInfo.
	testCase addTargetClassName: (self fullSymbolOf: #SSTeacher);
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
