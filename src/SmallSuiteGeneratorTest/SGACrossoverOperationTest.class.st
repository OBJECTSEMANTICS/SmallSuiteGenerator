Class {
	#name : #SGACrossoverOperationTest,
	#superclass : #SGAOperationTest,
	#instVars : [
		'mutationOperation'
	],
	#category : #'SmallSuiteGeneratorTest-GeneticAlgorithm'
}

{ #category : #running }
SGACrossoverOperationTest >> setUp [
	super setUp.
	operation := SGACrossoverOperation new.
	mutationOperation := SGAMutationOperation new random: Random new
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOver: listTestCase [
	| offSprings offSpring1 offSpring2 |
	self assert: listTestCase size >= 2.
	offSprings := operation
		crossover: listTestCase first
		with: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 hasValidDependencies.
	self assert: offSpring1 hasUniqueStatements.
	self assert: offSpring2 hasValidDependencies.
	self assert: offSpring2 hasUniqueStatements
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToRTAMItem [
	self testCrossOver: SUtilityTest listTestCaseRTAMItem shuffle.
	self testCrossOverWithMutation: SUtilityTest listTestCaseRTAMItem shuffle.
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToRTBorderAttachPoint [
	self
		testCrossOver: SUtilityTest listTestCaseRTBorderAttachPoint shuffle
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToRTBox [
	self testCrossOver: SUtilityTest listTestCaseRTBox shuffle
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToRTDirectedLine [
	self testCrossOver: SUtilityTest listTestCaseRTDirectedLine shuffle
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToRTLineSegment [
	self testCrossOver: SUtilityTest listTestCaseRTLineSegment shuffle
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToSStack [
	self testCrossOver: SUtilityTest listTestCaseSStack shuffle.
	self
		testCrossOverWithMutation: SUtilityTest listTestCaseSStack shuffle.
	"self
		testCrossOverWithMutation2: SUtilityTest listTestCaseSStack shuffle"
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToSStudent [
	self testCrossOver: SUtilityTest listTestCaseSStudent shuffle
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverWithMutation2: listTestCase [
	| offSprings offSpring1 offSpring2 |
	self assert: listTestCase size >= 2.
	offSpring1 := mutationOperation mutate: listTestCase first.
	offSpring2 := mutationOperation mutate: listTestCase second.
	offSprings := operation crossover: offSpring1 with: offSpring2.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	offSpring1 := mutationOperation mutate: offSpring1.
	offSpring2 := mutationOperation mutate: offSpring2.
	offSprings := operation crossover: offSpring1 with: offSpring2.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 hasValidDependencies.
	self assert: offSpring1 hasUniqueStatements.
	self assert: offSpring2 hasValidDependencies.
	self assert: offSpring2 hasUniqueStatements
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverWithMutation: listTestCase [
	| offSprings offSpring1 offSpring2 |
	self assert: listTestCase size >= 2.
	offSpring1 := mutationOperation mutate: listTestCase first.
	offSpring2 := mutationOperation mutate: listTestCase second.
	offSprings := operation crossover: offSpring1 with: offSpring2.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	offSpring1 := mutationOperation mutate: listTestCase first.
	offSpring2 := mutationOperation mutate: listTestCase second.
	offSprings := operation crossover: offSpring1 with: offSpring2.
	self assert: offSpring1 hasValidDependencies.
	self assert: offSpring1 hasUniqueStatements.
	self assert: offSpring2 hasValidDependencies.
	self assert: offSpring2 hasUniqueStatements
]
