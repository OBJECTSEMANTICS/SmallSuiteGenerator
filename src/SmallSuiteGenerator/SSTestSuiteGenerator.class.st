Class {
	#name : #SSTestSuiteGenerator,
	#superclass : #Object,
	#instVars : [
		'testRunner',
		'compilerClassOfTests',
		'testClassName',
		'testPackageName'
	],
	#classInstVars : [
		'numTest',
		'classNameOfTest',
		'compilerClassOfTests'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SSTestSuiteGenerator class >> compilerClassOfTests [ 
	^ compilerClassOfTests 
]

{ #category : #accessing }
SSTestSuiteGenerator class >> compilerClassOfTests: aClassName [
	self resetClassOfTest.
	self createCompilerClass: aClassName.
	^ compilerClassOfTests 
]

{ #category : #'as yet unclassified' }
SSTestSuiteGenerator class >> createCompilerClass: aClassName [
	self createCompilerClass: aClassName of: 'SmallSuiteGenerator-Tests-Generated'
]

{ #category : #'as yet unclassified' }
SSTestSuiteGenerator class >> createCompilerClass: aClassName of: aPackageName [
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
SSTestSuiteGenerator class >> incrementNumTest [
	numTest := numTest + 1
]

{ #category : #'class initialization' }
SSTestSuiteGenerator class >> initialize [
	numTest := 0.
	classNameOfTest := nil
]

{ #category : #accessing }
SSTestSuiteGenerator class >> numTest [
	^ numTest
]

{ #category : #'as yet unclassified' }
SSTestSuiteGenerator class >> resetClassOfTest [
	classNameOfTest
		ifNotNil: [ Smalltalk removeClassNamed: classNameOfTest ].
	classNameOfTest := nil.
	compilerClassOfTests := nil
]

{ #category : #initialization }
SSTestSuiteGenerator class >> resetNumTest [
	numTest := 0
]

{ #category : #accessing }
SSTestSuiteGenerator >> compileStatementsOf: testCase with: invariants [
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
SSTestSuiteGenerator >> compilerClassOfTests [
	^ self class compilerClassOfTests ifNil: [self class createCompilerClass: testClassName of: testPackageName]
]

{ #category : #'as yet unclassified' }
SSTestSuiteGenerator >> generateAssertionsOf: aSTestCase testCaseUsing: selectedInvariants [
	| filteredInvariants compiled |
	testRunner run: aSTestCase. 
	"compile: (self transformToNode: aSTestCase).
	filteredInvariants := compiler
		executeMethodUsing: aSTestCase
		testCaseAnd: selectedInvariants."
	compiled := self
		compileStatementsOf: aSTestCase
		with: filteredInvariants.
	compiled
		ifTrue: [ ^ filteredInvariants ].
	^ nil
]

{ #category : #initialization }
SSTestSuiteGenerator >> initialize [
	testRunner := SSTestRunner new.
	testClassName := 'SSAssertionGeneratorTest'.
	testPackageName := 'SmallSuiteGenerator-Tests-Assertion'
	"refactorizer := SRefactorizer new"
]

{ #category : #accessing }
SSTestSuiteGenerator >> testClassName [
	^ testClassName
]

{ #category : #accessing }
SSTestSuiteGenerator >> testClassName: anObject [
	testClassName := anObject
]

{ #category : #accessing }
SSTestSuiteGenerator >> testPackageName [
	^ testPackageName
]

{ #category : #accessing }
SSTestSuiteGenerator >> testPackageName: anObject [
	testPackageName := anObject
]

{ #category : #accessing }
SSTestSuiteGenerator >> transformToNode: testCase [
	| node |
	node := SCoverageWithProfiler  nodeFormattedOf: testCase.
	node body
		addNode: (RBParser parseExpression: '^ self analyze: thisContext').
	^ node
]
