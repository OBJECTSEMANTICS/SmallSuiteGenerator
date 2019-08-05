Class {
	#name : #SSGeneratorInvariant,
	#superclass : #Object,
	#instVars : [
		'compiler',
		'refactorizer'
	],
	#classInstVars : [
		'numTest'
	],
	#category : #'SmallSuiteGenerator-Assertion-Invariant'
}

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> incrementNumTest [
	numTest := numTest + 1
]

{ #category : #'class initialization' }
SSGeneratorInvariant class >> initialize [ 
	numTest := 0
]

{ #category : #accessing }
SSGeneratorInvariant class >> numTest [
	^ numTest
]

{ #category : #initialization }
SSGeneratorInvariant class >> resetNumTest [
	numTest := 0
]

{ #category : #accessing }
SSGeneratorInvariant >> compileStatementsOf: testCase with: invariants [
	| node selector |
	node := SCoverageWithProfiler  nodeFormattedOf: testCase.
	invariants
		do:
			[ :invariant | node body addNode: (RBParser parseExpression: invariant asString) ].
	selector := [ SSAssertionGeneratorTest
		compile:
			'test' , self class numTest asString, String cr , node body formattedCode ]
		on: Error
		do: [ nil ].
	selector
		ifNotNil: [ self class incrementNumTest.
			^ true ].
	^ false
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant >> generateAssert: aCollection [
	| node temporaries collectAsSet |
	node := RBParser parseExpression: '[]'.
	temporaries := Set new.
	aCollection ifNotEmpty: [ 
		collectAsSet := (aCollection collect: [ :invariant | invariant statement ]) asSet.
		collectAsSet do: [ :statement | node body addNode: (RBParser parseExpression: statement) ].
		aCollection do: [ :invariant | 
			temporaries add: (RBParser parseExpression: invariant nameValue).
			node body addNode: (RBParser parseExpression: invariant asString).	
		].
		node body temporaries: temporaries asOrderedCollection.
		SSAssertionGeneratorTest compile: 'test', self class numTest asString, '
		', node body formattedCode.
		self class incrementNumTest 
	].
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant >> generateAssertionsOf: aSTestCase testCaseUsing: selectedInvariants [
	| filteredInvariants compiled |
	compiler compile: (self transformToNode: aSTestCase).
	filteredInvariants := compiler
		executeMethodUsing: aSTestCase
		testCaseAnd: selectedInvariants.
	compiled := self
		compileStatementsOf: aSTestCase
		with: filteredInvariants.
	compiled
		ifTrue: [ ^ filteredInvariants ].
	^ nil
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant >> generateAssertionsOf: aSTestCase testCaseUsing: invariants invariantsApplyingPrettyCodeWith: kindsRefactoring [
	refactorizer
		prettyCodeOf: aSTestCase
		testCaseApplying: kindsRefactoring.
	^ self generateAssertionsOf: aSTestCase testCaseUsing: invariants
]

{ #category : #initialization }
SSGeneratorInvariant >> initialize [
	compiler := SSCompilerInvariant new.
	refactorizer := SRefactorizer new
]

{ #category : #accessing }
SSGeneratorInvariant >> transformToNode: testCase [
	| node |
	node := SCoverageWithProfiler  nodeFormattedOf: testCase.
	node body
		addNode: (RBParser parseExpression: '^ self analyze: thisContext').
	^ node
]
