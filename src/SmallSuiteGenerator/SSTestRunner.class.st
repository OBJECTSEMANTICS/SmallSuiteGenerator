Class {
	#name : #SSTestRunner,
	#superclass : #TestCase,
	#instVars : [
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
SSTestRunner >> compile: aTestCase usingParsing: aSymbol [ 
	| compiled testCaseCopy |
	compiled := false.
	testCaseCopy := aTestCase.
	"testCaseCopy := aTestCase copy."
	[ compiled ] whileFalse: [ 
		|aBlock | 
		aBlock := testCaseCopy perform: aSymbol.
		[ self compile: aBlock.
		compiled := true ] on: Error do: [ 
		
			testCaseCopy removeStatementNoRepairing: (testCaseCopy randomStatement) 
		] 
	].
	^ testCaseCopy 
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
	^ [ self performTest ] on: Error do: [ self halt.
		aSTestCase removeStatementNoRepairing: (aSTestCase randomStatement ).
		self evaluate: aSTestCase ]
]

{ #category : #initialization }
SSTestRunner >> initialize [
	invariants := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SSTestRunner >> performTest [
	| _var0 _var1 _var2 _var3 _var4 |
_var0 := '1'.
_var1 := 0.
_var2 := SSTeacher name: _var0 with: _var1.
_var3 := SConference price: _var1.
_var4 := _var2 canRegister: _var3.
^ self analyze: thisContext
]

{ #category : #running }
SSTestRunner >> run: aSTestCase [
	|testCase|
  	[testCase := self compile: aSTestCase parseTreeWithAssertions] on: Error 
	do: [ SError signal: 'Error to compile the testCase with assertions.' ].
  	self runTest.
	^ testCase
]

{ #category : #'as yet unclassified' }
SSTestRunner >> runTest [
	self setTestSelector: #performTest.
	self run.
]

{ #category : #running }
SSTestRunner >> runWithoutAssertions: aSTestCase [
	| testCase |
  	testCase := self compile: aSTestCase usingParsing: #parseTree.
  	self runTest.
	^ testCase
]
