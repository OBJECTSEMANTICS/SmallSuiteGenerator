Class {
	#name : #SSGeneratorInvariant,
	#superclass : #Object,
	#instVars : [
		'compiler'
	],
	#classInstVars : [
		'numTest'
	],
	#category : #'SmallSuiteGeneratorAssert-Invariant'
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

{ #category : #'as yet unclassified' }
SSGeneratorInvariant >> generateAssert: aCollection [
	| node |
	node := RBParser parseExpression: '[]'.
	aCollection ifNotEmpty: [ 
		aCollection asSet do: [ :invariant | 
			node body addNode: (RBParser parseExpression: invariant asString).	
		].
		SSGeneratorInvariantTest compile: 'test', self class numTest asString, '
		', node body formattedCode.
		self class incrementNumTest 
	].
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant >> generateInvariants: aSTestCase [
	| invariants |
	compiler compile: (self transformToNode: aSTestCase statements).
	invariants := compiler executeMethodTest.
	self generateAssert: invariants.
	"| node |
	node := self transformToNode: aSTestCase statements.
	node ifNotNil: [ 
		STIEvaluatorTest compile: 'test', self class numTest asString, '
		', node body formattedCode.
		self class incrementNumTest 
	]."
	^ invariants
	
	
]

{ #category : #initialization }
SSGeneratorInvariant >> initialize [ 	
	compiler := SSCompilerInvariant new.
]

{ #category : #'as yet unclassified' }
SSGeneratorInvariant >> invariantsOfStatements: statements [
	"| collectionInvariants |
	collectionInvariants := OrderedCollection new.
	statements do: [ :statement | 
		collectionInvariants addAll: (evaluator applyRule: statement varName to: )	
	].
	^ collectionInvariants "
]

{ #category : #accessing }
SSGeneratorInvariant >> transformToNode: statements [
	"invariants := self invariantsOfStatements: statements.
	invariants ifNotEmpty: [ "
		| node temporaries stringStatements |
		node := RBParser parseExpression: '[]'.
		stringStatements := OrderedCollection new.
		temporaries := OrderedCollection new.
		statements collect: [ :statement | statement varName ] 
		thenDo: [ :varName | 
			temporaries add: (RBParser parseExpression: varName ).
		].
		node body temporaries: temporaries.
		stringStatements := statements collect: [ :statement | statement printString ].
		"stringStatements addAll: (invariants collect: [ :invariant | invariant printString ])."
		stringStatements do: [ :aString | 
			node body addNode: (RBParser parseExpression: aString)
		].
		node body addNode: (RBParser parseExpression: '^ self analyze: thisContext').
		^ node
	"].
	^ nil"
]
