Class {
	#name : #SGAMutationOperationTest,
	#superclass : #SGAOperationTest,
	#category : #'SmallSuiteGeneratorTest-GeneticAlgorithm'
}

{ #category : #running }
SGAMutationOperationTest >> setUp [
	super setUp.
	operation := SGAMutationOperation new random: Random new.
]

{ #category : #tests }
SGAMutationOperationTest >> testMutation [
	| typeInfo testCase mutatedTestCase |
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					{{(#push:
						->
							{#SmallInteger.
							{#SmallInteger}.
							false}).
					(#pop
						->
							{#SmallInteger.
							{}.
							false}).
					(#top
						->
							{#SmallInteger.
							{}.
							false})}.
					{(#newStackWith:
						->
							{#SStack.
							{#Array}.
							false})}}.
	typeInfo
		scalar: #SmallInteger with: {8};
		scalar: #Array with: {#(2 4 6 1)}.
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 30.
	testCase generateStatements.self halt.
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase hasValidDependencies.
	self assert: mutatedTestCase hasUniqueStatements
]

{ #category : #tests }
SGAMutationOperationTest >> testMutationSSteacher [
	| generatorInfo testCase mutatedTestCase |
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ (SSTeacher name: 'Ann' with: 34)
						name;
						nickname;
						yearsWorkExperience;
						idTeacher;
						id ]
				onClass: SSTeacher).
	testCase := STestCase seed: generatorInfo.
	testCase generateStatements.
	mutatedTestCase := operation mutate: testCase.
	mutatedTestCase := operation mutate: mutatedTestCase.
	self assert: mutatedTestCase hasValidDependencies.
	self assert: mutatedTestCase hasUniqueStatements
]
