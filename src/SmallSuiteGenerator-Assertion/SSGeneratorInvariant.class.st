Class {
	#name : #SSGeneratorInvariant,
	#superclass : #Object,
	#instVars : [
		'compiler',
		'compilerClassOfTests',
		'testClassName',
		'testPackageName'
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
	node := SUtil nodeFormedFrom: testCase.
	invariants
		do:
			[ :invariant | node body addNode: (RBParser parseExpression: invariant asString) ].
	selector := [ self testClassCompiler
		compile:
			'test' , self class numTest asString , String cr
				, node body formattedCode ]
		on: Error
		do: [ nil ].
	selector
		ifNotNil: [ self class incrementNumTest.
			^ true ].
	^ false
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

{ #category : #initialization }
SSGeneratorInvariant >> initialize [
	compiler := SSCompilerInvariant new.
	testClassName := 'SSAssertionGeneratorTest'.
	testPackageName := 'SmallSuiteGenerator-Tests-Assertion'
	"refactorizer := SRefactorizer new"
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant >> testClassCompiler [
	^ [ (SUtil compilersTestsFrom: self class name) first ]
		on: MessageNotUnderstood
		do: [ SUtil
				createClass: testClassName
				ofPackage: testPackageName
				from: self class name ]
]

{ #category : #accessing }
SSGeneratorInvariant >> testClassName [
	^ testClassName
]

{ #category : #accessing }
SSGeneratorInvariant >> testClassName: anObject [
	testClassName := anObject
]

{ #category : #accessing }
SSGeneratorInvariant >> testPackageName [
	^ testPackageName
]

{ #category : #accessing }
SSGeneratorInvariant >> testPackageName: anObject [
	testPackageName := anObject
]

{ #category : #accessing }
SSGeneratorInvariant >> transformToNode: testCase [
	| node |
	node := SUtil nodeFormedFrom: testCase.
	node body
		addNode: (RBParser parseExpression: '^ self analyze: thisContext').
	^ node
]
