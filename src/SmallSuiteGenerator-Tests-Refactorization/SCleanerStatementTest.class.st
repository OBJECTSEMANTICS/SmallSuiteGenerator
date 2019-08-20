Class {
	#name : #SCleanerStatementTest,
	#superclass : #SUnitTestCase,
	#instVars : [
		'cleaner'
	],
	#category : #'SmallSuiteGenerator-Tests-Refactorization'
}

{ #category : #running }
SCleanerStatementTest >> setUp [
	cleaner := SCleanerStatement
]

{ #category : #tests }
SCleanerStatementTest >> testApplyOnConstructorStatements [
	| typeInfo testCase cleanedVarNames |
	typeInfo := (SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo)
		asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 34"
	testCase addFactoryMessage.	"_var1 := SFoo score: 34"
	testCase addFactoryMessage.	"_var2 := SFoo score: 34"
	testCase addFactoryMessage.	"_var3 := SFoo score: 34"
	cleanedVarNames := cleaner applyOn: testCase.
	self
		assertCollection: cleanedVarNames
		hasSameElements: {'_var1' . '_var2' . '_var3'}.
	self
		deny: (testCase varNames includesAny: {'_var1' . '_var2' . '_var3'}).
	self assert: testCase numberOfStatements equals: 1.
	self assert: testCase statements first varName equals: '_var0'.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 34"
	testCase addLiteral.	"_var1 := 3.46."
	testCase addFactoryMessage.	"_var2 := SFoo score: _var1"
	testCase addLiteral.	"_var3 := 3.46"
	testCase addFactoryMessage.
	testCase statements last args: {'_var3'}.	"_var4 := SFoo score: _var3"
	testCase addFactoryMessage.
	testCase statements last args: {'_var3'}.	"_var5 := SFoo score: _var3"
	cleanedVarNames := cleaner applyOn: testCase.
	self assertCollection: cleanedVarNames hasSameElements: {'_var5'}.
	self deny: (testCase allVarNames includes: {'_var5'}).
	self assert: testCase numberOfStatements equals: 5
]

{ #category : #tests }
SCleanerStatementTest >> testCleanConstructorStatements [
	| typeInfo testCase cleanedVarNames |
	typeInfo := (SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo) asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 34"
	testCase addFactoryMessage.	"_var1 := SFoo score: 34"
	testCase addFactoryMessage.	"_var2 := SFoo score: 34"
	testCase addFactoryMessage.	"_var3 := SFoo score: 34"
	cleanedVarNames := cleaner applyOn: testCase.
	self
		assertCollection: cleanedVarNames
		hasSameElements: {'_var1' . '_var2' . '_var3'}.
	self assert: testCase statements size equals: 1.
	self assert: testCase statements first varName equals: '_var0'.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 34"
	testCase addLiteral.	"_var1 := 3.46."
	testCase addFactoryMessage.	"_var2 := SFoo score: _var1"
	testCase addLiteral.	"_var3 := 3.46"
	testCase addFactoryMessage.
	testCase statements last args: {'_var3'}.	"_var4 := SFoo score: _var3"
	testCase addFactoryMessage.
	testCase statements last args: {'_var3'}.	"_var5 := SFoo score: _var3"
	cleanedVarNames := cleaner applyOn: testCase.
	self assertCollection: cleanedVarNames hasSameElements: {'_var5'}.
	self assert: testCase statements size equals: 5
]

{ #category : #tests }
SCleanerStatementTest >> testCleanConstructorStatementsWithoutProfiler [
	| testCase cleanedVarNames |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		yourself.
	cleanedVarNames := cleaner applyOn: testCase.
	self
		assertCollection: cleanedVarNames
		hasSameElements: {'_var1' . '_var2' . '_var3'}.
	self assert: testCase statements size equals: 1.
	self assert: testCase statements first varName equals: '_var0'.
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #(34));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 3.56);
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #('_var1'));
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 3.56);
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #('_var3'));
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #('_var3'));
		yourself.
	cleanedVarNames := cleaner applyOn: testCase.
	self assertCollection: cleanedVarNames hasSameElements: {'_var5'}.
	self assert: testCase statements size equals: 5
]

{ #category : #tests }
SCleanerStatementTest >> testCleanPrimitiveStatements [
	| typeInfo testCase cleanedVarNames |
	typeInfo := (SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo) asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addLiteral.	"_var0 := 3.46"
	testCase addLiteral.	"_var1 := 3.46"
	testCase addLiteral.	"_var2 := 3.46"
	testCase addLiteral.	"_var3 := 3.46"
	cleanedVarNames := cleaner applyOn: testCase.
	self
		assertCollection: cleanedVarNames
		hasSameElements: {'_var0' . '_var1' . '_var2' . '_var3'}.
	self assert: testCase statements isEmpty
]

{ #category : #tests }
SCleanerStatementTest >> testCleanPrimitiveStatementsWithoutProfiler [
	| testCase |
	testCase := SSTestCase new
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 467);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 467);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 467);
		addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 467);
		yourself.
	self
		assertCollection: (cleaner applyOn: testCase)
		hasSameElements: {'_var0' . '_var1' . '_var2' . '_var3'}.
	self assert: testCase statements isEmpty
]

{ #category : #tests }
SCleanerStatementTest >> testCleanStatementsGeneratedRandomly [
	| typeInfo testCase cleanedVarNames oldSize |
	typeInfo := 
			(SSGenerator
				profile: [ (SSTeacher name: 'Ann' with: 34)
						age: 34;
						identifier;
						nickname: 'Ann34';
						fullIdentifier;
						name;
						id;
						nickname ]
				onClass: SSTeacher) asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase generateStatements.
	oldSize := testCase statements size.
	cleanedVarNames := cleaner applyOn: testCase.
	self assert: testCase validReferences.
	"self assert: testCase hasUniqueStatements."
	self
		assert: testCase statements size
		equals: oldSize - cleanedVarNames size
]

{ #category : #tests }
SCleanerStatementTest >> testCleanStatementsNonRepeated [
	| typeInfo testCase cleanedVarNames |
	typeInfo := (SSGenerator profile: [ SFoo score: 34 ] onClass: SFoo).
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 34"
	testCase addLiteral.	"_var1 := 34"
	testCase addMessage.	"_var2 := _var0 initialize"
	testCase addFactoryMessage.	"_var3 := SFoo score: _var1"
	cleanedVarNames := cleaner applyOn: testCase.
	self assert: cleanedVarNames isEmpty
]

{ #category : #tests }
SCleanerStatementTest >> testCleanStatementsNonRepeatedWithoutProfiler [
	| testCase |
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
			(SFieldAccessMessage new
				receiverVarName: '_var0';
				fieldName: #name;
				returnTypeName: 'ByteString');
		addStatement:
			(SFactoryMessage new
				theClassName: 'SFoo';
				selector: #score:;
				args: #('_var1'));
		yourself.
	self assert: (cleaner applyOn: testCase) isEmpty
]

{ #category : #tests }
SCleanerStatementTest >> testCleanStatementsRepeated [
	| typeInfo testCase cleanedVarNames |
	typeInfo := (SSGenerator profile: [ SFoo score: 34 ] onClass: SFoo) asTypeInfo.
	testCase := SSTestCase with: typeInfo.
	testCase addFactoryMessage.	"_var0 := SFoo score: 34"
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
	cleanedVarNames := cleaner applyOn: testCase.
	self
		assertCollection: cleanedVarNames
		hasSameElements:
			{'_var4' . '_var8' . '_var9' . '_var10' . '_var11' . '_var12' . '_var13'}.
	self assert: testCase validReferences 
]

{ #category : #tests }
SCleanerStatementTest >> testCleanStatementsRepeated2 [
	| testCase cleanedVarNames |
	testCase := SSTestCase new
		addStatement:
			(SFactoryMessage new
				theClassName: #SFoo;
				selector: #score:;
				args: #(34));
		"_var1 := 34"
			addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		"_var2 := _var0 initialize"
			addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: #SFoo;
				args: #());
		"_var3 := SFoo score: _var1"
			addStatement:
			(SFactoryMessage new
				theClassName: #SFoo;
				selector: #score:;
				args: #('_var1'));
		"_var4 := _var0 initialize"
			addStatement:
			(SMessage new
				receiverVarName: '_var0';
				selector: #initialize;
				returnTypeName: #SFoo;
				args: #());
		"_var5 := 34"
			addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		"_var6 := SFoo score: _var5"
			addStatement:
			(SFactoryMessage new
				theClassName: #SFoo;
				selector: #score:;
				args: #('_var5'));
		"_var7 := SFoo score: _var5"
			addStatement:
			(SFactoryMessage new
				theClassName: #SFoo;
				selector: #score:;
				args: #('_var5'));
		"_var8 := SFoo score: _var1"
			addStatement:
			(SFactoryMessage new
				theClassName: #SFoo;
				selector: #score:;
				args: #('_var1'));
		"_var9 := SFoo score: _var5"
			addStatement:
			(SFactoryMessage new
				theClassName: #SFoo;
				selector: #score:;
				args: #('_var5'));
		"_var10 := 34"
			addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		"_var11 := SFoo score: _var5"
			addStatement:
			(SFactoryMessage new
				theClassName: #SFoo;
				selector: #score:;
				args: #('_var5'));
		"_var12 := 34"
			addStatement:
			(SLiteral new
				returnTypeName: #SmallInteger;
				value: 34);
		"_var13 := SFoo score: _var5"
			addStatement:
			(SFactoryMessage new
				theClassName: #SFoo;
				selector: #score:;
				args: #('_var5'));
		"_var14 := _var7 initialize"
			addStatement:
			(SMessage new
				receiverVarName: '_var7';
				selector: #initialize;
				returnTypeName: #SFoo;
				args: #());
		yourself.
	cleanedVarNames := cleaner applyOn: testCase.
	self
		assertCollection: cleanedVarNames
		hasSameElements:
			{'_var4' . '_var8' . '_var9' . '_var10' . '_var11' . '_var12' . '_var13'}.
	self assert: testCase validReferences
]
