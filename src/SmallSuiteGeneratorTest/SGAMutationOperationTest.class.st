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
	| generatorInfo testCase mutatedTestCase |
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ (SStack newStackWith: {2 . 4 . 6 . 1})
						push: 8;
						pop;
						top ]
				onClass: SStack).
	testCase := STestCase seed: generatorInfo.
	testCase generateStatements.
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
