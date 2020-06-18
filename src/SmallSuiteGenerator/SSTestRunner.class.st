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
var at: 2 put: #(3 4 5).
var at: 3 put: (DataSeries withKeys: (var at: 2) values: (var at: 2)).
var at: 4 put: (var at: 3) isSequenceable.
var at: 5 put: (var at: 3) isSequenceable.
var at: 6 put: 3.
var at: 7 put: ((var at: 3) head: (var at: 6)).
var at: 8 put: (var at: 7) isSequenceable.
var at: 9 put: (var at: 7) name.
var at: 10 put: (var at: 3) interquartileRange.
var at: 11 put: (var at: 7) isSequenceable.
var at: 1 put: (var at: 3) name.
var at: 12 put: (var at: 7) valueCounts.
var at: 13 put: (var at: 3) isSequenceable.
var at: 14 put: (var at: 3) isSequenceable.
var at: 15 put: (var at: 12) isSequenceable.
var at: 16 put: (var at: 12) isSequenceable.
var at: 17 put: (var at: 7) isSequenceable.
var at: 18 put: (var at: 3) second.
var at: 19 put: (var at: 7) isSequenceable.
var at: 20 put: (var at: 12) isSequenceable.
var at: 21 put: 1.
var at: 22 put: (var at: 12) initialize.
var at: 23 put: (var at: 12) name.
var at: 24 put: (var at: 12) mode.
var at: 25 put: ((var at: 22) initialize: (var at: 21)).
var at: 26 put: (var at: 22) initialize.
var at: 27 put: (var at: 3) name.
var at: 28 put: (var at: 7) name.
var at: 29 put: (var at: 25) isSequenceable.
var at: 30 put: (var at: 3) sort.
var at: 31 put: (var at: 25) initialize.
var at: 32 put: (var at: 7) isSequenceable.
var at: 34 put: ((var at: 26) quartile: (var at: 10)).
var at: 35 put: (var at: 3) sort.
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
