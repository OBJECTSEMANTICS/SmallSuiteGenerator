Class {
	#name : #SAlignerStatementTest,
	#superclass : #TestCase,
	#instVars : [
		'aligner'
	],
	#category : #'SmallSuiteGenerator-Tests-Refactorization'
}

{ #category : #running }
SAlignerStatementTest >> setUp [
	aligner := SAlignerStatement
]

{ #category : #tests }
SAlignerStatementTest >> testAlign: aSTestCase testCaseUsing: dictReferences [
	| removedVarNames previousNumStms varNames |
	previousNumStms := aSTestCase statements size.
	removedVarNames := aligner align: aSTestCase testCaseUsing: dictReferences.
	self
		assert: aSTestCase statements size
		equals: previousNumStms - removedVarNames size.
	varNames := aSTestCase varNames.
	dictReferences associations
		select: [ :assoc | 
			| stm |
			stm := aSTestCase statementAt: assoc key.
			assoc value size = 1 and: [ stm isNotNil and: [stm isConstructor or: [ stm isPrimitive ]]]]
		thenDo: [ :assoc | 
			self
				deny:
					(((aSTestCase statementAt: assoc value first)
						dependenciesConsidering: varNames) includes: assoc key) ]
]

{ #category : #tests }
SAlignerStatementTest >> testAlignConstructorStatements [
	| typeInfo testCase removedVarNames previousSize |
	typeInfo := (SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo)
		asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage .	"_var0 := SFoo score: 34"
	testCase addLiteral.	"_var1 := 34"
	testCase addMessage.	"_var2 := _var0 initialize"
	testCase addFactoryMessage.	"_var3 := SFoo score: _var1"
	testCase addMessage.
	testCase statements last receiverVarName: '_var0'.	"_var4 := _var0 initialize"
	testCase addLiteral.	"_var5 := 34"
	testCase addFactoryMessage.
	testCase statements last args: {'_var5'}.	"_var6 := SFoo score: _var5"
	testCase addFactoryMessage.
	testCase statements last args: {'_var5'}.	"_var7 := SFoo score: _var5"
	testCase addFactoryMessage.
	testCase statements last args: {'_var1'}.	"_var8 := SFoo score: _var1"
	testCase addFactoryMessage.
	testCase statements last args: {'_var5'}.	"_var9 := SFoo score: _var5"
	testCase addLiteral.	"_var10 := 34"
	testCase addFactoryMessage.
	testCase statements last args: {'_var5'}.	"_var11 := SFoo score: _var5"
	testCase addLiteral.	"_var12 := 34"
	testCase addFactoryMessage.
	testCase statements last args: {'_var5'}.	"_var13 := SFoo score: _var5"
	testCase addMessage.
	testCase statements last receiverVarName: '_var7'.	"_var14 := _var7 initialize"
	previousSize := testCase statements size.
	removedVarNames := aligner applyOn: testCase.
	self
		assert: testCase numberOfStatements
		equals: previousSize - removedVarNames size
]

{ #category : #tests }
SAlignerStatementTest >> testAlignFieldStatements [
	| typeInfo testCase dictReferences |
	typeInfo := (SSGenerator
		profile: [ (SFoo score: 2) score ]
		onClass: SFoo) asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 2"
	testCase addFieldAccessMessage .	"_var1 := _var0 score"
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		yourself.
	self testAlign: testCase testCaseUsing: dictReferences.
	self
		assert: (testCase statementAt: '_var1') asString
		equals: '_var1 := (SFoo score: 2 ) score.'
]

{ #category : #tests }
SAlignerStatementTest >> testAlignMethodStatements [
	"update"

	| typeInfo testCase dictReferences |
	typeInfo := (SSGenerator
		profile: [ (SFoo score: 2)
				returnFloat;
				return:
					(Dictionary new
						at: 3 put: 3;
						yourself) ]
		onClass: SFoo) asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 2"
	testCase addMessage.	"_var1 := _var0 ..."
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		yourself.
	self testAlign: testCase testCaseUsing: dictReferences.
	self
		assert:
			((testCase statementAt: '_var1') asString
				beginsWith: '_var1 := (SFoo score: 2 )').
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 2"
	testCase addMessage.	"_var1 := _var0 return:"
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		yourself.
	testCase statements last selector = #return:
		ifFalse: [ testCase statements last
				selector: #return:;
				args: {(testCase spyInfo scalars at: #Dictionary) asArray first};
				returnTypeName: #Dictionary ].
	self testAlign: testCase testCaseUsing: dictReferences.
	self
		assert: (testCase statementAt: '_var1') asString
		equals:
			'_var1 := (SFoo score: 2 ) return: ((Dictionary new) add: (3->3); yourself) .'
]

{ #category : #tests }
SAlignerStatementTest >> testAlignMethodStatements2 [
	"update with the SSTestCase and its nodes"

	| testCase dictReferences |
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnType: (STypeReturnInfo new returnType: #SmallInteger);
				value: 45);
		addStatement:
			(SFactoryMessage new
				returnType: #SStudent;
				selector: #name:with:;
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
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1' . '_var4'};
		at: '_var1' put: {'_var2' . '_var3' . '_var4'};
		at: '_var2' put: {'_var3'};
		yourself.
	self testAlign: testCase testCaseUsing: dictReferences.
	self assert: testCase numberOfStatements equals: 5.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := 45.' . '_var1 := SStudent name: ''Sussy'' with: ''_var0'' .'.
			'_var2 := _var1 scoreStudent.' . '_var3 := _var1 scoreStudent: ''_var2'' .'.
			'_var4 := (SFoo score: ''_var1'' ) return: ''_var0'' .'}.
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
			(SMessage new
				receiverVarName: '_var1';
				selector: #scoreStudent:;
				returnTypeName: #ByteString;
				args: {45});
		addStatement:
			(SFactoryMessage new
				theClassName: 'SStudent';
				selector: 'name:with:';
				args: {'Sussy' . '_var0'});
		yourself.
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1' . '_var3'};
		at: '_var1' put: {'_var2'};
		yourself.
	self testAlign: testCase testCaseUsing: dictReferences.
	self assert: testCase numberOfStatements equals: 3.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := 45.' . '_var2 := (SStudent name: ''Sussy'' with: ''_var0'' ) scoreStudent: 45 .'.
			'_var3 := SStudent name: ''Sussy'' with: ''_var0'' .'}
	"self
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
	testCase := STestCase new
		addStatement:
			(SPrimitiveStatement new
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
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames)"
]

{ #category : #tests }
SAlignerStatementTest >> testAlignUsingConstructorStatements [
	| typeInfo testCase dictReferences |
	typeInfo := (SSGenerator
		profile: [ SFoo score: {1 . 6 . 8 . 7} ]
		onClass: SFoo) asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.	"_var0 := #(1. 6. 8. 7)"
	testCase addFactoryMessage .	"_var1 := SFoo score: _var0"
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		yourself.
	self testAlign: testCase testCaseUsing: dictReferences.
	self
		assert: (testCase statementAt: '_var1') asString
		equals: '_var1 := SFoo score: #(1 6 8 7 ) .'
]

{ #category : #tests }
SAlignerStatementTest >> testAlignUsingPrimitiveStatements [
	| typeInfo testCase dictReferences |
	typeInfo := SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo.
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.	"_var0 := 3.46"
	testCase addFactoryMessage.	"_var1 := SFoo score: _var0"
	testCase addLiteral.	"_var2 := 3.46"
	testCase addLiteral.	"_var3 := 3.46"
	testCase addFactoryMessage.	"_var4 := SFoo score: _var2"
	testCase statements last args: {'_var2'}.
	testCase addFactoryMessage.	"_var5 := SFoo score: _var2"
	testCase statements last args: {'_var2'}.
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		at: '_var2' put: {'_var4' . '_var5'};
		yourself.
	self testAlign: testCase testCaseUsing: dictReferences.
	self assert: (testCase statementAt: '_var1') args first equals: 3.46
]
