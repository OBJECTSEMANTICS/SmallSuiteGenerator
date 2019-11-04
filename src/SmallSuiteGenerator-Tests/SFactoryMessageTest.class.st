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
	testCase addTargetClassName: #SFoo.
	expression := testCase addFactoryMessage: #SFoo.
	testCase addMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := SFoo new.' '_var1 := _var0 return: _var0.').
	insertedExpression := expression
		insertAsParameter: expression
		using: testCase.
	self
		assert:
			(#('_var1 := _var0 return: _var0.')
				includes: insertedExpression printString)
]

{ #category : #tests }
SFactoryMessageTest >> testInsertMethodMessageUsing [
	| testCase expression |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	expression := testCase addFactoryMessage: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	self
		should: [ expression insertMethodMessage: expression using: testCase ]
		raise: SError
]

{ #category : #tests }
SFactoryMessageTest >> testInsertRandomMessageUsing [
	| testCase factoryMessage |
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase addTargetClassName: #SFoo.
	factoryMessage := testCase addFactoryMessage: #SFoo.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.' '_var1 := SFoo score: _var0.').
	factoryMessage insertRandomMessage: factoryMessage using: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll:
			#('_var0 := 7.3.' '_var2 := SFoo score: _var0.' '_var1 := SFoo score: _var0.')
]
