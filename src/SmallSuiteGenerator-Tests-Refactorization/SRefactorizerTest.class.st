Class {
	#name : #SRefactorizerTest,
	#superclass : #TestCase,
	#instVars : [
		'refactorizer'
	],
	#category : #'SmallSuiteGenerator-Tests-Refactorization'
}

{ #category : #running }
SRefactorizerTest >> setUp [ 	
	refactorizer := SRefactorizer new
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingAligner [
	| testCase listRefactoring previousSize |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage  new
				receiverVarName: '_var3';
				fieldName: #name;
				returnTypeName: 'ByteString');
		yourself.
	listRefactoring := {SAlignerStatement}.
	previousSize := testCase numberOfStatements.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements < previousSize.
	self assert: testCase numberOfStatements equals: 2.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var2 := (SFoo score: 34 ) initialize.'.
			'_var4 := (SFoo score: 34 ) name.'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingAlignerAndCleaner [
	| testCase listRefactoring previousSize |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var4';
				fieldName: #name;
				returnTypeName: 'ByteString');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		yourself.
	listRefactoring := {SAlignerStatement.
	SCleanerStatement}.
	previousSize := testCase numberOfStatements.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements < previousSize.
	self assert: testCase numberOfStatements equals: 4.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var1 := 34.' . '_var3 := (SFoo score: 34 ) initialize.'.
			'_var5 := (SFoo score: ''_var1'' ) name.'.
			'_var6 := SFoo score: ''_var1'' .'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingAlignerAndRenamer [
	| testCase listRefactoring previousSize |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var4';
				fieldName: #name;
				returnTypeName: 'ByteString');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		yourself.
	listRefactoring := {SAlignerStatement.
	SRenamerVariable}.
	previousSize := testCase numberOfStatements.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements < previousSize.
	self assert: testCase numberOfStatements equals: 5.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_smaInt1 := 34.' . '_smaInt2 := 34.' . '_sfoo3 := (SFoo score: 34 ) initialize.'.
			'_bytStr5 := (SFoo score: ''_smaInt1'' ) name.'.
			'_sfoo6 := SFoo score: ''_smaInt1'' .'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingAlignerWithProfiler [
	| testCase listRefactoring typeInfo |
	typeInfo := (SSGenerator profile: [ SFoo score: 23 ] onClass: SFoo) asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.	"_var0 := 23"
	testCase addFactoryMessage.	"_var1 := SFoo score: _var0"
	listRefactoring := {SAlignerStatement}.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements equals: 1.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var1 := SFoo score: 23 .'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingCleaner [
	| testCase listRefactoring previousSize |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var4';
				fieldName: #name;
				returnTypeName: 'ByteString');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		yourself.
	listRefactoring := {SCleanerStatement}.
	previousSize := testCase numberOfStatements.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements < previousSize.
	self assert: testCase numberOfStatements equals: 5.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var0 := SFoo score: 34 .' . '_var1 := 34.' . '_var3 := _var0 initialize.'.
			'_var4 := SFoo score: ''_var1'' .' . '_var5 := _var4 name.'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingCleanerAndAligner [
	| testCase listRefactoring previousSize |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage  new
				receiverVarName: '_var4';
				fieldName: #name;
				returnTypeName: 'ByteString');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		yourself.
	listRefactoring := {SCleanerStatement.
	SAlignerStatement}.
	previousSize := testCase numberOfStatements.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements < previousSize.
	self assert: testCase numberOfStatements equals: 2.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_var3 := (SFoo score: 34 ) initialize.'.
			'_var5 := (SFoo score: 34 ) name.'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingCleanerAndRenamer [
	| testCase listRefactoring previousSize |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var4';
				fieldName: #name;
				returnTypeName: 'ByteString');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		yourself.
	listRefactoring := {SCleanerStatement.
	SRenamerVariable}.
	previousSize := testCase numberOfStatements.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements < previousSize.
	self assert: testCase numberOfStatements equals: 5.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_sfoo0 := SFoo score: 34 .' . '_smaInt1 := 34.' . '_sfoo3 := _sfoo0 initialize.'.
			'_sfoo4 := SFoo score: ''_smaInt1'' .'.
			'_bytStr5 := _sfoo4 name.'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingRenamer [
	| testCase listRefactoring |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var3';
				fieldName: #name;
				returnTypeName: 'ByteString');
		yourself.
	listRefactoring := {SRenamerVariable}.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements equals: 5.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_sfoo0 := SFoo score: 34 .' . '_smaInt1 := 34.' . '_sfoo2 := _sfoo0 initialize.'.
			'_sfoo3 := SFoo score: ''_smaInt1'' .'.
			'_bytStr4 := _sfoo3 name.'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingRenamerAndAligner [
	| testCase listRefactoring |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var3';
				fieldName: #name;
				returnTypeName: 'ByteString');
		yourself.
	listRefactoring := {SRenamerVariable.
	SAlignerStatement}.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements equals: 2.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_sfoo2 := (SFoo score: 34 ) initialize.'.
			'_bytStr4 := (SFoo score: 34 ) name.'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeApplyingRenamerAndCleaner [
	| testCase listRefactoring |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: {'_var1'});
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var4';
				fieldName: #name;
				returnTypeName: 'ByteString');
		addStatement:
			(SFieldAccessMessage new
				receiverVarName: '_var4';
				fieldName: #name;
				returnTypeName: 'ByteString');
		yourself.
	listRefactoring := {SRenamerVariable.
	SCleanerStatement}.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements equals: 5.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements:
			{'_sfoo0 := SFoo score: 34 .' . '_smaInt1 := 34.' . '_sfoo3 := _sfoo0 initialize.'.
			'_sfoo4 := SFoo score: ''_smaInt1'' .'.
			'_bytStr5 := _sfoo4 name.'}
]

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeOf: testCase testCaseApplying: kindsRefactoring [
	self
		assertCollection: kindsRefactoring
		hasSameElements:
			(refactorizer
				prettyCodeOf: testCase
				testCaseApplying: kindsRefactoring)
]
