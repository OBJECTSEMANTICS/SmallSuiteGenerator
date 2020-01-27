Class {
	#name : #SInsertTest,
	#superclass : #SSTestCaseTest,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #tests }
SInsertTest >> setUp [ 
	super setUp.
	SConfiguration fileLogger: 'SInsertTestLogger.log'
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementAsParameterInMessage [
	| testCase anExpression |
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase addTargetClassName: #SFoo;
	addFactoryMessage: #SFoo;
	addLiteral;
	addMessage: #return: from: #SFoo.
	anExpression := testCase addLiteral.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_aSFoo0 := SFoo new.'
				with: '_aSStudent1 := ' , SStudent new storeString , '.'
				with: '_aSStudent2 := _aSFoo0 return: _aSStudent1.'
				with: '_aSStudent3 := ' , SStudent new storeString , '.').
	self
		should: [ testCase
				perform: #insertAsParameter:using:
				inStatement: anExpression copy ]
		raise: SError.
	testCase addMessage: #return: from: #SFoo.
	testCase
		perform: #insertAsParameter:using:
		inStatement: anExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_aSFoo0 := SFoo new.'
				with: '_aSStudent1 := ' , SStudent new storeString , '.'
				with: '_aSStudent2 := _aSFoo0 return: _aSStudent1.'
				with: '_aSStudent3 := ' , SStudent new storeString , '.'
				with: '_aSStudent4 := _aSFoo0 return: _aSStudent3.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfMixingSelectors [
	| testCase fieldAccess message |
	testCase := (SSTestCase with: utility typeInfosSStudent first)
		addTargetClassName: #SStudent;
		addLiteral: #SmallInteger;
		addFactoryMessage: #SStudent ofSelector: #new;
		addMessage: #scoreStudent: from: #SStudent;
		addFactoryMessage: #SStudent ofSelector: #new;
		addFieldAccessMessage: #idStudent from: #SStudent;
		yourself.
	self
		assertCollection: (testCase statements collect: #printString) allButLast
		hasSameElements:
			#('_aSmallInteger0 := 1.' '_aSStudent1 := SStudent new.' '_aSStudent2 := _aSStudent1 scoreStudent: _aSmallInteger0.' '_aSStudent3 := SStudent new.').
	self
		assert:
			(#('_aSmallInteger4 := _aSStudent1 idStudent.' '_aSmallInteger4 := _aSStudent2 idStudent.' '_aSmallInteger4 := _var3 idStudent.')
				includes: (testCase statementOfVarName: '_aSmallInteger4') printString).
	fieldAccess := testCase statementOfVarName: '_aSmallInteger4'.
	message := (testCase statementOfVarName: '_aSStudent2') value.
	message := testCase insertExpression: message copy after: fieldAccess.
	self
		assert: message printString
		equals: '_aSStudent5 := _aSStudent1 scoreStudent: _aSmallInteger0.'.
	message := testCase
		perform: #insertAsParameter:using:
		inStatement: fieldAccess.
	self
		assert: message printString
		equals: '_aSStudent5 := _aSStudent1 scoreStudent: _aSmallInteger4.'
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorAsParameterInFactoryMessage [
	| testCase auxExpr expression |
	testCase := SSTestCase with: utility typeInfoSFoo2.
	testCase addTargetClassName: #SFoo.
	expression := testCase addFactoryMessage.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSFoo0 := SFoo new.' '_aSFoo1 := SFoo new.').
	auxExpr := testCase addMessage.
	auxExpr value
		receiver: (testCase statementOfVarName: '_aSFoo1') variable.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_aSFoo2 := _aSFoo1 return: _aSFoo0.'
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorAsParameterInFieldMessage [
	| testCase aExpression |
	testCase := SSTestCase with: utility typeInfoSStack4.
	testCase addFactoryMessage: #SStack ofSelector: #newStack.
	aExpression := testCase
		addFieldAccessMessage: #lastLinkStack
		from: #SStack.
	testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSStack0 := SStack newStack.' '_aSmallInteger1 := _aSStack0 lastLinkStack.' '_aSmallInteger2 := 5.').
	testCase addMessage: #push: from: #SStack.
	testCase
		perform: #insertAsParameter:using:
		inStatement: aExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSStack0 := SStack newStack.' '_aSmallInteger1 := _aSStack0 lastLinkStack.' '_aSmallInteger2 := 5.' '_aSmallInteger3 := _aSStack0 push: _aSmallInteger1.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorAsParameterInMessage [
	| testCase aExpression |
	testCase := SSTestCase with: utility typeInfoSStack4.
	testCase addFactoryMessage: #SStack ofSelector: #newStackWith:.
	aExpression := testCase addMessage: #pop from: #SStack.
	testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_anArray0 := #(1 4 5 ).' '_aSStack1 := SStack newStackWith: _anArray0.' '_aSmallInteger2 := _aSStack1 pop.' '_aSmallInteger3 := 5.').
	testCase addMessage: #push: from: #SStack.
	testCase
		perform: #insertAsParameter:using:
		inStatement: aExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_anArray0 := #(1 4 5 ).' '_aSStack1 := SStack newStackWith: _anArray0.' '_aSmallInteger2 := _aSStack1 pop.' '_aSmallInteger3 := 5.' '_aSmallInteger4 := _aSStack1 push: _aSmallInteger2.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorMethodMessageInFactoryMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.').
	self
		should: [ testCase insertStatementOfSelector: #insertMethodMessage:using: ]
		raise: SError
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorMethodMessageInFieldMessage [
	| testCase fieldMessage |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	fieldMessage := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo1 score.').
	self
		should: [ testCase
				perform: #insertMethodMessage:using:
				inStatement: fieldMessage copy ]
		raise: SError
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorMethodMessageInLiteral [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallInteger0 := 5.').
	self
		should: [ testCase insertStatementOfSelector: #insertMethodMessage:using: ]
		raise: SError
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorMethodMessageInMessage [
	| testCase message |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	message := testCase addMessage: #returnNum from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallInteger2 := _aSFoo1 returnNum.').
	testCase
		perform: #insertMethodMessage:using:
		inStatement: message copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallInteger2 := _aSFoo1 returnNum.' '_aSmallInteger3 := _aSFoo1 returnNum.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInFactoryMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.').
	testCase insertStatementOfSelector: #insertRandomMessage:using:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSFoo2 := SFoo score: _aSmallFloat640.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInFieldMessage [
	| testCase fieldMessage |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	fieldMessage := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo1 score.').
	testCase
		perform: #insertRandomMessage:using:
		inStatement: fieldMessage copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aSmallFloat642 := _aSFoo1 score.' '_aSmallFloat643 := _aSFoo1 score.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInLiteral [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addLiteral: #SmallFloat64.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_aSmallFloat640 := 7.3.').
	self
		should: [ testCase insertStatementOfSelector: #insertRandomMessage:using: ]
		raise: SError
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInMessage [
	| testCase message |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	message := testCase addMessage: #return: from: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.').
	testCase
		perform: #insertRandomMessage:using:
		inStatement: message copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_aSmallFloat640 := 7.3.' '_aSFoo1 := SFoo score: _aSmallFloat640.' '_aByteString2 := ''hello''.' '_aByteString3 := _aSFoo1 return: _aByteString2.' '_aByteString4 := _aSFoo1 return: _aByteString2.')
]
