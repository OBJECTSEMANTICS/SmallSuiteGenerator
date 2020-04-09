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
	| _var0 _var1 _var27 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var10 _var11 _var12 _var13 _var14 _var9 _var15 _var16 _var17 _var18 _var21 |
_var0 := RTGrapher new.
_var1 := _var0 maxY.
_var27 := RTGrapher new.
_var2 := _var0 renderLegend.
_var3 := RTData new.
_var4 := RTData basicNew yourself.
_var5 := _var0 add: _var3.
_var6 := _var4 defaultMinValue.
_var7 := _var27 resetShape.
_var8 := _var0 initialize.
_var10 := false.
_var11 := _var7 shouldUseNiceLabelsForX: _var10.
_var12 := _var7 homogenizeMinAndMax.
_var13 := RTEllipse new.
_var14 := RTBox new.
_var9 := _var8 maxX.
_var15 := _var4 defaultMinValue.
_var16 := _var2 maxX.
_var17 := _var27 maxX.
_var18 := _var8 initialize.
_var21 := _var8 initialize.
^self analyze: thisContext
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
