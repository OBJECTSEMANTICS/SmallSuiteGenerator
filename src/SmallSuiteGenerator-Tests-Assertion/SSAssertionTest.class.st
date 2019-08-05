Class {
	#name : #SSAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Assertion'
}

{ #category : #running }
SSAssertionTest >> setUp [
	SSGeneratorInvariant resetNumTest
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantCollections [
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new
		type:
			#Stack
				->
					{{}.
					{}}.
	"(SSGenerator
				profile: [ Stack
						new;
						yourself ]
				onClass: Stack)."
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#returnString
						->
							{#ByteString.
							{}.
							false}).
					(#returnFloat
						->
							{#SmallFloat64.
							{}.
							false})}.
					{}};
		scalar: #ByteString with: {'hello'};
		scalar: #SmallFloat64 with: {3.4}.
	"(SSGenerator
				profile: [ SFoo new
						returnString;
						returnFloat ]
				onClass: SFoo)"
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 2.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SInspectorAssertion.
			SComparisonAssertion}.
	typeInfo := STypeInfo new
		type:
			#Array
				->
					{{}.
					{}}.	"(SSGenerator profile: [ Array new ] onClass: Array)."
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
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
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new
		type:
			(#SFoo
				->
					{{(#score:
						->
							{#SFoo.
							{#Array}.
							false}).
					(#initialize
						->
							{#SFoo.
							{}.
							false})}.
					{(#score:
						->
							{#SFoo.
							{#Array}.
							false})}});
		scalar: #Array with: {#(2 4)}.	"(SSGenerator profile: [ SFoo score: #(2 4) ] onClass: SFoo)."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
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
	typeInfo := STypeInfo new type: (#SFoo
				->
					{{(#score:
						->
							{#SFoo.
							{#Array}.
							false}).
					(#initialize
						->
							{#SFoo.
							{}.
							false})}.
					{(#score:
						->
							{#SFoo.
							{#Array}.
							false})}}); scalar: #Array with: {#()}.
	"	typeInfo: (SSGenerator profile: [ SFoo score: #() ] onClass: SFoo)."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
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
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new type: (#Stack -> {{}. {}}).
		"typeInfo: (SSGenerator profile: [ Stack new ] onClass: Stack)."
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SCollectionSizeAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	typeInfo := STypeInfo new type: (#Stack -> {{(#push: -> {#SmallInteger. {#SmallInteger}. false}). 
	(#pop -> {#SmallInteger. {}. false})}. {}}); scalar: #SmallInteger with: #(1 3).
		"typeInfo:
			(SSGenerator
				profile: [ Stack new
						push: 1;
						push: 3;
						pop;
						yourself ]
				onClass: Stack)."
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage .
	testCase addMessage.
	invariants := testCase generateAssertionsUsing: #().
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
	| typeInfo testCase invariants selectedInvariants |
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					{{}.
					{}}.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	selectedInvariants := {SCollectionSizeAssertion}.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	self assert: invariants size equals: 1.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements: selectedInvariants.
	"typeInfo := (SSGenerator
		profile: [ Stack new
				push: 1;
				push: 'hello';
				pop;
				yourself ]
		onClass: Stack) asTypeInfo."
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					{{(#push:
						->
							{#ByteString.
							{#ByteString}.
							false}).
					(#pop
						->
							{#ByteString.
							{}.
							false})}.
					{}};
		scalar: #SmallInteger with: #(1);
		scalar: #ByteString with: #('hello').
	(typeInfo typeOf: #push: from: #SStack) addType: #SmallInteger.
	(typeInfo typeOf: #pop from: #SStack) addType: #SmallInteger.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase addMessage.
	selectedInvariants := {SStringAssertion.
	SPrimitiveAssertion.
	SInspectorAssertion.
	SCollectionTypeSimilarityAssertion}.
	invariants := (testCase generateAssertionsUsing: selectedInvariants).
	"self assert: invariants size equals: 3."
	self
		assertCollection: (invariants collect: [ :i | i class ]) asSet
		hasSameElements:
			{SStringAssertion.
			SPrimitiveAssertion.
			SInspectorAssertion}.
	"self
		should: [ testCase generateAssertionsUsing: selectedInvariants ]
		raise: Error."
	selectedInvariants := {SStringAssertion.
	SPrimitiveAssertion.
	SCollectionTypeSimilarityAssertion}.
	invariants := (testCase generateAssertionsUsing: selectedInvariants)
		.
	"invariants is empty if the compiled method has failed"
	self deny: invariants isEmpty.
	"self assert: invariants size equals: 1."
	self
		assertCollection: (invariants collect: [ :i | i class ]) asSet
		hasSameElements:
			{SStringAssertion.
			SPrimitiveAssertion}
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsWithSelectionSStudent [
	| typeInfo testCase invariants selectedInvariants classesInvariants |
	"typeInfo := (SSGenerator
		profile: [ (SStudent name: 'Ann' with: -34.234) nickname ]
		onClass: SStudent) asTypeInfo."
	typeInfo := STypeInfo new type: #SStudent -> {{
		(#nickname -> {#ByteString. {}. false}).
		(#initialize -> {#SStudent. {}. false})
	}. {}}.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase addMessage.
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
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					{{ (#initialize -> {#SStack. {}. false}).
					(#push: -> {#SmallInteger. {#SmallInteger}. false})}.
					{}}; scalar: #SmallInteger with: {1}.
	"typeInfo := (SSGenerator
		profile: [ Stack new
				push: 10;
				yourself ]
		onClass: Stack) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SComparisonAssertion.
			SStringAssertion}.
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#initialize -> {#SFoo. {}. false}). 
					(#return: -> {#ByteString. {#ByteString}. false})}.
					{}}; scalar: #ByteString with: {'hello World'}.
	"typeInfo := (SSGenerator
		profile: [ SFoo new return: 'hello World' ]
		onClass: SFoo) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
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
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#initialize -> {#SFoo. {}. false}). 
					(#return: -> {#SmallFloat64. {#SmallFloat64}. false})}.
					{}}; scalar: #SmallFloat64 with: {2.34}.
	"typeInfo := (SSGenerator
		profile: [ SFoo new return: 2.34 ]
		onClass: SFoo) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			{SPrimitiveAssertion.
			SStringAssertion.
			SComparisonAssertion}.
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					{{(#initialize -> {#SFoo. {}. false}). 
					(#return: -> {#True. {#True}. false})}.
					{}}; scalar: #True with: {true}.
	"typeInfo := (SSGenerator
		profile: [ SFoo new return: true ]
		onClass: SFoo) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
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
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					{{(#initialize
						->
							{#SStack.
							{}.
							false}).
					(#push:
						->
							{#SmallInteger.
							{#SmallInteger}.
							false}).
					(#pop
						->
							{#SmallInteger.
							{}.
							false}).
					(#top
						->
							{#SmallInteger.
							{}.
							false})}.
					{(#newStackWith:
						->
							{#SStack.
							{#Array}.
							false})}};
		scalar: #Array with: {#(2 4 6 1)};
		scalar: #SmallInteger with: {8}.
	"typeInfo := (SSGenerator
		profile: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		onClass: SStack) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 15.
	testCase generateStatements.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants isNotNil.
	self deny: invariants isEmpty.
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					{{(#initialize
						->
							{#SStack.
							{}.
							false}).
					(#push:
						->
							{#ByteString.
							{#ByteString}.
							false}).
					(#pop
						->
							{#ByteString.
							{}.
							false}).
					(#top
						->
							{#ByteString.
							{}.
							false})}.
					{(#newStackWith:
						->
							{#SStack.
							{#Array}.
							false})}};
		scalar: #Array with: {#('abcd' 'efg' 'hij' 'klmn')};
		scalar: #ByteString with: {'opqr'}.
	"typeInfo := (SSGenerator
		profile: [ (SStack newStackWith: {'abcd' . 'efg' . 'hij' . 'klmn'})
				push: 'opqr';
				pop;
				top ]
		onClass: SStack) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 15.
	testCase generateStatements.
	invariants := testCase generateAssertionsUsing: {}.
	self assert: invariants isNotNil.
	self deny: invariants isEmpty
]
