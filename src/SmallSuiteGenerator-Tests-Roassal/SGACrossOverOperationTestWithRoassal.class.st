Class {
	#name : #SGACrossOverOperationTestWithRoassal,
	#superclass : #TestCase,
	#instVars : [
		'utility',
		'operation',
		'mutationOperation'
	],
	#category : #'SmallSuiteGenerator-Tests-Roassal'
}

{ #category : #running }
SGACrossOverOperationTestWithRoassal >> setUp [
	utility := SUtilityRoassal new.
	operation := SGACrossoverOperation new.
	mutationOperation := SGAMutationOperation new random: Random new
]

{ #category : #tests }
SGACrossOverOperationTestWithRoassal >> testCrossOver: listTestCase [
	| offSprings offSpring1 offSpring2 |
	self assert: listTestCase size >= 2.
	offSprings := operation
		crossover: listTestCase first
		with: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 validReferences .
	self assert: offSpring2 validReferences .
]

{ #category : #tests }
SGACrossOverOperationTestWithRoassal >> testCrossOverToRTAMItem [
	self testCrossOver: utility testSuiteRTAMItem.

	self testCrossOverWithMutation: utility testSuiteRTAMItem
]

{ #category : #tests }
SGACrossOverOperationTestWithRoassal >> testCrossOverToRTBorderAttachPoint [
	self testCrossOver: utility testSuiteRTBorderAttachPoint
]

{ #category : #tests }
SGACrossOverOperationTestWithRoassal >> testCrossOverToRTBox [
	self testCrossOver: utility testSuiteRTBox
]

{ #category : #tests }
SGACrossOverOperationTestWithRoassal >> testCrossOverToRTDirectedLine [
	self testCrossOver: utility testSuiteRTDirectedLine
]

{ #category : #tests }
SGACrossOverOperationTestWithRoassal >> testCrossOverToRTLineSegment [
	self testCrossOver: utility testSuiteRTLineSegment
]

{ #category : #tests }
SGACrossOverOperationTestWithRoassal >> testCrossOverWithMutation: listTestCase [
	| offSprings offSpring1 offSpring2 |
	self assert: listTestCase size >= 2.
	offSpring1 := mutationOperation mutate: listTestCase first.
	self assert: offSpring1 validReferences.
	offSpring2 := mutationOperation mutate: listTestCase second.
	self assert: offSpring2 validReferences.
	offSprings := operation crossover: offSpring1 with: offSpring2.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	offSpring1 := mutationOperation mutate: listTestCase first.
	offSpring2 := mutationOperation mutate: listTestCase second.
	offSprings := operation crossover: offSpring1 with: offSpring2.
	self assert: offSpring1 validReferences.
	self assert: offSpring2 validReferences
]
