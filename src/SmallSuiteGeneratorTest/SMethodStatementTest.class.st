Class {
	#name : #SMethodStatementTest,
	#superclass : #SStatementTest,
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #tests }
SMethodStatementTest >> testDependenciesConsidering [
	| testCase dependencies |
	testCase := SStatementTest testCaseSFooWithMethods.
	dependencies := (testCase statements select: #isMethod)
		collect:
			[ :stm | stm varName -> (stm dependenciesConsidering: testCase varNames) ].
	self
		assertCollection: (dependencies collect: #key)
		hasSameElements: {'_var2' . '_var4' . '_var18'}.
	self assert: (dependencies first value includes: '_var0').
	(testCase statementAt: '_var2') args
		ifNotEmpty: [ dependencies first value includes: '_var1' ].
	self assert: (dependencies second value includes: '_var0').
	(testCase statementAt: '_var4') args
		ifNotEmpty: [ dependencies first value includes: '_var1' ].
	self assert: (dependencies third value includes: '_var8').
	(testCase statementAt: '_var18') args
		ifNotEmpty: [ dependencies first value
				includesAny:
					{'_var1' . '_var5' . '_var7' . '_var10' . '_var14' . '_var15' . '_var16'} ]
]

{ #category : #tests }
SMethodStatementTest >> testReplaceVarNameBy [
	| statement |
	statement := SMethodStatement new
		receiverVarName: '_var0';
		selector: #score:;
		args: {'_var1'};
		id: 2;
		yourself.
	self
		assert: statement asString
		equals: '_var2 := _var0 score: ''_var1'' .'.
	self
		assert: (statement replace: '_var0' varNameBy: (SFoo score: 5)) asString
		equals: '_var2 := _var0 score: ''_var1'' .'.
	self
		assert: (statement replace: '_var1' varNameBy: 5) asString
		equals: '_var2 := _var0 score: 5 .'
]
