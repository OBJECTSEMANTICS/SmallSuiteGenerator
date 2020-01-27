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
		addNode: (SConfiguration rbParserClass parseExpression: '^ self analyze: thisContext').
	self compile: node.
	^ self performTest
]

{ #category : #initialization }
SSTestRunner >> initialize [
	invariants := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SSTestRunner >> performTest [
	| _aSStudent0 _aSStudent1 _aSmallInteger2 _aSmallInteger3 _aSmallInteger4 _aSmallInteger5 _aSStudent6 _aSStudent7 _aSStudent8 _aSStudent9 _aSStudent10 _aSmallInteger11 _aSmallInteger12 _aSmallInteger13 _aSStudent14 _aSmallInteger15 _aSStudent16 _aSStudent17 _aSmallInteger18 |
_aSStudent0 := SStudent new.
_aSStudent1 := _aSStudent0 initialize.
_aSmallInteger2 := 1.
_aSmallInteger3 := _aSStudent1 scoreStudent: _aSmallInteger2.
_aSmallInteger4 := _aSStudent1 scoreStudent: _aSmallInteger3.
_aSmallInteger5 := _aSStudent1 scoreStudent: _aSmallInteger2.
_aSStudent6 := _aSStudent0 initialize.
_aSStudent7 := _aSStudent6 initialize.
_aSStudent8 := _aSStudent1 initialize.
_aSStudent9 := _aSStudent8 initialize.
_aSStudent10 := _aSStudent8 initialize.
_aSmallInteger11 := _aSStudent8 scoreStudent: _aSmallInteger3.
_aSmallInteger12 := _aSStudent8 scoreStudent: _aSmallInteger4.
_aSmallInteger13 := _aSStudent0 scoreStudent: _aSmallInteger12.
_aSStudent14 := _aSStudent8 initialize.
_aSmallInteger15 := _aSStudent7 scoreStudent: _aSmallInteger2.
_aSStudent16 := _aSStudent0 initialize.
_aSStudent17 := _aSStudent1 initialize.
_aSmallInteger18 := _aSStudent14 scoreStudent: _aSmallInteger12
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
