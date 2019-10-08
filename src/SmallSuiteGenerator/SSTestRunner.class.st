Class {
	#name : #SSTestRunner,
	#superclass : #Object,
	#instVars : [
		'evaluator',
		'testCase',
		'invariants'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'test - instrumentation' }
SSTestRunner >> analyze: aSmalltalkContext [
	"it takes an snapshot of the thisContext object"
	|sContext|
	sContext := SSExecutionContext new.
	aSmalltalkContext tempNames
		doWithIndex: [ :varName :index | 
			sContext at: varName put: (aSmalltalkContext namedTempAt: index).].
	^ sContext
]

{ #category : #compiling }
SSTestRunner >> compile: aBlock [
	self class compile: ('performTest
	',aBlock body formattedCode)
]

{ #category : #initialization }
SSTestRunner >> initialize [
	evaluator := SSEvaluatorInvariant new.
	invariants := OrderedCollection new.
]

{ #category : #compiling }
SSTestRunner >> load: aSTestCase [
	| node |
	node := aSTestCase parseTreeWithAssertions.
	self compile: node.
]

{ #category : #running }
SSTestRunner >> run [
	^ self performTest.
]

{ #category : #running }
SSTestRunner >> run: aSTestCase [
	self load: aSTestCase.
	^ self run.
]
