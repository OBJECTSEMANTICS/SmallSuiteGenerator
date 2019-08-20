Class {
	#name : #SSGeneratorInvariant,
	#superclass : #SObject,
	#instVars : [
		'compiler'
	],
	#classInstVars : [
		'numTest'
	],
	#category : #'SmallSuiteGenerator-Invariant'
}

{ #category : #'modifier state' }
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

{ #category : #actions }
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

{ #category : #initialization }
SSGeneratorInvariant >> initialize [
	compiler := SSCompilerInvariant new.
	"refactorizer := SRefactorizer new"
]

{ #category : #accessing }
SSGeneratorInvariant >> transformToNode: testCase [
	| node |
	node := SCoverageWithProfiler  nodeFormattedOf: testCase.
	node body
		addNode: (RBParser parseExpression: '^ self analyze: thisContext').
	^ node
]
