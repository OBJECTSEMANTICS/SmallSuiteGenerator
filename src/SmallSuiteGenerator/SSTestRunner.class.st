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
var at: 1 put: NeoJSONObjectMapping new.
var at: 2 put: Point.
var at: 26 put: Point.
var at: 3 put: ((var at: 1) subjectClass: (var at: 26)).
var at: 24 put: NeoJSONReader basicNew yourself.
var at: 4 put: 'Integer digit expected'.
var at: 5 put: [ nil ].
var at: 9 put: ((var at: 1) mapProperty: (var at: 4) getter: (var at: 5) setter: (var at: 5)).
var at: 11 put: 'Inst var not found: '.
var at: 12 put: ((var at: 9) propertyName: (var at: 11)).
var at: 13 put: #(#x #y).
var at: 14 put: ((var at: 3) mapInstVars: (var at: 13)).
var at: 15 put: (var at: 1) identifier.
var at: 17 put: ((var at: 9) setter: (var at: 5)).
var at: 18 put: (var at: 12) propertyName.
var at: 6 put: (var at: 9) propertyName.
var at: 7 put: (var at: 1) identifier.
var at: 8 put: (var at: 1) identifier.
var at: 16 put: (var at: 9) propertyName.
var at: 21 put: ((var at: 1) readFrom: (var at: 24)).
var at: 22 put: 3 @ 4.
var at: 23 put: NeoJSONReader basicNew yourself.
var at: 25 put: ((var at: 17) readObject: (var at: 22) from: (var at: 23)).
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
