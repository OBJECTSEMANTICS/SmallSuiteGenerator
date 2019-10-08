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
		'testClassesCompilers',
		'testClassesNames'
	],
	#category : #'SmallSuiteGenerator-Assertion-Invariant'
}

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> createCompilerClass: aClassName [
	self
		createCompilerClass: aClassName
		of: 'SmallSuiteGenerator-Tests-Generated'
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> createCompilerClass: aClassName of: aPackageName [
	| aCompiler |
	testClassesCompilers
		ifNil: [ testClassesCompilers := OrderedCollection new].
			aCompiler := self class compiler
				evaluate:
					(SCompilerMethod
						stringToCreateNewClass: aClassName
						with: 'TestCase'
						and: aPackageName).
			testClassesCompilers add: aCompiler.
			testClassesNames
				ifNil: [ testClassesNames := OrderedCollection new ].
			testClassesNames add: aClassName.
	^ aCompiler
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> incrementNumTest [
	numTest := numTest + 1
]

{ #category : #'class initialization' }
SSGeneratorInvariant class >> initialize [
	numTest := 0.
	testClassesNames := OrderedCollection new.
	testClassesCompilers := OrderedCollection new.
]

{ #category : #accessing }
SSGeneratorInvariant class >> numTest [
	^ numTest
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant class >> resetClassesOfTest [
	testClassesNames
		ifNotNil: [ testClassesNames
				do: [ :string | Smalltalk removeClassNamed: string ] ].
	testClassesNames := OrderedCollection new.
	testClassesCompilers := OrderedCollection new
]

{ #category : #initialization }
SSGeneratorInvariant class >> resetNumTest [
	numTest := 0
]

{ #category : #accessing }
SSGeneratorInvariant class >> testClassesCompilers [
	^ testClassesCompilers 
]

{ #category : #accessing }
SSGeneratorInvariant >> compileStatementsOf: testCase with: invariants [
	| node selector |
	node := SCompilerMethod nodeFormedFrom: testCase.
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
	^ [ self class testClassesCompilers first ]
		on: SubscriptOutOfBounds
		do: [ self class createCompilerClass: testClassName of: testPackageName ]
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
	node := SCompilerMethod nodeFormedFrom: testCase.
	node body
		addNode: (RBParser parseExpression: '^ self analyze: thisContext').
	^ node
]
