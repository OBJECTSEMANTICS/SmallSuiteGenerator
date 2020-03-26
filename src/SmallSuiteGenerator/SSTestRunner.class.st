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
	| _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var15 _var16 _var17 _var18 |
_var0 := 15.
_var1 := SFoo score: _var0.
_var2 := _var1 score.
_var3 := _var1 score.
_var4 := _var1 score.
_var5 := _var1 returnFloat.
_var6 := _var1 score.
_var7 := _var1 score.
_var8 := _var1 score: _var7.
_var9 := _var1 initialize.
_var10 := _var1 returnCollection.
_var11 := _var9 score: _var2.
_var12 := _var8 score.
_var13 := _var9 score: _var12.
_var14 := _var8 returnCollection.
_var15 := _var8 returnFloat.
_var16 := _var8 score: _var12.
_var17 := _var13 score.
_var18 := _var16 score: _var17
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
