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
	| _var1 _var2 _var3 _var5 _var6 _var7 _var0 _var4 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var16 _var17 _var18 |
_var1 := 137.
_var2 := SSTeacher new.
_var3 := _var2 id: _var1.
_var5 := _var3 initialize.
_var6 := _var2 idTeacher.
_var7 := _var2 idTeacher.
_var0 := _var2 idTeacher.
_var4 := _var3 idTeacher.
_var8 := _var5 idTeacher.
_var9 := _var5 nickname.
_var10 := 50.
_var11 := _var2 yearsWorkExperience: _var6.
_var12 := _var5 idTeacher.
_var13 := SConference price: _var10.
_var14 := _var2 canRegister: _var13.
_var16 := _var5 yearsWorkExperience: _var7.
_var17 := _var16 initialize.
_var18 := _var17 yearsWorkExperience.
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
