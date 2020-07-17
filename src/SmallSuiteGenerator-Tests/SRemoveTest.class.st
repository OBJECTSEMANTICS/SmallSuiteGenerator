Class {
	#name : #SRemoveTest,
	#superclass : #SSTestCaseTest,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveArgsFactoryMessage [
	| testCase newTestCase|
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase
		targetClassName: ('SFoo' fullClassNameSymbol );
		addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: '_var1 := ', 'SFoo' fullClassName,' score: _var0.').
									
	newTestCase := testCase removeStatementAt: 1.
	
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: (Array new).
	self assert: newTestCase validReferences
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveArgsMessage [
	| testCase newTestCase targetClass|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: targetClass;
	addMessage: #return: from: targetClass.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ', targetClass asString,' score: _var0.' .
								'_var2 := ''hello''.' .
								'_var3 := _var1 return: _var2.'}.
	newTestCase := testCase removeStatementAt: 3.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: (Array 
									with: '_var0 := 7.3.'
									with: '_var1 := ', targetClass asString,' score: _var0.').
	self assert: testCase validReferences
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveArgsMessage2 [
	| testCase newTestCase targetClass|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: targetClass.
	testCase 
			addMessage: #return: from: targetClass;
			addMessage: #return: from: targetClass.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ', targetClass asString,' score: _var0.' .
								'_var2 := ''hello''.' .
								'_var3 := _var1 return: _var2.'.
								'_var4 := _var1 return: _var3.'}.
	newTestCase := testCase removeStatementAt: 4.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ', targetClass asString,' score: _var0.' .
								'_var2 := ''hello''.' .
								'_var3 := _var1 return: _var2.'.}.
	self assert: newTestCase validReferences
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveFactoryMessage [
	| testCase newTestCase targetClass|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: targetClass;
	addFactoryMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: (Array
									with: '_var0 := 7.3.'
									with: '_var1 := ', targetClass asString,' score: _var0.').
	newTestCase := testCase removeStatementAt: 2.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: #('_var0 := 7.3.').
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveFieldAccessMessage [
	| testCase newTestCase|
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: (self fullSymbolOf: #SFoo);
	addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.'.
							   '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.' .
								'_var2 := _var1 score.'}.
	newTestCase := testCase removeStatementAt: 3.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.'}
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveMessage [
	| testCase targetClass newTestCase|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: targetClass;
	addMessage: #return: from: targetClass.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								 '_var1 := ', targetClass asString,' score: _var0.' .
								 '_var2 := ''hello''.' .
								 '_var3 := _var1 return: _var2.'}.
	newTestCase := testCase removeStatementAt: 4.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements:  {'_var0 := 7.3.' .
								 '_var1 := ', (self fullNameOfClass: 'SFoo')asString,' score: _var0.' .
								 '_var2 := ''hello''.'}
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveReceiverFieldAccessMessage [
	| testCase targetClass newTestCase|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: targetClass;
	addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ', targetClass asString,' score: _var0.' .
								'_var2 := _var1 score.'}.
	newTestCase := testCase removeStatementAt: 2.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: {'_var0 := 7.3.'}
]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveReceiverFieldAccessMessage2 [
	| testCase targetClass newTestCase|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: targetClass;
	addFactoryMessage;
	addFactoryMessage;
	addFieldAccessMessage.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ', targetClass asString,' score: _var0.' .
								'_var2 := ', targetClass asString,' score: _var0.' .
								'_var3 := _var2 score.'}.
	newTestCase := testCase removeStatementAt: 3.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ', targetClass asString,' score: _var0.' .
								'_var2 := _var1 score.'}.
		
	

]

{ #category : #'mutation-remove' }
SRemoveTest >> testRemoveReceiverMessage [
	| testCase targetClass newTestCase|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo1.
	testCase targetClassName: targetClass;
	addMessage: #return: from: targetClass.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ', targetClass asString,' score: _var0.' .
								'_var2 := ''hello''.' .
								'_var3 := _var1 return: _var2.'}.
	newTestCase := testCase removeStatementAt: 2.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3.' .
								'_var1 := ''hello''.'}
]
