Class {
	#name : #SRefactoringTest,
	#superclass : #TestCase,
	#instVars : [
		'refactorTest'
	],
	#category : #'SmallSuiteGeneratorTest-Refactorization'
}

{ #category : #tests }
SRefactoringTest >> all: keys keysAreVarNames: varNames [
	^ varNames includesAll: keys
]

{ #category : #running }
SRefactoringTest >> setUp [
	refactorTest := SRefactoring
]

{ #category : #tests }
SRefactoringTest >> testDictReferencesOfMethodStatements [
	| testCase dictReferences |
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #SmallInteger;
				value: 45);
		addStatement:
			(SConstructorStatement new
				theClassName: 'SFoo';
				selector: 'score:';
				args: {'_var0'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_var0'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '(SFoo score: ''_var1'' )';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_var0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	self
		assertCollection: dictReferences associations
		equals:
			{('_var0'
				-> (OrderedCollection newFrom: {'_var1' . '_var2' . '_var3'})).
			('_var1' -> (OrderedCollection newFrom: {'_var2' . '_var3'}))}.
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #ByteString;
				value: 'Mary';
				varKeyword: '_bytStr');
		addStatement:
			(SConstructorStatement new
				theClassName: 'SStudent';
				selector: 'name:';
				args: {'_bytStr0'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_bytStr0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #ByteString;
				value: 'Mary';
				varKeyword: 'otherVar');
		addStatement:
			(SConstructorStatement new
				theClassName: 'SStudent';
				selector: 'name:';
				args: {'otherVar0'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'otherVar0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #SmallInteger;
				value: 45);
		addStatement:
			(SConstructorStatement new
				theClassName: 'SStudent';
				selector: 'name:with:';
				args: {'Sussy' . '_var0'});
		addStatement:
			(SFieldStatement new
				receiverVarName: '_var1';
				fieldName: #scoreStudent;
				returnTypeName: #SmallInteger);
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #scoreStudent:;
				returnTypeName: #ByteString;
				args: {'_var2'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '(SFoo score: ''_var1'' )';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_var0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	self
		assertCollection: dictReferences associations
		hasSameElements:
			{('_var0' -> (OrderedCollection newFrom: {'_var1' . '_var4'})).
			('_var1' -> (OrderedCollection
				newFrom: {'_var2' . '_var3' . '_var4'})).
			('_var2' -> (OrderedCollection newFrom: {'_var3'}))}
]

{ #category : #tests }
SRefactoringTest >> testDictReferencesOfPrimitiveStatements [
	| testCase dictReferences |
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #SmallInteger;
				value: 45);
		addStatement:
			(SConstructorStatement new
				theClassName: 'SFoo';
				selector: 'score:';
				args: {'_var0'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_var0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #ByteString;
				value: 'Mary';
				varKeyword: '_bytStr');
		addStatement:
			(SConstructorStatement new
				theClassName: 'SStudent';
				selector: 'name:';
				args: {'_bytStr0'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_bytStr0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #ByteString;
				value: 'Mary';
				varKeyword: 'otherVar');
		addStatement:
			(SConstructorStatement new
				theClassName: 'SStudent';
				selector: 'name:';
				args: {'otherVar0'});
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'otherVar0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames)
]
