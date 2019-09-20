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
		'numTest',
		'classNameOfTest',
		'compilerClassOfTests'
	],
	#category : #'SmallSuiteGenerator-Assertion-Invariant'
}

{ #category : #accessing }
SSGeneratorInvariant class >> compilerClassOfTests [ 
	^ compilerClassOfTests 
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> createCompilerClass: aClassName [
	self createCompilerClass: aClassName of: 'SmallSuiteGenerator-Tests-Generated'
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> createCompilerClass: aClassName of: aPackageName [
	compilerClassOfTests
		ifNil: [ compilerClassOfTests := self class compiler
				evaluate:
					(SCoverageWithProfiler
						stringToCreateNewClass: aClassName
						with: 'TestCase'
						and: aPackageName).
						classNameOfTest := aClassName ]
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> incrementNumTest [
	numTest := numTest + 1
]

{ #category : #'class initialization' }
SSGeneratorInvariant class >> initialize [
	numTest := 0.
	classNameOfTest := nil
]

{ #category : #accessing }
SSGeneratorInvariant class >> numTest [
	^ numTest
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> resetClassOfTest [
	classNameOfTest
		ifNotNil: [ Smalltalk removeClassNamed: classNameOfTest ].
	classNameOfTest := nil.
	compilerClassOfTests := nil
]

{ #category : #initialization }
SSGeneratorInvariant class >> resetNumTest [
	numTest := 0
]

{ #category : #accessing }
SSGeneratorInvariant >> compileStatementsOf: testCase with: invariants [
	| node selector |
	node := SCoverageWithProfiler nodeFormattedOf: testCase.
	invariants
		do:
			[ :invariant | node body addNode: (RBParser parseExpression: invariant asString) ].
	selector := [ self compilerClassOfTests
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
SSGeneratorInvariant >> compilerClassOfTests [
	^ self class compilerClassOfTests ifNil: [self class createCompilerClass: testClassName of: testPackageName]
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
	node := SCoverageWithProfiler  nodeFormattedOf: testCase.
	node body
		addNode: (RBParser parseExpression: '^ self analyze: thisContext').
	^ node
]
