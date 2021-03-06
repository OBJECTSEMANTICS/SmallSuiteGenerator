Class {
	#name : #SChangeTest,
	#superclass : #SSTestCaseTest,
	#category : #'SmallSuiteGenerator-Tests-Core'
}

{ #category : #tests }
SChangeTest >> testArgumentChange [
	| testCase newTestCase targetClass index|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo100.
	testCase targetClassName: targetClass;
		addLiteral: #ByteString fullClassNameSymbol;
		addLiteral:#ByteString fullClassNameSymbol;
		addFactoryMessage: targetClass;
		addFactoryMessage: targetClass;
		addMessage: #return: from: targetClass.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := ''hello''' .
								'_var1 := ''hello''' .
								'_var2 := 4.7' .
								'_var3 := ', targetClass asString,' score: _var2 ' .
								'_var4 := ', targetClass asString,' score: _var2 ' .
								'_var5 := ''hello''' .
								'_var6 := _var3 return: _var1 '}.
	newTestCase := SSTestCase with: testCase typeInfo.
	index := 7.
	1 to: (index-1) do: [:i |
		|stm|
		stm := testCase statements at: i.
		newTestCase addStatement: stm copy.
		newTestCase assignId.].
	newTestCase addAlternativeArgsFor: (testCase statements at: index) value.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: { '_var0 := ''hello''' .
								'_var1 := ''hello''' .
								'_var2 := 4.7' .
								'_var3 := ', targetClass asString,' score: _var2 ' .
								'_var4 := ', targetClass asString,' score: _var2 ' .
								'_var5 := ''hello''' .
								'_var6 := _var3 return: _var5 '}.
									
	self assert: testCase validReferences.
]

{ #category : #tests }
SChangeTest >> testFactoryErrorChange [
	| testCase newTestCase targetClass index|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo100.
	testCase targetClassName: targetClass;
		addFactoryMessage: targetClass;
		addFactoryMessage: targetClass;
		addMessage: #return: from: targetClass.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3' .
								'_var1 := ', targetClass asString,' score: _var0 ' .
								'_var2 := ', targetClass asString,' score: _var0 ' .
								'_var3 := ''hello''' .
								'_var4 := _var2 return: _var3 '}.
	newTestCase := SSTestCase with: testCase typeInfo.
	index := 2.
	1 to: (index-1) do: [:i |
		|stm|
		stm := testCase statements at: i.
		newTestCase addStatement: stm copy.
		newTestCase assignId.].
	self should:[newTestCase addAlternativeFactoryMessage: (testCase statements at: index) value.] raise:SError.
	
]

{ #category : #tests }
SChangeTest >> testLiteralChange [
	| testCase newTestCase targetClass|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo100.
	testCase targetClassName: targetClass;
		addMessage: #return: from: targetClass.

	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3' .
								'_var1 := ', targetClass asString,' score: _var0 ' .
								'_var2 := ''hello''' .
								'_var3 := _var1 return: _var2 '}.

	newTestCase := testCase changeStatementAt: 1.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: { '_var0 := 344.09999999999997' .
								'_var1 := ', targetClass asString,' score: _var0 ' .
								'_var2 := ''hello''' .
								'_var3 := _var1 return: _var2 '}.	
									
	self assert: testCase validReferences.
]

{ #category : #tests }
SChangeTest >> testReceiverChange [
	| testCase newTestCase targetClass index|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo100.
	testCase targetClassName: targetClass;
		addFactoryMessage: targetClass;
		addFactoryMessage: targetClass;
		addMessage: #return: from: targetClass.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3' .
								'_var1 := ', targetClass asString,' score: _var0 ' .
								'_var2 := ', targetClass asString,' score: _var0 ' .
								'_var3 := ''hello''' .
								'_var4 := _var2 return: _var3 '}.
	newTestCase := SSTestCase with: testCase typeInfo.
	index := 5.
	1 to: (index-1) do: [:i |
		|stm|
		stm := testCase statements at: i.
		newTestCase addStatement: stm copy.
		newTestCase assignId.].
	newTestCase addAlternativeReceiverFor: (testCase statements at: index) value.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: { '_var0 := 7.3' .
								'_var1 := ', targetClass asString,' score: _var0 ' .
								'_var2 := ', targetClass asString,' score: _var0 ' .
								'_var3 := ''hello''' .
								'_var4 := _var1 return: _var3 '}.
									
	self assert: testCase validReferences.
]

{ #category : #tests }
SChangeTest >> testSelectorChange [
	| testCase newTestCase targetClass index|
	targetClass := 'SFoo' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo100.
	testCase targetClassName: targetClass;
		addLiteral: #SmallFloat64 fullClassNameSymbol;
		addFactoryMessage: targetClass;
		addFactoryMessage: targetClass;
		addMessage: #return: from: targetClass.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: { '_var0 := 4.7' .
								'_var1 := ', targetClass asString,' score: _var0 ' .
								'_var2 := ', targetClass asString,' score: _var0 ' .
								'_var3 := ''hello''' .
								'_var4 := _var1 return: _var3 '}.
	newTestCase := SSTestCase with: testCase typeInfo.
	index := 5.
	1 to: (index-1) do: [:i |
		|stm|
		stm := testCase statements at: i.
		newTestCase addStatement: stm copy.
		newTestCase assignId.].
	newTestCase addAlternativeSelectorFor: (testCase statements at: index) value.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements: { '_var0 := 4.7' .
								'_var1 := ', targetClass asString,' score: _var0 ' .
								'_var2 := ', targetClass asString,' score: _var0 ' .
								'_var3 := ''hello''' .
								'_var4 := _var1 returnString'}.
									
	self assert: testCase validReferences.
]
