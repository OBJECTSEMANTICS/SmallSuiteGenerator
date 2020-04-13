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
var at: 1 put: PDFDocument new.
var at: 29 put: PDFDocument new.
var at: 2 put: (var at: 1) styleSheet.
var at: 28 put: (var at: 1) format.
var at: 5 put: (var at: 1) styleSheet.
var at: 6 put: (var at: 29) orientation.
var at: 7 put: (var at: 28) size.
var at: 9 put: (var at: 1) metaData.
var at: 10 put: (var at: 9) producer.
var at: 8 put: 'Artefact'.
var at: 11 put: ((var at: 9) creator: (var at: 8)).
var at: 12 put: (var at: 1) zoom.
var at: 3 put: (var at: 1) real.
var at: 4 put: (var at: 28) size.
var at: 14 put: ''.
var at: 15 put: ((var at: 9) producer: (var at: 8)).
var at: 16 put: (var at: 15) subject.
var at: 17 put: (var at: 11) producer.
var at: 18 put: (var at: 3) generate.
var at: 19 put: (var at: 1) real.
var at: 21 put: ((var at: 9) producer: (var at: 14)).
var at: 22 put: PDFPage basicNew yourself.
var at: 23 put: ((var at: 19) add: (var at: 22)).
var at: 25 put: ((var at: 21) producer: (var at: 14)).
var at: 26 put: (var at: 1) real
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
