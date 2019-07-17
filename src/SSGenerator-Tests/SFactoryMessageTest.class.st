Class {
	#name : #SFactoryMessageTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests-Nodes'
}

{ #category : #tests }
SFactoryMessageTest >> testInsertMethodMessageUsing [
	| testCase  factoryMessage |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	factoryMessage := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}.
	factoryMessage insertMethodMessageUsing: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}
]

{ #category : #tests }
SFactoryMessageTest >> testInsertParameterUsing [
	| testCase factoryMessage |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	factoryMessage := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}.
	factoryMessage insertParameterUsing: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'. '_var2 := 7.3.'}
]

{ #category : #tests }
SFactoryMessageTest >> testInsertRandomMessageUsing [
	| testCase factoryMessage |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	factoryMessage := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'}.
	factoryMessage insertRandomMessageUsing: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			{'_var0 := 7.3.' . '_var2 := SFoo score: _var0.'.
			'_var1 := SFoo score: _var0.'}
]
