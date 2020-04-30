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
var at: 1 put: RSChart new.
var at: 2 put: (var at: 1) plots.
var at: 3 put: (var at: 1) plots.
var at: 4 put: (var at: 1) extent.
var at: 5 put: (var at: 1) decorations.
var at: 6 put: (var at: 1) niceGenerator.
var at: 7 put: 0.
var at: 8 put: ((var at: 1) maxValueX: (var at: 7)).
var at: 9 put: (var at: 1) open.
var at: 10 put: (var at: 8) colors.
var at: 11 put: 5.
var at: 12 put: ((var at: 8) minValueX: (var at: 11)).
var at: 13 put: ''.
var at: 14 put: ((var at: 1) ylabel: (var at: 13)).
var at: 15 put: RSChartTitleDecoration new.
var at: 17 put: ((var at: 15) renderIn: (var at: 13)).
var at: 18 put: RSScatterPlot new.
var at: 19 put: RSXLabelDecoration new.
var at: 21 put: RSChart new.
var at: 22 put: ((var at: 19) chart: (var at: 14)).
var at: 24 put: ((var at: 18) chart: (var at: 21)).
var at: 26 put: ((var at: 24) chart: (var at: 1)).
var at: 27 put: (var at: 14) extent.
var at: 28 put: ((var at: 18) chart: (var at: 8)).
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
