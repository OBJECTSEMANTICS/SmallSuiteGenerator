Class {
	#name : #SSAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #running }
SSAssertionTest >> setUp [ 
	SStatement reset.
	SSGeneratorInvariant resetNumTest.
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantCollections [
	| profile testCase invariants |
	profile := SSGenerator
		profile: [ Stack
				new;
				yourself ]
		onClass: Stack.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	profile := SSGenerator profile: [ SStudent new ] onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 2.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SInspectorAssertion.
			SComparisonAssertion}.
	profile := SSGenerator profile: [ Array new ] onClass: Array.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 5.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SStringAssertion.
			SComparisonAssertion.
			SInspectorAssertion.
			SCollectionSizeAssertion}.
	"profile := SSGenerator
		profile: [ OrderedCollection new ]
		onClass: OrderedCollection.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 4.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SInspectorAssertion.
			SStringAssertion.
			SComparisonAssertion}"
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
	self assert: invariants size equals: 6.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: {SCollectionSizeAssertion. SCollectionTypeSimilarityAssertion. SPrimitiveAssertion. SInspectorAssertion. SStringAssertion. SComparisonAssertion }.
	
	profile := SSGenerator
		profile: [ (SStudent score: #()) ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 5.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: {SCollectionSizeAssertion. SPrimitiveAssertion. SInspectorAssertion. SStringAssertion. SComparisonAssertion }.
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsStack [
	| profile testCase invariants |
	profile := SSGenerator
		profile: [ Stack new. ]
		onClass: Stack.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 3.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: {SCollectionSizeAssertion. SStringAssertion. SComparisonAssertion }.
	
	profile := SSGenerator
		profile: [ Stack new push: 1; yourself. ]
		onClass: Stack.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 9.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: {SCollectionSizeAssertion. SCollectionTypeSimilarityAssertion. SPrimitiveAssertion. SStringAssertion. SComparisonAssertion. SInspectorAssertion. SPrimitiveAssertion. SComparisonAssertion. SPrimitiveAssertion  }.
  
]

{ #category : #tests }
SSAssertionTest >> testGeneratePrimitiveAssertions [
	| profile testCase invariants |
	profile := SSGenerator
		profile: [ Stack new push: 10; yourself]
		onClass: Stack.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 4.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: { SPrimitiveAssertion. SComparisonAssertion. SStringAssertion. SInspectorAssertion }.
	
	profile := SSGenerator
		profile: [ SStudent new return: 'hello World' ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 6.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: { SPrimitiveAssertion. SCollectionSizeAssertion. SCollectionTypeSimilarityAssertion. SStringAssertion. SInspectorAssertion. SComparisonAssertion }.
	
	profile := SSGenerator
		profile: [ SStudent new return: 2.34 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 4.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: { SPrimitiveAssertion. SStringAssertion. SComparisonAssertion. SInspectorAssertion }.
	
	profile := SSGenerator
		profile: [ SStudent new return: true ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 3.
	self assertCollection: (invariants collect: [:i | i class]) hasSameElements: { SPrimitiveAssertion. SStringAssertion. SComparisonAssertion }.
]
