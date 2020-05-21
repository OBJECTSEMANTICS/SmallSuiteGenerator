Class {
	#name : #SMessageTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SMessageTest >> testCopy [
	| message copy |
	message := SMessage new
		receiver: (SVariable new id: 1; returnType: #SFoo);
		selector: #return:;
		args:
			(Array
				with:
					(SVariable new
						id: 2;
						returnType: #ByteString));
		returnType: #ByteString.
	self assert: message printString equals: '_var1 return: _var2'.
	copy := message copy.
	copy value args first id: 5.
	self assert: copy printString equals: '_var1 return: _var5'.
	copy value receiver varName: '_sfoo'.
	copy value receiver id: 4.
	self assert: copy printString equals: '_sfoo4 return: _var5'.
	copy value selector: #returnValue:.
	self assert: copy printString equals: '_sfoo4 returnValue: _var5'.
	self assert: message printString equals: '_var1 return: _var2'
]

{ #category : #tests }
SMessageTest >> testInsertAsParameterUsing [
	| testCase aExpression insertedExpression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf: #SFoo); 
	addFactoryMessage: (self fullSymbolOf: #SFoo); addLiteral: (self fullSymbolOf: #ByteString).
	aExpression := testCase addMessage: #returnString from: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3.'
									with: ('_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var0.')
									with: '_var2 := ''hello''.'
									with: '_var3 := _var1 returnString.').
	testCase addMessage: #return: from: (self fullSymbolOf: #SFoo).
	insertedExpression := aExpression
		insertAsParameter: aExpression
		using: testCase.
	self
		assert:
			(#('_var4 := _var1 return: _var3.')
				includes: insertedExpression printString)
]

{ #category : #tests }
SMessageTest >> testInsertMethodMessageUsing [
	| testCase message |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: (self fullSymbolOf: #SFoo).
	message := testCase addMessage: #return: from: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: ('_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var0.')
									with: '_var2 := ''hello''.'
									with: '_var3 := _var1 return: _var2.').
	message insertMethodMessage: message using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: ('_var1 := ',(self fullNameOfClass: 'SFoo')asString,' score: _var0.')
									with: '_var2 := ''hello''.'
									with: '_var3 := _var1 return: _var2.'
									with: '_var4 := _var1 return: _var2.').
]
