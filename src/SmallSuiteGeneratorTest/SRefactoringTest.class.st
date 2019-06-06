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
