Class {
	#name : #SFieldAccessMessageTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SFieldAccessMessageTest >> testCopy [
	| expression copy |
	expression := SFieldAccessMessage new
		receiver:
			(SVariable new
				id: 0;
				returnType: #SStack);
		selector: #firstLinkStack.
	self assert: expression printString equals: '_var0 firstLinkStack'.
	copy := expression copy.
	copy value receiver varName: '_sstack'.
	copy value receiver id: 4.
	self assert: copy printString equals: '_sstack4 firstLinkStack'.
	copy value selector: #lastLinkStack.
	self assert: copy printString equals: '_sstack4 lastLinkStack'.
	self assert: expression printString equals: '_var0 firstLinkStack'
]

{ #category : #tests }
SFieldAccessMessageTest >> testInsertAsParameterUsing [
	| testCase expression insertedExpression |
	testCase := (SSTestCase with: utility typeInfoSSTeacher1)
		addTargetClassName: (self fullSymbolOf: #SSTeacher).
	testCase addFactoryMessage: (self fullSymbolOf: #SSTeacher).
	expression := testCase
		addFieldAccessMessage: #yearsWorkExperience
		from: (self fullSymbolOf: #SSTeacher).
	testCase addLiteral: (self fullSymbolOf: #SmallInteger).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
								with: ('_var0 := ', (self fullNameOfClass: 'SSTeacher')asString, ' new.')
								with: '_var1 := _var0 yearsWorkExperience.'
								with: '_var2 := 0.').
	testCase addMessage: #yearsWorkExperience: from: (self fullSymbolOf: #SSTeacher).
	insertedExpression := expression
		insertAsParameter: expression
		using: testCase.
	self
		assert: insertedExpression printString
		equals: '_var3 := _var0 yearsWorkExperience: _var1.'
]

{ #category : #tests }
SFieldAccessMessageTest >> testInsertRandomMessageUsing [
	| testCase aExpression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf: #SFoo);
	addFactoryMessage: (self fullSymbolOf: #SFoo).
	aExpression := testCase addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: ('_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.')
									with: '_var2 := _var1 score.').
	aExpression insertRandomMessage: aExpression using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: (Array 
								with: '_var0 := 7.3.'
								with: ('_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.')
								with: '_var2 := _var1 score.'
								with: '_var3 := _var1 score.')
]
