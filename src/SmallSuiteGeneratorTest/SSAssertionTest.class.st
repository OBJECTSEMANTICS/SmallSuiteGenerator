Class {
	#name : #SSAssertionTest,
	#superclass : #TestCase,
	#category : #SmallSuiteGeneratorTest
}

{ #category : #running }
SSAssertionTest >> setUp [ 
	SStatement reset.
	SSGeneratorInvariant resetNumTest.
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsArray [
	| profile testCase invariants |
	profile := SSGenerator
		profile: [ (SStudent score: #(2 4)) ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 2.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: {SCollectionSizeAssertion. SCollectionTypeSimilarityAssertion }.
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsScalar [
	| profile testCase invariants |
	profile := SSGenerator
		profile: [ Array with: 2 with: 6]
		onClass: Array.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 1.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: {SCollectionSizeAssertion}.
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsStack [
	| profile testCase invariants |
	profile := SSGenerator
		profile: [ Stack new push: 1; yourself. ]
		onClass: Stack.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 2.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: {SCollectionSizeAssertion. SCollectionTypeSimilarityAssertion }.
]
