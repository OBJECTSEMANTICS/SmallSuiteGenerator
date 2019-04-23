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
		with: listTestCase second. self halt.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 hasValidDependencies.
	self assert: offSpring1 nextId equals: offSpring1 numberOfStatements.
	self
		assert: offSpring1 numberOfStatements
		equals: offSpring1 varNames asSet size.
	self assert: offSpring2 hasValidDependencies.
	self assert: offSpring2 nextId equals: offSpring2 numberOfStatements.
	self
		assert: offSpring2 numberOfStatements
		equals: offSpring2 varNames asSet size
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
SGACrossoverOperationTest >> testCrossOverToSStack [
	self testCrossOver: SUtilityTest listTestCaseSStack shuffle
]

{ #category : #tests }
SGACrossoverOperationTest >> testCrossOverToSStudent [
	self testCrossOver: SUtilityTest listTestCaseStudent shuffle
]
