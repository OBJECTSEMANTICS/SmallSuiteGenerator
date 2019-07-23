Class {
	#name : #SMessageTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests-Nodes'
}

{ #category : #tests }
SMessageTest >> testInsertMethodMessageUsing [
	| testCase message |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	message := testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var1 return: _var2.'}.
	message insertMethodMessage: message using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'.
			'_var2 := ''hello''.' . '_var3 := _var1 return: _var2.'.
			'_var4 := _var1 return: _var2.'}
]
