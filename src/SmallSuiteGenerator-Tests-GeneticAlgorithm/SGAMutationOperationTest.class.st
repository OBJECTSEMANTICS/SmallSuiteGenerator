Class {
	#name : #SGAMutationOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'operation',
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-GeneticAlgorithm'
}

{ #category : #running }
SGAMutationOperationTest >> setUp [
	super setUp.
	operation := SGAMutationOperation new random: Random new.
	utility := SUtilityTypeInfo new
]

{ #category : #tests }
SGAMutationOperationTest >> testMutation [
	| typeInfo testCase mutatedTestCase |
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					(Array with: (Array with: (#push:
						->
							#(#SmallInteger
							#(#SmallInteger)
							false)) with:
					(#pop
						->
							#(#SmallInteger
							#()
							false)) with:
					(#top
						->
							#(#SmallInteger
							#()
							false))) with: 
					(Array with: (#newStackWith:
						->
							#(#SStack
							#(#Array)
							false)))).
	typeInfo
		scalar: #SmallInteger with: #(8);
		scalar: #Array with: #(#(2 4 6 1)).
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 30.
	testCase generateStatements.
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase validReferences
]

{ #category : #tests }
SGAMutationOperationTest >> testMutationSSteacher [
	| typeInfo testCase mutatedTestCase |
	typeInfo := utility typeInfosSSTeacher first.
	testCase := SSTestCase with: typeInfo.
	testCase generateStatements.
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
	
testCase := testSuite  second.
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
	self halt.
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
