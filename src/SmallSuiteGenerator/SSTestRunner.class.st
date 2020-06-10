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
var at: 1 put: ((Array new: 3)
         at: 1 put: (DataSeries new
               add: #Female -> 41.58;
               add: #Male -> 55.03;
               yourself);
         at: 2 put: (DataSeries new
               add: #Female -> 20.79;
               add: #Male -> 18.343333333333334;
               yourself);
         at: 3 put: (DataSeries new
               add: #Female -> 2.31;
               add: #Male -> 2.8233333333333337;
               yourself);
         yourself).
var at: 2 put: (DataFrame withColumns: (var at: 1)).
var at: 3 put: #average.
var at: 4 put: (var at: 2) rowNames.
var at: 5 put: (var at: 2) rowNames.
var at: 45 put: (DataFrame withRows: (var at: 1)).
var at: 10 put: (var at: 2) columnNames.
var at: 11 put: (var at: 45) rowNames.
var at: 12 put: (var at: 2) rowNames.
var at: 13 put: (var at: 45) numberOfColumns.
var at: 8 put: ((var at: 2) applyToAllColumns: (var at: 3)).
var at: 9 put: ((var at: 2) applyToAllColumns: (var at: 3)).
var at: 14 put: ((var at: 2) tail: (var at: 13)).
var at: 17 put: ((var at: 14) rowsFrom: (var at: 13) to: (var at: 13) put: (var at: 1)).
var at: 19 put: (var at: 2) contents.
var at: 20 put: (var at: 14) columnNames.
var at: 21 put: (var at: 14) columnNames.
var at: 6 put: (var at: 2) rowNames.
var at: 7 put: (var at: 17) numberOfRows.
var at: 16 put: ((var at: 2) column: (var at: 7)).
var at: 18 put: (var at: 16) name.
var at: 22 put: (var at: 45) columnNames.
var at: 23 put: (var at: 2) columnNames.
var at: 24 put: (var at: 17) tail.
var at: 25 put: (var at: 14) rowNames.
var at: 26 put: (var at: 17) numberOfRows.
var at: 27 put: (var at: 45) rowNames.
var at: 28 put: ((var at: 8) atIndex: (var at: 7)).
var at: 29 put: (var at: 45) rowNames.
var at: 30 put: ((var at: 9) atIndex: (var at: 13)).
var at: 31 put: (var at: 14) rowNames.
var at: 32 put: (var at: 8) name.
var at: 34 put: ((var at: 17) columnNames: (var at: 1)).
var at: 35 put: (var at: 17) rowNames.
var at: 36 put: (var at: 16) name.
var at: 39 put: ((var at: 9) atIndex: (var at: 26)).
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
