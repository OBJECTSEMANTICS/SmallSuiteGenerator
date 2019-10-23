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
	| _var0 _var2 _var3 _var4 _var30 _var5 _var6 _var7 _var1 _var9 _var10 _var11 _var8 _var12 _var13 _var14 _var15 _var16 _var17 _var18 _var19 _var20 _var21 _var22 _var23 _var24 _var25 _var26 _var27 _var28 |
_var0 := 100.
_var2 := SSTeacher new.
_var3 := 6299.
_var4 := -36.
_var30 := _var2 nickname.
_var5 := SSTeacher name: _var30 with: _var0.
_var6 := _var5 yearsWorkExperience.
_var7 := _var2 yearsWorkExperience: _var6.
_var1 := SSTeacher name: _var30 with: _var3.
_var9 := SSTeacher name: _var30 with: _var3.
_var10 := SSTeacher name: _var30 with: _var0.
_var11 := 45.
_var8 := SSTeacher name: _var30 with: _var4.
_var12 := 'Ann'.
_var13 := _var1 idTeacher.
_var14 := _var2 nickname.
_var15 := _var8 nickname: _var12.
_var16 := _var9 yearsWorkExperience.
_var17 := _var2 id: _var0.
_var18 := 50.
_var19 := SSTeacher name: _var12 with: _var11.
_var20 := _var1 nickname.
_var21 := SSTeacher name: _var30 with: _var0.
_var22 := 'teacher_Ann'.
_var23 := SSTeacher name: _var30 with: _var3.
_var24 := _var21 id: _var4.
_var25 := SSTeacher name: _var22 with: _var16.
_var26 := _var15 nickname: _var12.
_var27 := _var19 nickname.
_var28 := 50
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
