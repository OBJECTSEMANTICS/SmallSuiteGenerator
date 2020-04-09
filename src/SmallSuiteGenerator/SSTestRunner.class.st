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
	| _var24 _var25 _var2 _var3 _var1 _var0 _var4 _var5 _var6 _var7 _var8 _var9 _var11 _var12 _var10 _var13 |
_var24 := 'Ann'.
_var25 := 50.
_var2 := SSTeacher name: _var24 with: _var25.
_var3 := _var2 resetYearsWorkExperience.
_var1 := _var2 idTeacher.
_var0 := _var2 resetIdTeacher.
_var4 := _var2 yearsWorkExperience.
_var5 := _var3 yearsWorkExperience.
_var6 := _var3 yearsWorkExperience.
_var7 := _var2 resetIdTeacher.
_var8 := _var2 idTeacher.
_var9 := _var3 nickname.
_var11 := _var3 id: _var1.
_var12 := _var2 idTeacher.
_var10 := _var3 initialize.
_var13 := _var10 yearsWorkExperience.
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
