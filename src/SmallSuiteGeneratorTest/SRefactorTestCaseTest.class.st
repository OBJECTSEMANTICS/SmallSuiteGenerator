Class {
	#name : #SRefactorTestCaseTest,
	#superclass : #TestCase,
	#instVars : [
		'refactorTest'
	],
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #running }
SRefactorTestCaseTest >> setUp [ 
	refactorTest := SRefactorTestCase new
]

{ #category : #'tests-clean' }
SRefactorTestCaseTest >> testCleanConstructorStatements [
	| profile testCase removedVarNames |
	profile := SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 34"
	testCase addConstructor.	"_var1 := SFoo score: 34"
	testCase addConstructor.	"_var2 := SFoo score: 34"
	testCase addConstructor.	"_var3 := SFoo score: 34"
	removedVarNames := refactorTest clean: testCase.
	self
		assertCollection: removedVarNames
		hasSameElements: {'_var1' . '_var2' . '_var3'}.
	self assert: testCase statements size equals: 1.
	self assert: testCase statements first varName equals: '_var0'.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 34"
	testCase addPrimitive.	"_var1 := 3.46."
	testCase addConstructor.	"_var2 := SFoo score: _var1"
	testCase addPrimitive.	"_var3 := 3.46"
	testCase addConstructor.
	testCase statements last args: {'_var3'}.	"_var4 := SFoo score: _var3"
	testCase addConstructor.
	testCase statements last args: {'_var3'}.	"_var5 := SFoo score: _var3"
	removedVarNames := refactorTest clean: testCase.
	self assertCollection: removedVarNames hasSameElements: {'_var5'}.
	self assert: testCase statements size equals: 5
]

{ #category : #'tests-clean' }
SRefactorTestCaseTest >> testCleanPrimitiveStatements [
	| profile testCase removedVarNames |
	profile := SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.	"_var0 := 3.46"
	testCase addPrimitive.	"_var1 := 3.46"
	testCase addPrimitive.	"_var2 := 3.46"
	testCase addPrimitive.	"_var3 := 3.46"
	removedVarNames := refactorTest clean: testCase.
	self
		assertCollection: removedVarNames
		hasSameElements:
			{'_var0' . '_var1' . '_var2' . '_var3'}.
	self assert: testCase statements isEmpty.
]

{ #category : #'tests-clean' }
SRefactorTestCaseTest >> testCleanStatementsGeneratedRandomly [
	| profile testCase removedVarNames oldSize |
	profile := SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				age: 34;
				identifier;
				nickname: 'Ann34';
				fullIdentifier;
				name;
				id;
				nickname ]
		onClass: SSTeacher.
	testCase := STestCase seed: profile.
	testCase generateStatements.
	oldSize := testCase statements size.self halt.
	removedVarNames := refactorTest clean: testCase.
	self assert: testCase hasValidDependencies.
	self assert: testCase hasUniqueStatements.
	self
		assert: testCase statements size
		equals: oldSize - removedVarNames size
]

{ #category : #'tests-clean' }
SRefactorTestCaseTest >> testCleanStatementsNonRepeated [
	| profile testCase removedVarNames |
	profile := SSGenerator profile: [ SFoo score: 34 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 34"
	testCase addPrimitive.	"_var1 := 34"
	testCase addMethod.	"_var2 := _var0 initialize"
	testCase addConstructor.	"_var3 := SFoo score: _var1"
	removedVarNames := refactorTest clean: testCase.
	self assert: removedVarNames isEmpty
]

{ #category : #'tests-clean' }
SRefactorTestCaseTest >> testCleanStatementsRepeated [
	| profile testCase removedVarNames |
	profile := SSGenerator profile: [ SFoo score: 34 ] onClass: SFoo.
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
	self halt.
	removedVarNames := refactorTest clean: testCase.
	self
		assertCollection: removedVarNames
		hasSameElements:
			{'_var4' . '_var8' . '_var9' . '_var10' . '_var11' . '_var12' . '_var13'}.
	self assert: testCase hasValidDependencies
]

{ #category : #tests }
SRefactorTestCaseTest >> testDataStatements [
]

{ #category : #'tests-inline' }
SRefactorTestCaseTest >> testInline: aSTestCase using: dictReferences [
	| removedVarNames previousNumStms varNames |
	previousNumStms := aSTestCase statements size.
	removedVarNames := refactorTest
		inline: aSTestCase
		using: dictReferences.
	self
		assert: aSTestCase statements size
		equals: previousNumStms - removedVarNames size.
	"self
		assertCollection: removedVarNames
		hasSameElements: (associations collect: #key)."
	varNames := aSTestCase varNames.
	dictReferences associations
		select: [ :assoc | assoc value size = 1 ]
		thenDo: [ :assoc | 
			"associations
		ifNotEmpty: [ | varNames |
			varNames := aSTestCase varNames.
			self
				assertCollection: removedVarNames
				hasSameElements: (associations collect: #key).
			associations
				do: [ :assoc | 
					self
						deny:
							(((aSTestCase statementAt: assoc value first)
								dependenciesConsidering: varNames) includes: assoc key) ] ]"
			self
				deny:
					(((aSTestCase statementAt: assoc value first)
						dependenciesConsidering: varNames) includes: assoc key) ]
]

{ #category : #'tests-inline' }
SRefactorTestCaseTest >> testInlineConstructorStatements [
	| profile testCase removedVarNames |
	profile := SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 3.46"
	testCase addMethod.		"_var1 := _var0 score: 3.46 or initialize"
	removedVarNames := refactorTest inline: testCase.
	self
		assertCollection: removedVarNames
		hasSameElements: {'_var0'}.
	self assert: testCase statements size equals: 1.
	self assert: testCase statements first varName equals: '_var1'.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 3.46"
	testCase addPrimitive.	"_var1 := 3.46."
	testCase addConstructor.	"_var2 := SFoo score: _var1"
	testCase addPrimitive.	"_var3 := 3.46"
	removedVarNames := refactorTest clean: testCase.
	self assertCollection: removedVarNames hasSameElements: {'_var1'.}.
	self assert: testCase statements size equals: 3
]

{ #category : #'tests-inline' }
SRefactorTestCaseTest >> testInlineUsingConstructorStatements [
	| profile testCase dictReferences |
	profile := SSGenerator profile: [ SFoo score: 3.46 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.	"_var0 := 3.46"
	testCase addConstructor.	"_var1 := SFoo score: _var0"
	testCase addPrimitive.	"_var2 := 3.46"
	testCase addConstructor.	"_var3 := SFoo score: _var2"
	testCase statements last args: {'_var2'}.
	testCase addMethod.
	testCase statements last receiverVarName: '_var5'.	"_var4 := SFoo score: _var2"
	testCase statements last args: {'_var2'}.
	dictReferences := Dictionary new
		at: '_var0' put: {'_var1'};
		at: '_var2' put: {'_var4' . '_var5'};
		yourself.
	self testInline: testCase using: dictReferences
]

{ #category : #'tests-inline' }
SRefactorTestCaseTest >> testInlineUsingPrimitiveStatements [
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
	self testInline: testCase using: dictReferences
]
