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
	| _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var15 _var16 _var17 _var18 |
_var0 := SStudent new.
_var1 := _var0 scoreStudent.
_var2 := _var0 scoreStudent: _var1.
_var3 := _var0 scoreStudent: _var2.
_var4 := _var0 scoreStudent.
_var5 := _var0 idStudent.
_var6 := _var0 scoreStudent: _var5.
_var7 := _var0 scoreStudent.
_var8 := _var0 initialize.
_var9 := _var8 initialize.
_var10 := _var8 idStudent.
_var11 := _var0 idStudent.
_var12 := _var8 scoreStudent: _var5.
_var13 := _var8 idStudent.
_var14 := _var9 initialize.
_var15 := _var8 idStudent.
_var16 := _var0 idStudent.
_var17 := _var9 scoreStudent.
_var18 := _var14 initialize
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
