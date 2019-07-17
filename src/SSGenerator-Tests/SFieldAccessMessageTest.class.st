Class {
	#name : #SFieldAccessMessageTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests-Nodes'
}

{ #category : #tests }
SFieldAccessMessageTest >> testInsertRandomMessageUsing [
	| testCase fieldMessage |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	fieldMessage := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.' . '_var1 := SFoo score: _var0.'. '_var2 := _var1 score.'}.
	fieldMessage insertRandomMessageUsing: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			{'_var0 := 7.3.' . 
			'_var1 := SFoo score: _var0.'. '_var2 := _var1 score.'. '_var3 := _var1 score.'}
]
