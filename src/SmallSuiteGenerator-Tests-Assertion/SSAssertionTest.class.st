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
	typeInfo := STypeInfo new type: #Stack -> (Array with: #() with: #()).
	"(SSGenerator
				profile: [ Stack
						new;
						yourself ]
				onClass: Stack)."
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SCollectionSizeAssertion
				with: SStringAssertion
				with: SComparisonAssertion).
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #returnString -> #(#SFoo #ByteString #() false)
								with: #returnFloat -> #(#SFoo #SmallFloat64 #() false))
						with: #());
		scalar: #ByteString with: #('hello');
		scalar: #SmallFloat64 with: #(3.4).
	"(SSGenerator
				profile: [ SFoo new
						returnString;
						returnFloat ]
				onClass: SFoo)"
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 2.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements: (Array with: SInspectorAssertion with: SComparisonAssertion).
	typeInfo := STypeInfo new type: #Array -> (Array with: #() with: #()).	"(SSGenerator profile: [ Array new ] onClass: Array)."
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 4.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SPrimitiveAssertion
				with: SStringAssertion
				with: SComparisonAssertion
				with: SCollectionSizeAssertion)
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsArray [
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #score: -> #(#SFoo #SFoo #(#Array) false)
								with: #initialize -> #(#SFoo #SFoo #() false))
						with: (Array with: #score: -> #(#SFoo #SFoo #(#Array) false)));
		scalar: #Array with: #(#(2 4)).	"(SSGenerator profile: [ SFoo score: #(2 4) ] onClass: SFoo)."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 5.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SCollectionSizeAssertion
				with: SCollectionTypeSimilarityAssertion
				with: SPrimitiveAssertion
				with: SComparisonAssertion
				with: SStringAssertion).
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #score: -> #(#SFoo #SFoo #(#Array) false)
								with: #initialize -> #(#SFoo #SFoo #() false))
						with:
							(Array with: #score: -> #(#SFoo #SFoo #(#Array) false)));
		scalar: #Array with: #(#()).
	"	typeInfo: (SSGenerator profile: [ SFoo score: #() ] onClass: SFoo)."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 4.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SCollectionSizeAssertion
				with: SPrimitiveAssertion
				with: SComparisonAssertion
				with: SStringAssertion)
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsStack [
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new type: #Stack -> (Array with: #() with: #()).
	"typeInfo: (SSGenerator profile: [ Stack new ] onClass: Stack)."
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SCollectionSizeAssertion
				with: SStringAssertion
				with: SComparisonAssertion).
	typeInfo := STypeInfo new
		type:
			#Stack
				->
					(Array
						with:
							(Array
								with: #push: -> #(#Stack #SmallInteger #(#SmallInteger) false)
								with: #pop -> #(#Stack #SmallInteger #() false))
						with: #());
		scalar: #SmallInteger with: #(1 3).
	"typeInfo:
			(SSGenerator
				profile: [ Stack new
						push: 1;
						push: 3;
						pop;
						yourself ]
				onClass: Stack)."
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase addMessage.
	invariants := testCase generateAssertionsUsing: #().
	"invariants is empty if the compiled method has failed"
	self deny: invariants isEmpty.
	self assert: invariants size equals: 8.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(OrderedCollection new
				add: SCollectionSizeAssertion;
				add: SCollectionTypeSimilarityAssertion;
				add: SStringAssertion;
				add: SComparisonAssertion;
				add: SInspectorAssertion;
				add: SPrimitiveAssertion;
				add: SComparisonAssertion;
				add: SPrimitiveAssertion;
				yourself)
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsWithSelectionSStack [
	| typeInfo testCase invariants selectedInvariants |
	typeInfo := STypeInfo new
		type: #SStack -> (Array with: #() with: #()).
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	selectedInvariants := Array with: SCollectionSizeAssertion.
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
					(Array
						with:
							(Array
								with: #push: -> #(#SStack #ByteString #(#ByteString) false)
								with: #pop -> #(#SStack #ByteString #() false))
						with: #());
		scalar: #SmallInteger with: #(1);
		scalar: #ByteString with: #('hello').
	(typeInfo type: #push: from: #SStack) addType: #SmallInteger.
	(typeInfo type: #pop from: #SStack) addType: #SmallInteger.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase addMessage.
	selectedInvariants := Array
		with: SStringAssertion
		with: SPrimitiveAssertion
		with: SInspectorAssertion
		with: SCollectionTypeSimilarityAssertion.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	"self assert: invariants size equals: 3."
	self
		assertCollection: (invariants collect: [ :i | i class ]) asSet
		hasSameElements:
			(Array
				with: SStringAssertion
				with: SPrimitiveAssertion
				with: SInspectorAssertion).
	"self
		should: [ testCase generateAssertionsUsing: selectedInvariants ]
		raise: Error."
	selectedInvariants := Array
		with: SStringAssertion
		with: SPrimitiveAssertion
		with: SCollectionTypeSimilarityAssertion.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	"invariants is empty if the compiled method has failed"
	self deny: invariants isEmpty.
	"self assert: invariants size equals: 1."
	self
		assertCollection: (invariants collect: [ :i | i class ]) asSet
		hasSameElements: (Array with: SStringAssertion with: SPrimitiveAssertion)
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsWithSelectionSStudent [
	| typeInfo testCase invariants selectedInvariants classesInvariants |
	"typeInfo := (SSGenerator
		profile: [ (SStudent name: 'Ann' with: -34.234) nickname ]
		onClass: SStudent) asTypeInfo."
	typeInfo := STypeInfo new
		type:
			#SStudent
				->
					(Array
						with:
							(Array
								with: #nickname -> #(#SStudent #ByteString #() false)
								with: #initialize -> #(#SStudent #SStudent #() false))
						with: #()).
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase addMessage.
	selectedInvariants := Array with: SCollectionSizeAssertion.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	self
		assert:
			(invariants isEmpty
				or: [ invariants size = 1
						and: [ invariants first className = 'SCollectionSizeAssertion' ] ]).
	selectedInvariants := Array
		with: SCollectionSizeAssertion
		with: SStringAssertion
		with: SComparisonAssertion.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	classesInvariants := invariants collect: [ :i | i class ].
	self
		assert:
			((classesInvariants includesAll: selectedInvariants)
				or: [ classesInvariants includesAny: selectedInvariants ]).
	selectedInvariants := Array
		with: SComparisonAssertion
		with: SInspectorAssertion.
	invariants := testCase generateAssertionsUsing: selectedInvariants.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements: selectedInvariants.
	invariants := testCase generateAssertionsUsing: #().
	self
		assert:
			((invariants collect: [ :i | i class ])
				includesAll: (Array with: SComparisonAssertion with: SInspectorAssertion))
]

{ #category : #tests }
SSAssertionTest >> testGeneratePrimitiveAssertions [
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SStack #SStack #() false)
								with: #push: -> #(#SStack #SmallInteger #(#SmallInteger) false))
						with: #());
		scalar: #SmallInteger with: #(1).
	"typeInfo := (SSGenerator
		profile: [ Stack new
				push: 10;
				yourself ]
		onClass: Stack) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SPrimitiveAssertion
				with: SComparisonAssertion
				with: SStringAssertion).
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SFoo #SFoo #() false)
								with: #return: -> #(#SFoo #ByteString #(#ByteString) false))
						with: #());
		scalar: #ByteString with: #('hello World').
	"typeInfo := (SSGenerator
		profile: [ SFoo new return: 'hello World' ]
		onClass: SFoo) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 5.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SPrimitiveAssertion
				with: SCollectionSizeAssertion
				with: SCollectionTypeSimilarityAssertion
				with: SStringAssertion
				with: SComparisonAssertion).
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SFoo #SFoo #() false)
								with: #return: -> #(#SFoo #SmallFloat64 #(#SmallFloat64) false))
						with: #());
		scalar: #SmallFloat64 with: #(2.34).
	"typeInfo := (SSGenerator
		profile: [ SFoo new return: 2.34 ]
		onClass: SFoo) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size equals: 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SPrimitiveAssertion
				with: SStringAssertion
				with: SComparisonAssertion).
	typeInfo := STypeInfo new
		type:
			#SFoo
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SFoo #SFoo #() false)
								with: #return: -> #(#SFoo #True #(#True) false))
						with: #());
		scalar: #True with: {true}.
	"typeInfo := (SSGenerator
		profile: [ SFoo new return: true ]
		onClass: SFoo) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants size >= 3.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SPrimitiveAssertion
				with: SStringAssertion
				with: SComparisonAssertion)
]

{ #category : #tests }
SSAssertionTest >> testInvariantsSStackRandomlyInitialized [
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SStack #SStack #() false)
								with: #push: -> #(#SStack  #SmallInteger #(#SmallInteger) false)
								with: #pop -> #(#SStack #SmallInteger #() false)
								with: #top -> #(#SStack #SmallInteger #() false))
						with: (Array with: #newStackWith: -> #(#SStack #SStack #(#Array) false)));
		scalar: #Array with: #(#(2 4 6 1));
		scalar: #SmallInteger with: #(8).
	"typeInfo := (SSGenerator
		profile: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		onClass: SStack) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 15.
	testCase generateStatements.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants isNotNil.
	self deny: invariants isEmpty.
	typeInfo := STypeInfo new
		type:
			#SStack
				->
					(Array
						with:
							(Array
								with: #initialize -> #(#SStack #SStack #() false)
								with:
									#push: -> #(#SStack #ByteString #(#ByteString) false)
								with: #pop -> #(#SStack #ByteString #() false)
								with: #top -> #(#SStack #ByteString #() false))
						with:
							(Array with:
								#newStackWith: -> #(#SStack #SStack #(#Array) false)));
		scalar: #Array with: #(#('abcd' 'efg' 'hij' 'klmn'));
		scalar: #ByteString with: #('opqr').
	"typeInfo := (SSGenerator
		profile: [ (SStack newStackWith: {'abcd' . 'efg' . 'hij' . 'klmn'})
				push: 'opqr';
				pop;
				top ]
		onClass: SStack) asTypeInfo."
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 15.
	testCase generateStatements.
	invariants := testCase generateAssertionsUsing: #().
	self assert: invariants isNotNil.
	self deny: invariants isEmpty
]
