Class {
	#name : #SSTestFactoryToDelete,
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
SSTestFactoryToDelete class >> compilerClassOfTests [ 
	^ compilerClassOfTests 
]

{ #category : #accessing }
SSTestFactoryToDelete class >> compilerClassOfTests: aClassName [
	self resetClassOfTest.
	self createCompilerClass: aClassName.
	^ compilerClassOfTests 
]

{ #category : #'as yet unclassified' }
SSTestFactoryToDelete class >> createCompilerClass: aClassName [
	self createCompilerClass: aClassName of: 'SmallSuiteGenerator-Tests-Generated'
]

{ #category : #'as yet unclassified' }
SSTestFactoryToDelete class >> createCompilerClass: aClassName of: aPackageName [
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
SSTestFactoryToDelete class >> incrementNumTest [
	numTest := numTest + 1
]

{ #category : #'class initialization' }
SSTestFactoryToDelete class >> initialize [
	numTest := 0.
	classNameOfTest := nil
]

{ #category : #accessing }
SSTestFactoryToDelete class >> numTest [
	^ numTest
]

{ #category : #'as yet unclassified' }
SSTestFactoryToDelete class >> resetClassOfTest [
	classNameOfTest
		ifNotNil: [ Smalltalk removeClassNamed: classNameOfTest ].
	classNameOfTest := nil.
	compilerClassOfTests := nil
]

{ #category : #initialization }
SSTestFactoryToDelete class >> resetNumTest [
	numTest := 0
]

{ #category : #accessing }
SSTestFactoryToDelete >> compileStatementsOf: testCase with: invariants [
	| node selector |
	node := testCase parseTree.
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
SSTestFactoryToDelete >> compilerClassOfTests [
	^ self class compilerClassOfTests ifNil: [self class createCompilerClass: testClassName of: testPackageName]
]

{ #category : #'as yet unclassified' }
SSTestFactoryToDelete >> generateAssertionsOf: aSTestCase testCaseUsing: selectedInvariants [
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
SSTestFactoryToDelete >> initialize [
	testRunner := SSTestRunner new.
	testClassName := 'SSAssertionGeneratorTest'.
	testPackageName := 'SmallSuiteGenerator-Tests-Assertion'
	"refactorizer := SRefactorizer new"
]

{ #category : #accessing }
SSTestFactoryToDelete >> testClassName [
	^ testClassName
]

{ #category : #accessing }
SSTestFactoryToDelete >> testClassName: anObject [
	testClassName := anObject
]

{ #category : #accessing }
SSTestFactoryToDelete >> testPackageName [
	^ testPackageName
]

{ #category : #accessing }
SSTestFactoryToDelete >> testPackageName: anObject [
	testPackageName := anObject
]
