Class {
	#name : #STransformValueTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Mutation'
}

{ #category : #tests }
STransformValueTest >> testCollectDependenciesStatementsComplex [
	| profile testCase dictDependencies |
	profile := SSGenerator
		profile: [ SStudent score: 34 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SStudent score: 34"
	testCase addPrimitive.	"_var1 := 34"
	testCase addMethod.	"_var2 := _var0 initialize"
	testCase addConstructor.	"_var3 := SStudent score: _var1"
	testCase addMethod.
	testCase statements last receiverVarName: '_var0'.	"_var4 := _var0 initialize"
	testCase addPrimitive.	"_var5 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var6 := SStudent score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var7 := SStudent score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var1'}.	"_var8 := SStudent score: _var1"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var9 := SStudent score: _var5"
	testCase addPrimitive.	"_var10 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var11 := SStudent score: _var5"
	testCase addPrimitive.	"_var12 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var13 := SStudent score: _var5"
	testCase addMethod.
	testCase statements last receiverVarName: '_var7'.	"_var14 := _var7 initialize"
	dictDependencies := STransformValue
		collectDependenciesStatements: testCase statements.
	self assert: dictDependencies size equals: 10.
	self
		assertCollection: dictDependencies associations
		hasSameElements: {('_var2' -> {'_var0'}).
			('_var3' -> {'_var1'}).
			('_var4' -> {'_var0'}).
			('_var6' -> {'_var5'}).
			('_var7' -> {'_var5'}).
			('_var8' -> {'_var1'}).
			('_var9' -> {'_var5'}).
			('_var11' -> {'_var5'}).
			('_var13' -> {'_var5'}).
			('_var14' -> {'_var7'})}
]

{ #category : #tests }
STransformValueTest >> testCollectDependenciesStatementsSimple [
	| profile testCase dependenciesStatements |
	profile := SSGenerator
		profile: [ SStudent score: 34 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addPrimitive.
	testCase addMethod.
	testCase addConstructor.
	dependenciesStatements := STransformValue
		collectDependenciesStatements: testCase statements.
	self assert: dependenciesStatements size equals: 2.
	self
		assertCollection: dependenciesStatements associations
		hasSameElements:
			{('_var2' -> {'_var0'}).
			('_var3' -> {'_var1'})}
]

{ #category : #tests }
STransformValueTest >> testDataStatementsNonRepeatedStatements [
	| profile testCase dataStatements dictBodyStatement referencedVarNames |
	profile := SSGenerator
		profile: [ SStudent score: 34 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addPrimitive.
	testCase addMethod.
	testCase addConstructor.
	dataStatements := STransformValue dataStatements: testCase statements.
	dictBodyStatement := dataStatements first.
	referencedVarNames := dataStatements second.
	self assert: dictBodyStatement size equals: 4.
	self
		assertCollection: dictBodyStatement keys
		includesAll:
			{'SStudent score: 34.' . '34.' . '_var0 initialize.' . 'SStudent score: _var1.'}.
	self
		assertCollection: dictBodyStatement values
		hasSameElements:
			{{'_var0'} asOrderedCollection.
			{'_var1'} asOrderedCollection.
			{'_var2'} asOrderedCollection.
			{'_var3'} asOrderedCollection}.
	self assert: referencedVarNames size equals: 2.
	self
		assertCollection: referencedVarNames
		hasSameElements: {'_var0' . '_var1'}
]

{ #category : #tests }
STransformValueTest >> testDataStatementsRepeatedStatements [
	| profile testCase dataStatements dictBodyStatement referencedVarNames |
	profile := SSGenerator profile: [ SStudent score: 34 ] onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor. "_var0 := SStudent score: 34"
	testCase addPrimitive.	"_var1 := 34"
	testCase addMethod.		"_var2 := _var0 initialize"
	testCase addConstructor.	"_var3 := SStudent score: _var1"
	testCase addMethod.		
	testCase statements last receiverVarName: '_var0'. "_var4 := _var0 initialize"
	testCase addPrimitive.	"_var5 := 34"
	testCase addConstructor.	
	testCase statements last args: {'_var5'}.	"_var6 := SStudent score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var7 := SStudent score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var1'}.	"_var8 := SStudent score: _var1"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var9 := SStudent score: _var5"
	testCase addPrimitive.	"_var10 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var11 := SStudent score: _var5"
	testCase addPrimitive.	"_var12 := 34"
	testCase addConstructor.	
	testCase statements last args: {'_var5'}.	"_var13 := SStudent score: _var5"
	testCase addMethod.		
	testCase statements last receiverVarName: '_var7'.	"_var14 := _var7 initialize"
	dataStatements := STransformValue dataStatements: testCase statements.
	dictBodyStatement := dataStatements first.
	referencedVarNames := dataStatements second.
	self assert: dictBodyStatement size equals: 6.
	self assertCollection: dictBodyStatement associations hasSameElements: 
	{ ('SStudent score: 34.' -> {'_var0'} asOrderedCollection). 
	('34.' -> {'_var1'. '_var5'. '_var10'. '_var12'} asOrderedCollection). 
	('_var0 initialize.' -> {'_var2'. '_var4' } asOrderedCollection ). 	('SStudent score: _var1.' -> {'_var3'. '_var8'} asOrderedCollection).
	('SStudent score: _var5.' -> {'_var6'. '_var7'. '_var9'. '_var11'. '_var13'} asOrderedCollection).
	('_var7 initialize.' -> {'_var14'} asOrderedCollection)}.
	self assert: referencedVarNames size equals: 4.
	self assertCollection: referencedVarNames hasSameElements: { '_var0'. '_var1'. '_var5'. '_var7' }.
]
