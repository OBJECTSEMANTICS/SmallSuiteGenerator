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
	operation := SGAMutationOperation new random: Random new.
	utility := SUtilityTypeInfo new
]

{ #category : #tests }
SGAMutationOperationTest >> testMutation [
	| testCase mutatedTestCase |
	testCase := SSTestCase
		with:
			(STypeInfo new
				type:
					#SStack
						->
							(Array
								with:
									(Array
										with: #push: -> #(#SStack #SmallInteger #(#SmallInteger) false)
										with: #pop -> #(#SStack #SmallInteger #() false)
										with: #top -> #(#SStack #SmallInteger #() false))
								with: (Array with: #newStackWith: -> #(#SStack #SStack #(#Array) false)));
				scalar: #SmallInteger with: #(8);
				scalar: #Array with: #(#(2 4 6 1))).
	testCase numMaxStatements: 30.
	self should: [ testCase generateStatements ] raise: SError.
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
	testCase := SSTestCase with: typeInfo.
	testCase addTargetClassName: #SSTeacher;
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
