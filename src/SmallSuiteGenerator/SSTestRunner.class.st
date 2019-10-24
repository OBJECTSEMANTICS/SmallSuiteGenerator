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
		compile: symbol asString , String cr , aBlock body formattedCode
]

{ #category : #running }
SSTestRunner >> evaluate: aSTestCase [
	| node |
	node := aSTestCase parseTree.
	node body addNode: (RBParser parseExpression: '^ self analyze: thisContext').
	self compile: node.
	^ self performTest
]

{ #category : #initialization }
SSTestRunner >> initialize [
	invariants := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SSTestRunner >> performTest [
	| _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var15 _var16 |
_var0 := RTEdgeBuilder new.
_var1 := OrderedCollection new
	add: RTElement basicNew yourself;
	add: RTElement basicNew yourself;
	add: RTElement basicNew yourself;
	add: RTElement basicNew yourself;
	yourself.
_var2 := _var0 fromObjects: _var1.
_var3 := _var0 fromElements.
_var4 := _var2 fromObjects: _var1.
_var5 := RTElement new.
_var6 := Announcer basicNew yourself.
_var7 := _var5 announcer: _var6.
_var8 := _var4 createEdgeIfNecessaryFrom: _var5 to: _var5.
_var9 := _var5 initialize.
_var10 := _var9 updateShape.
_var11 := Point new.
_var12 := _var3 translateTo: _var11.
_var13 := RTLine new.
_var14 := _var5 addShape: _var13.
_var15 := _var10 update.
_var16 := _var15 translateBy: _var11
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
