Class {
	#name : #SSAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #running }
SSAssertionTest >> setUp [
	SSGeneratorInvariant resetNumTest
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
	profile := SSGenerator
		profile: [ SFoo new
				returnString;
				returnFloat ]
		onClass: SFoo.
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
	self assert: invariants size equals: 4.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SStringAssertion.
			SComparisonAssertion.
			SCollectionSizeAssertion}
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
	profile := SSGenerator profile: [ SFoo score: #(2 4) ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 5.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SCollectionTypeSimilarityAssertion.
			SPrimitiveAssertion.
			SComparisonAssertion.
			SStringAssertion}.
	profile := SSGenerator profile: [ SFoo score: #() ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 4.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SPrimitiveAssertion.
			SComparisonAssertion.
			SStringAssertion}
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsStack [
	| profile testCase invariants |
	profile := SSGenerator profile: [ Stack new ] onClass: Stack.
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
	profile := SSGenerator
		profile: [ Stack new
				push: 1;
				push: 3;
				pop;
				yourself ]
		onClass: Stack.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	invariants := testCase generateInvariants.
	"invariants is empty if the compiled method has failed"
	self deny: invariants isEmpty.
	self assert: invariants size equals: 8.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SCollectionTypeSimilarityAssertion.
			SStringAssertion.
			SComparisonAssertion.
			SInspectorAssertion.
			SPrimitiveAssertion.
			SComparisonAssertion.
			SPrimitiveAssertion}
]

{ #category : #tests }
SSAssertionTest >> testGeneratePrimitiveAssertions [
	| profile testCase invariants |
	profile := SSGenerator
		profile: [ Stack new
				push: 10;
				yourself ]
		onClass: Stack.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SComparisonAssertion.
			SStringAssertion.}.
	profile := SSGenerator
		profile: [ SFoo new return: 'hello World' ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 5.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SCollectionSizeAssertion.
			SCollectionTypeSimilarityAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	profile := SSGenerator
		profile: [ SFoo new return: 2.34 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	profile := SSGenerator
		profile: [ SFoo new return: true ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	invariants := testCase generateInvariants.
	self assert: invariants size >= 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SStringAssertion.
			SComparisonAssertion}
]

{ #category : #tests }
SSAssertionTest >> testInvariantsSStackRandomlyInitialized [
	| profile testCase invariants |
	profile := SSGenerator
		profile: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		onClass: SStack.
	testCase := STestCase seed: profile.
	testCase generateStatements: 15.
	"self halt."
	invariants := testCase generateInvariants.
	self assert: invariants isNotNil.
	self deny: invariants isEmpty.
	profile := SSGenerator
		profile: [ (SStack newStackWith: {'abcd' . 'efg' . 'hij' . 'klmn'})
				push: 'opqr';
				pop;
				top ]
		onClass: SStack.
	testCase := STestCase seed: profile.
	testCase generateStatements: 15.
	invariants := testCase generateInvariants.
	self assert: invariants isNotNil.
	self deny: invariants isEmpty
]
