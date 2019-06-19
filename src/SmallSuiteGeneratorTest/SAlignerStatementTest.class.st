Class {
	#name : #SAlignerStatementTest,
	#superclass : #TestCase,
	#instVars : [
		'aligner'
	],
	#category : #'SmallSuiteGeneratorTest-Refactorization'
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
	| profile testCase removedVarNames previousSize |
	profile := SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 34"
	testCase addPrimitive.	"_var1 := 34"
	testCase addMethod.	"_var2 := _var0 initialize"
	testCase addConstructor.	"_var3 := SFoo score: _var1"
	testCase addMethod.
	testCase statements last receiverVarName: '_var0'.	"_var4 := _var0 initialize"
	testCase addPrimitive.	"_var5 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var6 := SFoo score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var7 := SFoo score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var1'}.	"_var8 := SFoo score: _var1"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var9 := SFoo score: _var5"
	testCase addPrimitive.	"_var10 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var11 := SFoo score: _var5"
	testCase addPrimitive.	"_var12 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var13 := SFoo score: _var5"
	testCase addMethod.
	testCase statements last receiverVarName: '_var7'.	"_var14 := _var7 initialize"
	previousSize := testCase statements size.
	removedVarNames := aligner applyOn: testCase.
	self
		assert: testCase numberOfStatements equals: previousSize - removedVarNames size
]

{ #category : #tests }
SAlignerStatementTest >> testAlignFieldStatements [
	| profile testCase dictReferences |
	profile := SSGenerator
		profile: [ (SFoo score: 2) score ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 2"
	testCase addField.	"_var1 := _var0 score"
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
	| profile testCase dictReferences |
	profile := SSGenerator
		profile: [ (SFoo score: 2)
				returnFloat;
				return:
					(Dictionary new
						at: 3 put: 3;
						yourself) ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 2"
	testCase addMethod.	"_var1 := _var0 ..."
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		yourself.
	self testAlign: testCase testCaseUsing: dictReferences.
	self
		assert:
			((testCase statementAt: '_var1') asString
				beginsWith: '_var1 := (SFoo score: 2 )').
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 2"
	testCase addMethod.	"_var1 := _var0 return:"
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		yourself.
	testCase statements last selector = #return:
		ifFalse: [ testCase statements last
				selector: #return:;
				args: {(testCase profile scalars at: #Dictionary) asArray first};
				returnTypeName: #Dictionary ].
	self testAlign: testCase testCaseUsing: dictReferences.
	self
		assert: (testCase statementAt: '_var1') asString
		equals:
			'_var1 := (SFoo score: 2 ) return: ((Dictionary new) add: (3->3); yourself) .'
]

{ #category : #tests }
SAlignerStatementTest >> testAlignMethodStatements2 [
	| testCase dictReferences |
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
			(SMethodStatement new
				receiverVarName: '_var1';
				selector: #scoreStudent:;
				returnTypeName: #ByteString;
				args: {45});
		addStatement:
			(SConstructorStatement new
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
		assert: (self all: dictReferences keys keysAreVarNames: testCase varNames)"
]

{ #category : #tests }
SAlignerStatementTest >> testAlignUsingConstructorStatements [
	| profile testCase dictReferences |
	profile := SSGenerator
		profile: [ SFoo score: {1 . 6 . 8 . 7} ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.	"_var0 := #(1. 6. 8. 7)"
	testCase addConstructor.	"_var1 := SFoo score: _var0"
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
	| profile testCase dictReferences |
	profile := SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.	"_var0 := 3.46"
	testCase addConstructor.	"_var1 := SFoo score: _var0"
	testCase addPrimitive.	"_var2 := 3.46"
	testCase addPrimitive.	"_var3 := 3.46"
	testCase addConstructor.	"_var4 := SFoo score: _var2"
	testCase statements last args: {'_var2'}.
	testCase addConstructor.	"_var5 := SFoo score: _var2"
	testCase statements last args: {'_var2'}.
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		at: '_var2' put: {'_var4' . '_var5'};
		yourself.
	self testAlign: testCase testCaseUsing: dictReferences.
	self assert: (testCase statementAt: '_var1') args first equals: 3.46
]
