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
	self class compile: ('performTest
	',aBlock body formattedCode)
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
SSTestRunner >> performTest [
	| var |
var := Dictionary new.
var at: 1 put: (OrderedCollection new
         add: 12;
         add: -2;
         add: 'hello';
         add: #nameOf;
         add: 0;
         yourself).
var at: 2 put: (SStack newStackWith: (var at: 1)).
var at: 3 put: (var at: 2) pop.
var at: 4 put: (var at: 2) firstLinkStack.
var at: 5 put: ((var at: 2) push: (var at: 3)).
var at: 6 put: (var at: 2) pop.
var at: 7 put: (var at: 2) lastLinkStack.
var at: 8 put: ((var at: 2) push: (var at: 3)).
var at: 9 put: ((var at: 2) push: (var at: 3)).
var at: 10 put: 'hello'.
var at: 11 put: 'hello'.
var at: 12 put: ((var at: 2) push: (var at: 11)).
var at: 13 put: (var at: 2) firstLinkStack.
var at: 14 put: (var at: 2) firstLinkStack.
var at: 16 put: ((var at: 2) push: (var at: 10)).
var at: 17 put: (var at: 2) top.
^self analyze: thisContext
]

{ #category : #running }
SSTestRunner >> run: aSTestCase [
	testCase := aSTestCase.
	self compile: aSTestCase parseTreeWithAssertions.
	self setTestSelector: #performTest.
	^ self run.
]

{ #category : #running }
SSTestRunner >> runCase [
	self resources do: [:each | each availableFor: self].
	[[self setUp.
	self performTest.
	testCase hasErrors: false]
    on: Error
	 do: [ testCase hasErrors: true]] ensure: [
		self tearDown.
		self cleanUpInstanceVariables]
]

{ #category : #running }
SSTestRunner >> runWithoutAssertions: aSTestCase [
	testCase := aSTestCase.
	self compile: aSTestCase parseTree.
	self setTestSelector: #performTest.
	^ self run.
]
