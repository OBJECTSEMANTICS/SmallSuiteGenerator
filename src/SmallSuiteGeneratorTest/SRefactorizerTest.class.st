Class {
	#name : #SRefactorizerTest,
	#superclass : #TestCase,
	#instVars : [
		'refactorizer'
	],
	#category : #'SmallSuiteGeneratorTest-Refactorization'
}

{ #category : #running }
SRefactorizerTest >> setUp [ 	
	refactorizer := SRefactorizer new
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

{ #category : #tests }
SRefactorizerTest >> testPrettyCodeOfTestCaseApplyingSAlignerStatement [
	| testCase listRefactoring previousSize |
	testCase := STestCase new
		addStatement:
			(SConstructorStatement new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: #SmallInteger;
				value: 34);
		addStatement:
			(SMethodStatement new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: 'SFoo';
				args: #());
		addStatement:
			(SConstructorStatement new
				theClassName: 'SFoo';
				selector: #score:;
				args: #('_var1'));
		addStatement:
			(SFieldStatement new
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
SRefactorizerTest >> testPrettyCodeOfTestCaseApplyingSAlignerStatementWithProfiler [
	| testCase listRefactoring profile |
	profile := SSGenerator profile: [ SFoo score: 23 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.	"_var0 := 23"
	testCase addConstructor.	"_var1 := SFoo score: _var0"
	listRefactoring := {SAlignerStatement}.
	self testPrettyCodeOf: testCase testCaseApplying: listRefactoring.
	self assert: testCase numberOfStatements equals: 1.
	self
		assertCollection: (testCase statements collect: #asString)
		hasSameElements: {'_var1 := SFoo score: 23 .'}
]
