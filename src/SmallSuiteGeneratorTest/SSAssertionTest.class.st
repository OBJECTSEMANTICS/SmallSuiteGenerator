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
	| generatorInfo testCase invariants |
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ Stack
						new;
						yourself ]
				onClass: Stack).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ SFoo new
						returnString;
						returnFloat ]
				onClass: SFoo).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 2.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SInspectorAssertion.
			SComparisonAssertion}.
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: [ Array new ] onClass: Array).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 4.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SStringAssertion.
			SComparisonAssertion.
			SCollectionSizeAssertion}
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsArray [
	| generatorInfo testCase invariants |
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: [ SFoo score: #(2 4) ] onClass: SFoo).
	testCase := STestCase seed: generatorInfo.
	testCase addPrimitive.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 5.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SCollectionTypeSimilarityAssertion.
			SPrimitiveAssertion.
			SComparisonAssertion.
			SStringAssertion}.
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: [ SFoo score: #() ] onClass: SFoo).
	testCase := STestCase seed: generatorInfo.
	testCase addPrimitive.
	invariants := testCase generateAssertionsUsing: {}.
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
	| generatorInfo testCase invariants |
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: [ Stack new ] onClass: Stack).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ Stack new
						push: 1;
						push: 3;
						pop;
						yourself ]
				onClass: Stack).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	testCase addMethod.
	invariants := testCase generateAssertionsUsing: {}.
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
SSAssertionTest >> testGenerateInvariantsWithSelectionSStack [
	| generatorInfo testCase invariants selectedInvariants |
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: [ SStack new ] onClass: Stack).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	selectedInvariants := {SCollectionSizeAssertion}.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	self assert: invariants size equals: 1.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements: selectedInvariants.
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ Stack new
						push: 1;
						push: 'hello';
						pop;
						yourself ]
				onClass: Stack).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	testCase addMethod.
	selectedInvariants := {SStringAssertion.
	SPrimitiveAssertion.
	SInspectorAssertion.
	SCollectionTypeSimilarityAssertion}.
	self
		should: [ testCase generateAssertionsUsing: selectedInvariants ]
		raise: Error.
	selectedInvariants := {SStringAssertion.
	SPrimitiveAssertion.
	SCollectionTypeSimilarityAssertion}.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	"invariants is empty if the compiled method has failed"
	self deny: invariants isEmpty.
	self assert: invariants size equals: 1.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements: {SStringAssertion}
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsWithSelectionSStudent [
	| generatorInfo testCase invariants selectedInvariants classesInvariants |
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ (SStudent name: 'Ann' with: -34.234) nickname ]
				onClass: SStudent).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	testCase addMethod.
	selectedInvariants := {SCollectionSizeAssertion}.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	self
		assert:
			(invariants isEmpty
				or: [ invariants size = 1
						and: [ invariants first className = 'SCollectionSizeAssertion' ] ]).
	selectedInvariants := {SCollectionSizeAssertion.
	SStringAssertion.
	SComparisonAssertion}.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	classesInvariants := invariants collect: [ :i | i class ].
	self
		assert:
			((classesInvariants includesAll: selectedInvariants)
				or: [ classesInvariants includesAny: selectedInvariants ]).
	selectedInvariants := {SComparisonAssertion.
	SInspectorAssertion}.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements: selectedInvariants.
	invariants := testCase generateAssertionsUsing: {}.
	self
		assert:
			((invariants collect: [ :i | i class ])
				includesAll:
					{SComparisonAssertion.
					SInspectorAssertion})
]

{ #category : #tests }
SSAssertionTest >> testGeneratePrimitiveAssertions [
	| generatorInfo testCase invariants |
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ Stack new
						push: 10;
						yourself ]
				onClass: Stack).
	testCase := STestCase seed: generatorInfo.
	testCase addPrimitive.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SComparisonAssertion.
			SStringAssertion}.
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator profile: [ SFoo new return: 'hello World' ] onClass: SFoo).
	testCase := STestCase seed: generatorInfo.
	testCase addPrimitive.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 5.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SCollectionSizeAssertion.
			SCollectionTypeSimilarityAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: [ SFoo new return: 2.34 ] onClass: SFoo).
	testCase := STestCase seed: generatorInfo.
	testCase addPrimitive.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	generatorInfo := STypeInfo
		typeInfo: (SSGenerator profile: [ SFoo new return: true ] onClass: SFoo).
	testCase := STestCase seed: generatorInfo.
	testCase addPrimitive.
	invariants := testCase generateAssertionsUsing: {}.
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
	| generatorInfo testCase invariants |
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ (SStack newStackWith: {2 . 4 . 6 . 1})
						push: 8;
						pop;
						top ]
				onClass: SStack).
	testCase := STestCase seed: generatorInfo.
	testCase generateStatements: 15.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants isNotNil.
	self deny: invariants isEmpty.
	generatorInfo := STypeInfo
		typeInfo:
			(SSGenerator
				profile: [ (SStack newStackWith: {'abcd' . 'efg' . 'hij' . 'klmn'})
						push: 'opqr';
						pop;
						top ]
				onClass: SStack).
	testCase := STestCase seed: generatorInfo.
	testCase generateStatements: 15.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants isNotNil.
	self deny: invariants isEmpty
]
