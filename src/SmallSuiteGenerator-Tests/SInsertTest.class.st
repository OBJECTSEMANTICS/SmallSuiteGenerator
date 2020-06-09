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
	testCase addTargetClassName: (self fullSymbolOf: #SFoo);
	addFactoryMessage: (self fullSymbolOf: #SFoo);
	addLiteral;
	addMessage: #return: from: (self fullSymbolOf: #SFoo).
	anExpression := testCase addLiteral.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ', (self fullNameOfClass: 'SFoo')asString,' new.'
				with: '_var1 := ' , SStudent new storeString , '.'
				with: '_var2 := ' , SStudent new storeString , '.'
				with: '_var3 := _var0 return: _var2.'
				with: '_var4 := ' , SStudent new storeString , '.').
	self
		should: [ testCase
				perform: #insertAsParameter:using:
				inStatement: anExpression copy ]
		raise: SError.
	testCase addMessage: #return: from: (self fullSymbolOf: #SFoo).
	testCase
		perform: #insertAsParameter:using:
		inStatement: anExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			(Array
				with: '_var0 := ', (self fullNameOfClass: 'SFoo')asString,' new.'
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
		addTargetClassName: (self fullSymbolOf: #SStudent);
		addLiteral: (self fullSymbolOf: #SmallInteger);
		addFactoryMessage: (self fullSymbolOf: #SStudent) ofSelector: #new;
		addMessage: #scoreStudent: from: (self fullSymbolOf: #SStudent);
		addFactoryMessage: (self fullSymbolOf: #SStudent) ofSelector: #new;
		addFieldAccessMessage: #idStudent from: (self fullSymbolOf: #SStudent);
		yourself.
	self
		assertCollection: (testCase statements collect: #printString) allButLast
		hasSameElements: (Array
									with: '_var0 := 1.'
									with: '_var1 := ',(self fullNameOfClass: 'SStudent')asString,' new.'
									with: '_var2 := 1.'
									with: '_var3 := _var1 scoreStudent: _var2.'
									with: '_var4 := ',(self fullNameOfClass: 'SStudent')asString,' new.').
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
	testCase addTargetClassName: (self fullSymbolOf: #SFoo).
	expression := testCase addFactoryMessage.
	testCase addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: ('_var0 := ', (self fullNameOfClass: 'SFoo')asString,' new.')
									with: ('_var1 := ', (self fullNameOfClass: 'SFoo')asString,' new.')).
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
	testCase := (SSTestCase with: utility typeInfoSStack4) addTargetClassName: (self fullSymbolOf: #SStack).
	testCase addFactoryMessage: (self fullSymbolOf: #SStack) ofSelector: #newStack.
	aExpression := testCase
		addFieldAccessMessage: #lastLinkStack
		from: (self fullSymbolOf: #SStack).
	testCase addLiteral: (self fullSymbolOf: #SmallInteger).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 	
									with: ('_var0 := ', (self fullNameOfClass: 'SStack')asString,' newStack.')
									with: '_var1 := _var0 lastLinkStack.'
									with: '_var2 := 5.').
	testCase addMessage: #push: from: (self fullSymbolOf: #SStack).
	testCase
		perform: #insertAsParameter:using:
		inStatement: aExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 	
									with: ('_var0 := ', (self fullNameOfClass: 'SStack')asString,' newStack.')
									with: '_var1 := _var0 lastLinkStack.'
									with: '_var2 := 5.'
									with: '_var3 := 5.'
									with: '_var4 := _var0 push: _var1.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorAsParameterInMessage [
	| testCase aExpression |
	testCase := (SSTestCase with: utility typeInfoSStack4) addTargetClassName: (self fullSymbolOf: #SStack).
	testCase addFactoryMessage: (self fullSymbolOf: #SStack) ofSelector: #newStackWith:.
	aExpression := testCase addMessage: #pop from: (self fullSymbolOf: #SStack).
	testCase addLiteral: (self fullSymbolOf: #SmallInteger).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := #(1 4 5 ).'
									with: '_var1 := ', (self fullNameOfClass: 'SStack')asString,' newStackWith: _var0.'
									with: '_var2 := _var1 pop.' 
									with: '_var3 := 5.').
	testCase addMessage: #push: from: (self fullSymbolOf: #SStack).
	testCase
		perform: #insertAsParameter:using:
		inStatement: aExpression copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := #(1 4 5 ).'
									with: '_var1 := ', (self fullNameOfClass: 'SStack')asString,' newStackWith: _var0.'
									with: '_var2 := _var1 pop.'
									with: '_var3 := 5.'
									with: '_var4 := _var1 push: _var2.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorMethodMessageInFactoryMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf: #SFoo);
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.' 
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.').
	self
		should: [ testCase insertStatementOfSelector: #insertMethodMessage:using: ]
		raise: SError
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorMethodMessageInFieldMessage [
	| testCase fieldMessage |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf: #SFoo).
	fieldMessage := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
									with: '_var2 := _var1 score.').
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
	testCase addLiteral: (self fullSymbolOf: #SmallInteger).
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
	testCase addTargetClassName: (self fullSymbolOf: #SFoo).
	message := testCase addMessage: #returnNum from: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.' 
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
									with: '_var2 := _var1 returnNum.').
	testCase
		perform: #insertMethodMessage:using:
		inStatement: message copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
									with: '_var2 := _var1 returnNum.'
									with: '_var3 := _var1 returnNum.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInFactoryMessage [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf: #SFoo);
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with:	'_var0 := 7.3.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.').
	testCase insertStatementOfSelector: #insertRandomMessage:using:.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
									with: '_var2 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInFieldMessage [
	| testCase fieldMessage |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf: #SFoo).
	fieldMessage := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
									with: '_var2 := _var1 score.').
	testCase
		perform: #insertRandomMessage:using:
		inStatement: fieldMessage copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
									with: '_var2 := _var1 score.'
									with: '_var3 := _var1 score.')
]

{ #category : #'mutation-insert' }
SInsertTest >> testInsertStatementOfSelectorRandomMessageInLiteral [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addLiteral: (self fullSymbolOf: #SmallFloat64).
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
	testCase addTargetClassName: (self fullSymbolOf: #SFoo).
	message := testCase addMessage: #return: from: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
									with: '_var2 := ''hello''.'
									with: '_var3 := _var1 return: _var2.').
	testCase
		perform: #insertRandomMessage:using:
		inStatement: message copy.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'
									with: '_var2 := ''hello''.'
									with: '_var3 := _var1 return: _var2.'
									with: '_var4 := _var1 return: _var2.')
]
