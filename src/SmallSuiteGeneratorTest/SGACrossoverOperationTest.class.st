Class {
	#name : #SGACrossoverOperationTest,
	#superclass : #SGAOperationTest,
	#category : #'SmallSuiteGeneratorTest-GeneticAlgorithm'
}

{ #category : #running }
SGACrossoverOperationTest >> setUp [
	super setUp.
	operation := SGACrossoverOperation new
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
	self assert: offSpring2 hasValidDependencies
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToRTAMItem [
	self testCrossOver: SUtilityTest listTestCaseRTAMItem shuffle
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
SGACrossoverOperationTest >> testCrossOverToSStudent [
	self testCrossOver: SUtilityTest listTestCaseStudent shuffle
]
