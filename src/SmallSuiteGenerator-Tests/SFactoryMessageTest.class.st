Class {
	#name : #SFactoryMessageTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SFactoryMessageTest >> testCopy [
	| expression copy |
	expression := SFactoryMessage new
		receiver: (SVariable name: #SFoo);
		selector: #score:;
		args: (Array with: (SVariable new id: 0));
		yourself.
	self assert: expression printString equals: 'SFoo score: _var0'.
	copy := expression copy.
	self assert: copy printString equals: expression printString.
	copy value args first id: 1.
	self assert: copy printString equals: 'SFoo score: _var1'.
	copy value receiver varName: #SStudent.
	self assert: copy printString equals: 'SStudent score: _var1'.
	copy value selector: #name:.
	self assert: copy printString equals: 'SStudent name: _var1'.
	self assert: expression printString equals: 'SFoo score: _var0'
]

{ #category : #tests }
SFactoryMessageTest >> testInsertAsParameterUsing [
	| testCase expression insertedExpression |
	testCase := SSTestCase with: utility typeInfoSFoo2.
	testCase targetClassName: (self fullSymbolOf: #SFoo).
	expression := testCase addFactoryMessage: (self fullSymbolOf: #SFoo).
	testCase addMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: ('_var0 := ', (self fullNameOfClass: 'SFoo') asString, ' new.') 
									with: ('_var1 := ', (self fullNameOfClass: 'SFoo') asString, ' new.') 
									with: '_var2 := _var0 return: _var0.').
	insertedExpression := expression
		insertAsParameter: expression
		using: testCase.
	self
		assert:
			(#('_var2 := _var0 return: _var0.')
				includes: insertedExpression printString)
]

{ #category : #tests }
SFactoryMessageTest >> testInsertMethodMessageUsing [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: (self fullSymbolOf: #SFoo).
	expression := testCase addFactoryMessage: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: ('_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.')).
	self
		should: [ expression insertMethodMessage: expression using: testCase ]
		raise: SError
]

{ #category : #tests }
SFactoryMessageTest >> testInsertRandomMessageUsing [
	| testCase factoryMessage |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: (self fullSymbolOf: #SFoo).
	factoryMessage := testCase addFactoryMessage: (self fullSymbolOf: #SFoo).
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.' 
									with: ('_var1 := ', (self fullNameOfClass: 'SFoo')asString, ' score: _var0.')).
	factoryMessage insertRandomMessage: factoryMessage using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: (Array 
									with: '_var0 := 7.3.' 
									with: ('_var2 := ', (self fullNameOfClass: 'SFoo')asString, ' score: _var0.')
									with: ('_var1 := ', (self fullNameOfClass: 'SFoo')asString, ' score: _var0.')).
]
