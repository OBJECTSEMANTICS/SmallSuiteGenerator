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
	| _var18 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var16 _var0 _var8 _var9 _var10 _var11 _var13 _var14 |
_var18 := 400.
_var1 := 'teacher_teacher_teacher_Ann'.
_var2 := SSTeacher name: _var1 with: _var18.
_var3 := _var2 resetIdTeacher.
_var4 := _var2 idTeacher.
_var5 := _var2 id: _var4.
_var6 := _var5 resetYearsWorkExperience.
_var7 := _var2 yearsWorkExperience.
_var16 := _var2 resetIdTeacher.
_var0 := _var5 yearsWorkExperience.
_var8 := _var2 yearsWorkExperience.
_var9 := _var2 nickname.
_var10 := _var6 idTeacher.
_var11 := _var6 yearsWorkExperience.
_var13 := SConference price: _var7.
_var14 := _var13 price: _var0.
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
