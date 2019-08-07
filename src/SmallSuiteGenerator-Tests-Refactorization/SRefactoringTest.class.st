Class {
	#name : #SRefactoringTest,
	#superclass : #TestCase,
	#instVars : [
		'refactorTest'
	],
	#category : #'SmallSuiteGenerator-Tests-Refactorization'
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
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 45);
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: 'score:';
				args: {'_var0'});
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_var0'});
		addStatement:
			(SMessage new
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
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnTypeName: #ByteString;
				value: 'Mary';
				varKeyword: '_bytStr');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SStudent';
				selector: 'name:';
				args: {'_bytStr0'});
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_bytStr0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnTypeName: #ByteString;
				value: 'Mary';
				varKeyword: 'otherVar');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SStudent';
				selector: 'name:';
				args: {'otherVar0'});
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'otherVar0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 45);
		addStatement:
			(SFactoryMessage new
				theClassName: 'SStudent';
				selector: 'name:with:';
				args: {'Sussy' . '_var0'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var1';
				fieldName: #scoreStudent;
				returnTypeName: #SmallInteger);
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #scoreStudent:;
				returnTypeName: #ByteString;
				args: {'_var2'});
		addStatement:
			(SMessage new
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
			('_var1'
				-> (OrderedCollection newFrom: {'_var2' . '_var3' . '_var4'})).
			('_var2' -> (OrderedCollection newFrom: {'_var3'}))}
]

{ #category : #tests }
SRefactoringTest >> testDictReferencesOfPrimitiveStatements [
	| testCase dictReferences |
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 45);
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: 'score:';
				args: {'_var0'});
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_var0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnTypeName: #ByteString;
				value: 'Mary';
				varKeyword: '_bytStr');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SStudent';
				selector: 'name:';
				args: {'_bytStr0'});
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'_bytStr0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames).
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnTypeName: #ByteString;
				value: 'Mary';
				varKeyword: 'otherVar');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SStudent';
				selector: 'name:';
				args: {'otherVar0'});
		addStatement:
			(SMessage new
				receiverVarName: '_var1';
				selector: #return:;
				returnTypeName: #ByteString;
				args: {'otherVar0'});
		yourself.
	dictReferences := refactorTest dictReferencesOf: testCase.
	self
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames)
]
