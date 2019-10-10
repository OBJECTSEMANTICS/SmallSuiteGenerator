Class {
	#name : #SSAssertionTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Assertion'
}

{ #category : #running }
SSAssertionTest >> setUp [
	SSTestSuiteGenerator resetNumTest.
	SSTestSuiteGenerator resetClassOfTest
]

{ #category : #running }
SSAssertionTest >> tearDown [ 
	SSTestSuiteGenerator resetClassOfTest 
]

{ #category : #tests }
SSAssertionTest >> testCreateCompilerClass [
	|  testCase |
	testCase := SSTestCase
		with:
			(STypeInfo new
				type:
					#SFoo
						->
							(Array
								with:
									(Array
										with: #score: -> #(#SFoo #SFoo #(#Array) false)
										with: #initialize -> #(#SFoo #SFoo #() false))
								with: (Array with: #score: -> #(#SFoo #SFoo #(#Array) false)));
				scalar: #Array with: #(#(2 4))).
	testCase addLiteral.
	SSTestSuiteGenerator createCompilerClass: 'SFooTest'.
	testCase generateAssertions: #().
	self assert: (Smalltalk classNamed: 'SFooTest') isNotNil
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantCollections [
	| typeInfo testCase  |
	typeInfo := STypeInfo new type: #Stack -> (Array with: #() with: #()).
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase  generateAssertions: (Array
			
				with: SStringAssertion
				with: SComparisonAssertion).
	self assert: testCase assertions size equals: 1.
	self
		assertCollection: (testCase assertions collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SStringAssertion).
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
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase generateAssertions: (Array with: SInspectorAssertion with: SComparisonAssertion).
	self assert: testCase assertions size equals: 1.
	self
		assertCollection: (testCase assertions collect: [ :i | i class ])
		hasSameElements: (Array with: SInspectorAssertion).
	typeInfo := STypeInfo new type: #Array -> (Array with: #() with: #()).	
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase generateAssertions: (Array
				with: SPrimitiveAssertion
				with: SStringAssertion
				with: SComparisonAssertion).
	self assert: testCase assertions size equals: 1.
	self
		assertCollection: (testCase assertions collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SStringAssertion)
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsArray [
	| typeInfo testCase |
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
		scalar: #Array with: #(#(2 4)).	
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	testCase generateAssertions: #().
	self assert: testCase assertions isEmpty.
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
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	testCase generateAssertions: (Array
				with: SPrimitiveAssertion
				with: SComparisonAssertion
				with: SStringAssertion).
	self assert: testCase assertions size equals: 1.
	self
		assertCollection: (testCase assertions collect: [ :i | i class ])
		hasSameElements:
			(Array
				with: SStringAssertion)
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsStack [
	| typeInfo testCase invariants |
	typeInfo := STypeInfo new type: #Stack -> (Array with: #() with: #()).
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	invariants := testCase generateAssertions: #().
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
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase addMessage.
	invariants := testCase generateAssertions: #().
	"invariants is empty if the compiled method has failed"
	self deny: invariants isEmpty.
	self assert: invariants size equals: 11.
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
				add: SComparisonAssertion;
				add: SStringAssertion;
				add: SStringAssertion;
				yourself)
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsWithSelectionSStack [
	| typeInfo testCase   |
	typeInfo := STypeInfo new
		type: #SStack -> (Array with: #() with: #()).
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.
	testCase generateAssertions: (Array with: SComparisonAssertion).
	self assert: testCase assertions isEmpty.
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
	testCase generateAssertions: (Array
		with: SStringAssertion).
	"self assert: invariants size equals: 3."
	self
		assertCollection: (testCase assertions collect: [ :i | i class ]) asSet
		hasSameElements:
			(Array
				with: SStringAssertion).
]

{ #category : #tests }
SSAssertionTest >> testGenerateInvariantsWithSelectionSStudent [
	| typeInfo testCase invariants selectedInvariants classesInvariants |
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
	invariants := testCase generateAssertions: selectedInvariants.
	self
		assert:
			(invariants isEmpty
				or: [ invariants size = 1
						and: [ invariants first className = 'SCollectionSizeAssertion' ] ]).
	selectedInvariants := Array
		with: SCollectionSizeAssertion
		with: SStringAssertion
		with: SComparisonAssertion.
	invariants := testCase generateAssertions: selectedInvariants.
	classesInvariants := invariants collect: [ :i | i class ].
	self
		assert:
			((classesInvariants includesAll: selectedInvariants)
				or: [ classesInvariants includesAny: selectedInvariants ]).
	selectedInvariants := Array
		with: SComparisonAssertion
		with: SInspectorAssertion.
	invariants := testCase generateAssertions: selectedInvariants.
	self
		assertCollection: (invariants collect: [ :i | i class ])
		hasSameElements: selectedInvariants.
	invariants := testCase generateAssertions: #().
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
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertions: #().
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
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertions: #().
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
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertions: #().
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
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.
	invariants := testCase generateAssertions: #().
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
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 15.
	testCase generateStatements.
	invariants := testCase generateAssertions: #().
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
	testCase := SSTestCase with: typeInfo.
	testCase numMaxStatements: 15.
	testCase generateStatements.
	invariants := testCase generateAssertions: #().
	self assert: invariants isNotNil.
	self deny: invariants isEmpty
]
