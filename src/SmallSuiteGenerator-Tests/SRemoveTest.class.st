Class {
	#name : #SRemoveTest,
	#superclass : #SSTestCaseTest,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveArgsFactoryMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	testCase removeStatementOfVarName: '_var0'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var2 := 7.3.' '_var1 := SFoo score: _var2.').
	self assert: testCase validReferences
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveArgsMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	testCase removeStatementOfVarName: '_var2'.
	self
		assert:
			(#('_var4 := ''hello''.' '_var4 := _var1 returnString.')
				includes: (testCase statementOfVarName: '_var4') printString).
	self
		assert: (testCase statementOfVarName: '_var3') printString
		equals: '_var3 := _var1 return: _var4.'.
	self assert: testCase validReferences
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveFactoryMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	testCase removeStatementOfVarName: '_var1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.')
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.').
	testCase removeStatementOfVarName: '_var2'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.')
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	testCase removeStatementOfVarName: '_var3'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.')
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveReceiverFieldAccessMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.').
	testCase removeStatementOfVarName: '_var1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var3 := SFoo score: _var0.' '_var2 := _var3 score.')
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveReceiverMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	testCase removeStatementOfVarName: '_var1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var4 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var4 return: _var2.')
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveStatementNoRepairing [
	| testCase statement |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	statement := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	testCase removeStatementNoRepairing: statement.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.').
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	statement := testCase addFactoryMessage.
	testCase addMessage: #returnFloat from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 returnFloat.').
	testCase removeStatementNoRepairing: statement.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.')
]
