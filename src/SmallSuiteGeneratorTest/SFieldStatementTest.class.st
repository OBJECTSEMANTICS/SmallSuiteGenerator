Class {
	#name : #SFieldStatementTest,
	#superclass : #SStatementTest,
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #tests }
SFieldStatementTest >> testDependenciesConsidering [ 
	| testCase dependencies |
	testCase := SStatementTest testCaseSFooWithMethods.
	dependencies := (testCase statements select: #isField)
		collect:
			[ :stm | stm varName -> (stm dependenciesConsidering: testCase varNames) ].
	self
		assertCollection: dependencies
		hasSameElements:
			{('_var7' -> {'_var3'}).
			('_var10' -> {'_var9'}).
			('_var14' -> {'_var9'}).
			('_var16' -> {'_var11'})}
]

{ #category : #tests }
SFieldStatementTest >> testReplaceVarNameBy [
	| statement |
	statement := SFieldStatement new
		returnTypeName: #SmallInteger;
		receiverVarName: '_var0';
		fieldName: #score;
		id: 1;
		yourself.
	self assert: statement asString equals: '_var1 := _var0 score.'.
	self
		assert: (statement replace: '_var1' varNameBy: 5) asString
		equals: '_var1 := _var0 score.'.
	self
		assert: (statement replace: '_var0' varNameBy: (SFoo score: 5)) asString
		equals: '_var1 := _var0 score.'
]
