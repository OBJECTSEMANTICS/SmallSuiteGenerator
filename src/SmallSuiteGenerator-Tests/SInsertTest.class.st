Class {
	#name : #SInsertTest,
	#superclass : #SSTestCaseTest,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #tests }
SInsertTest >> setUp [ 
	super setUp.
	SPlatform fileLogger: 'SInsertTestLogger.log'
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
				with: '_var0 := SFoo new.'
				with: '_var1 := ' , SStudent new storeString , '.'
				with: '_var2 := ' , SStudent new storeString , '.'
				with: '_var3 := _var0 return: _var2.'
				with: '_var4 := ' , SStudent new storeString , '.').
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
				with: '_var0 := SFoo new.'
				with: '_var1 := ' , SStudent new storeString , '.'
				with: '_var2 := ' , SStudent new storeString , '.'
				with: '_var3 := _var0 return: _var2.'
				with: '_var4 := ' , SStudent new storeString , '.'
				with: '_var5 := _var0 return: _var4.')
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
			#('_var0 := 1.' '_var1 := SStudent new.' '_var2 := 1.' '_var3 := _var1 scoreStudent: _var2.' '_var4 := SStudent new.').
	self
		assert:
			(#('_var5 := _var4 idStudent.')
				includes: (testCase statementOfVarName: '_var5') printString).
	fieldAccess := testCase statementOfVarName: '_var5'.
	message := (testCase statementOfVarName: '_var2') value.
	message := testCase insertExpression: message copy after: fieldAccess.
	self
		assert: message printString
		equals: '_var6 := 1.'.
	"message := testCase
		perform: #insertAsParameter:using:
		inStatement: fieldAccess.
	self
		assert: message printString
		equals: '_var5 := _var1 scoreStudent: _var4.'"
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
		hasSameElements: #('_var0 := SFoo new.' '_var1 := SFoo new.').
	auxExpr := testCase addMessage.
	auxExpr value
		receiver: (testCase statementOfVarName: '_var1') variable.
	auxExpr := testCase
		perform: #insertAsParameter:using:
		inStatement: expression.
	self
		assert: auxExpr printString
		equals: '_var3 := _var1 return: _var0.'
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
			#('_var0 := SStack newStack.' '_var1 := _var0 lastLinkStack.' '_var2 := 5.').
	testCase addMessage: #push: from: #SStack.
	testCase
		perform: #insertAsParameter:using:
		inStatement: aExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := SStack newStack.' '_var1 := _var0 lastLinkStack.' '_var2 := 5.' '_var3 := 5.' '_var4 := _var0 push: _var1.')
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
			#('_var0 := #(1 4 5 ).' '_var1 := SStack newStackWith: _var0.' '_var2 := _var1 pop.' '_var3 := 5.').
	testCase addMessage: #push: from: #SStack.
	testCase
		perform: #insertAsParameter:using:
		inStatement: aExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := #(1 4 5 ).' '_var1 := SStack newStackWith: _var0.' '_var2 := _var1 pop.' '_var3 := 5.' '_var4 := _var1 push: _var2.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorMethodMessageInFactoryMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
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
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.').
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
		hasSameElements: #('_var0 := 5.').
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
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 returnNum.').
	testCase
		perform: #insertMethodMessage:using:
		inStatement: message copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 returnNum.' '_var3 := _var1 returnNum.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInFactoryMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo;
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	testCase insertStatementOfSelector: #insertRandomMessage:using:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := SFoo score: _var0.')
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
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.').
	testCase
		perform: #insertRandomMessage:using:
		inStatement: fieldMessage copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := _var1 score.' '_var3 := _var1 score.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInLiteral [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addLiteral: #SmallFloat64.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.').
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
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.').
	testCase
		perform: #insertRandomMessage:using:
		inStatement: message copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			#('_var0 := 7.3.' '_var1 := SFoo score: _var0.' '_var2 := ''hello''.' '_var3 := _var1 return: _var2.' '_var4 := _var1 return: _var2.')
]
