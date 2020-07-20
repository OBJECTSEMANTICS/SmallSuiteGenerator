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
SInsertTest >> testCopyWithANewMethodCallToAnArgumentOfTheTargetClass [
	| testCase targetClass studentClass newTestCase |
	targetClass := 'SFoo' fullClassNameSymbol.
	studentClass := 'SStudent' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase 
			targetClassName: targetClass;
			addFactoryMessage: targetClass;
			addFactoryMessage: studentClass;
			addFactoryMessage: studentClass;
			addMessage: #return: from: targetClass.
	
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{  '_var0 := ', targetClass asString,' new' .
				'_var1 := ' , studentClass asString, ' new' .
				'_var2 := ' , studentClass asString, ' new' .
				'_var3 := _var0 return: _var1 '}.
	newTestCase := testCase copyWithANewMethodCallToAnArgumentOfTheTargetClass.
	newTestCase repairIds.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements:
			{  '_var0 := ', targetClass asString,' new' .
				'_var1 := ' , studentClass asString, ' new' .
				'_var2 := ' , studentClass asString, ' new' .
				'_var3 := _var1 initialize' .
				'_var4 := _var0 return: _var1 '}.
]

{ #category : #'mutation-insert' }
SInsertTest >> testCopyWithANewMethodCallToAnyValue [
	| testCase targetClass studentClass newTestCase |
	targetClass := 'SFoo' fullClassNameSymbol.
	studentClass := 'SStudent' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase 
			targetClassName: targetClass;
			addFactoryMessage: targetClass;
			addFactoryMessage: studentClass;
			addFactoryMessage: studentClass;
			addMessage: #return: from: targetClass.
	
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{  '_var0 := ', targetClass asString,' new' .
				'_var1 := ' , studentClass asString, ' new' .
				'_var2 := ' , studentClass asString, ' new' .
				'_var3 := _var0 return: _var1 '}.
	newTestCase := testCase copyWithANewMethodCallToAnyValue.
	newTestCase repairIds.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements:
			{  '_var0 := ', targetClass asString,' new' .
				'_var1 := ' , studentClass asString, ' new' .
				'_var2 := ' , studentClass asString, ' new' .
				'_var3 := _var2 initialize' .
				'_var4 := _var0 return: _var1 '}.
]

{ #category : #'mutation-insert' }
SInsertTest >> testCopyWithANewMethodCallToTargetClass [
	| testCase targetClass studentClass newTestCase |
	targetClass := 'SFoo' fullClassNameSymbol.
	studentClass := 'SStudent' fullClassNameSymbol.
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase 
			targetClassName: targetClass;
			addFactoryMessage: targetClass;
			addMessage: #return: from: targetClass.
	
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements:
			{  '_var0 := ', targetClass asString,' new' .
				'_var1 := ' , studentClass asString, ' new' .
				'_var2 := _var0 return: _var1 '}.
	newTestCase := testCase copyWithANewMethodCallToTargetClass.
	newTestCase repairIds.
	self
		assertCollection: (newTestCase statements collect: #printString)
		hasSameElements:
			{  '_var0 := ', targetClass asString,' new' .
				'_var1 := ' , studentClass asString, ' new' .
				'_var2 := _var0 initialize' .
				'_var3 := _var0 return: _var1 '}.
]
