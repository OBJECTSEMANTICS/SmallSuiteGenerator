Class {
	#name : #SSTestRunner,
	#superclass : #TestCase,
	#instVars : [
		'testCase',
		'invariants'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'test - instrumentation' }
SSTestRunner >> analyze: aSmalltalkContext [
	"it takes an snapshot of the thisContext object"
	| sContext |
	sContext := SSExecutionContext new.
	aSmalltalkContext tempNames
		doWithIndex:
			[ :varName :index | sContext at: varName put: (aSmalltalkContext namedTempAt: index) ].
	^ sContext
]

{ #category : #compiling }
SSTestRunner >> compile: aBlock [
	self class compile: ('performTest',aBlock body formattedCode)
]

{ #category : #compiling }
SSTestRunner >> compile: aBlock withName: symbol on: aClass [
	aClass
		compile: symbol asString , (String with: Character cr) , aBlock body formattedCode
]

{ #category : #running }
SSTestRunner >> evaluate: aSTestCase [
	| node |
	node := aSTestCase parseTree.
	node body
		addNode: (SPlatform rbParserClass parseExpression: '^ self analyze: thisContext').
	self compile: node.
	^ self performTest
]

{ #category : #initialization }
SSTestRunner >> initialize [
	invariants := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SSTestRunner >> performTest| var [ |
var := Dictionary new.
var at: 1 put: SStack newStack.
var at: 2 put: (var at: 1) pop.
var at: 22 put: (var at: 1) top.
var at: 3 put: (var at: 1) top.
var at: 20 put: (OrderedCollection new
         add: 12;
         add: -2;
         add: 'hello';
         add: #nameOf;
         add: 0;
         yourself).
var at: 4 put: 'teacher_Johan'.
var at: 21 put: (SStack newStackWith: (var at: 20)).
var at: 5 put: ((var at: 1) push: (var at: 4)).
var at: 6 put: (var at: 21) firstLinkStack.
var at: 7 put: (var at: 1) lastLinkStack.
var at: 9 put: ((var at: 1) push: (var at: 4)).
var at: 11 put: ((var at: 1) push: (var at: 5)).
var at: 12 put: ((var at: 1) push: (var at: 22)).
var at: 13 put: (var at: 1) top.
var at: 14 put: (var at: 1) top.
var at: 16 put: ((var at: 1) push: (var at: 22)).
var at: 8 put: (var at: 21) top.
var at: 17 put: (SStack newStackWith: (var at: 20)).
var at: 18 put: (var at: 21) firstLinkStack.
var at: 19 put: (var at: 1) firstLinkStack.
var at: 24 put: ((var at: 17) push: (var at: 8)).
var at: 25 put: (var at: 17) top.
var at: 27 put: (SStack newStackWith: (var at: 20)).
var at: 28 put: (var at: 21) firstLinkStack.
var at: 30 put: ((var at: 17) push: (var at: 5)).
^self analyze: thisContext
]

{ #category : #running }
SSTestRunner >> run: aSTestCase [
	self compile: aSTestCase parseTreeWithAssertions.
	self setTestSelector: #performTest.
	^ self run.
]

{ #category : #running }
SSTestRunner >> runWithoutAssertions: aSTestCase [
	self compile: aSTestCase parseTree.
	self setTestSelector: #performTest.
	^ self run.
]
