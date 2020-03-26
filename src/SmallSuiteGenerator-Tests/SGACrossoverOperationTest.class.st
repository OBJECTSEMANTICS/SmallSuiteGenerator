Class {
	#name : #SGACrossoverOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'mutationOperation',
		'operation',
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #tests }
SGACrossoverOperationTest >> crossOver: listTestCase [
	| offSprings offSpring1 offSpring2 |
	self assert: listTestCase size >= 2.
	offSprings := operation
		crossover: listTestCase first
		with: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 validReferences.
	self assert: offSpring2 validReferences.
]

{ #category : #tests }
SGACrossoverOperationTest >> crossOverWithMutation: listTestCase [
	| offSprings offSpring1 offSpring2 |
	self assert: listTestCase size >= 2.
	self assert: listTestCase first validReferences.
	self assert: listTestCase second validReferences.
	offSpring1 := mutationOperation mutate: listTestCase first.
	offSpring2 := mutationOperation mutate: listTestCase second.
	offSprings := operation crossover: offSpring1 with: offSpring2.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	offSpring1 := mutationOperation mutate: offSpring1.
	offSpring2 := mutationOperation mutate: offSpring2.
	offSprings := operation crossover: offSpring1 with: offSpring2.
	self assert: offSpring1 validReferences.
	self assert: offSpring2 validReferences
]

{ #category : #running }
SGACrossoverOperationTest >> setUp [
	super setUp.
	operation := SGACrossoverOperation new randomGenerator: SPlatform newRandomGenerator.
	mutationOperation := SGAMutationOperation new
		randomGenerator: SPlatform newRandomGenerator.
	utility := SUtilityTypeInfo new
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToSStack [
	self crossOver: utility testSuiteSStack .
	self crossOverWithMutation: utility testSuiteSStack 
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToSStudent [
	self crossOver: utility testSuiteSStudent 
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToSStudent2 [
	self crossOver: utility testSuiteSStudentManual.
	self crossOverWithMutation: utility testSuiteSStudentManual
]
