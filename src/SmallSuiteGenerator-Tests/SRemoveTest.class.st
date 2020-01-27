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
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.').
	testCase removeStatementOfVarName: '_aSmallFloat640'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat642 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat642.').
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
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.').
	testCase removeStatementOfVarName: '_aByteString2'.
	self
		assert:
			(#('_aByteString4 := ''hello''.' '_aByteString4 := _aSFoo1 returnString.')
				includes: (testCase statementOfVarName: '_aByteString4') printString).
	self
		assert: (testCase statementOfVarName: '_aByteString3') printString
		equals: '_aByteString3 := _aSFoo1 return: _aByteString4.'.
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
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.').
	testCase removeStatementOfVarName: '_aSFoo1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.')
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
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo1 score.').
	testCase removeStatementOfVarName: '_aSmallFloat642'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.')
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
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.').
	testCase removeStatementOfVarName: '_aByteString3'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.')
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
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo1 score.').
	testCase removeStatementOfVarName: '_aSFoo1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo3 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo3 score.')
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
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.').
	testCase removeStatementOfVarName: '_aSFoo1'.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo4 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo4 return: _aByteString2.')
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveStatementNoRepairing [
	| testCase statement |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	statement := testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.').
	testCase removeStatementNoRepairing: statement.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.').
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	statement := testCase addFactoryMessage.
	testCase addMessage: #returnFloat from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo1 returnFloat.').
	testCase removeStatementNoRepairing: statement.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.')
]
