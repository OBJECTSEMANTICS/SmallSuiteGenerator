Class {
	#name : #SPrimitiveStatementTest,
	#superclass : #SStatementTest,
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #tests }
SPrimitiveStatementTest >> testDependenciesConsidering [
	| testCase dependencies |
	testCase := SStatementTest testCaseSFoo.
	dependencies := (testCase statements select: #isPrimitive)
		collect:
			[ :stm | stm varName -> (stm dependenciesConsidering: testCase varNames) ].
	self
		assertCollection: dependencies
		hasSameElements:
			{('_var1' -> {}).
			('_var5' -> {}).
			('_var10' -> {}).
			('_var12' -> {})}
]

{ #category : #tests }
SPrimitiveStatementTest >> testReplaceVarNameBy [
	| statement |
	statement := SPrimitiveStatement new
		returnTypeName: #SmallInteger;
		value: 2;
		id: 0;
		yourself.
	self assert: statement asString equals: '_var0 := 2.'.
	self
		assert: (statement replace: '_var1' varNameBy: '5') asString
		equals: '_var0 := 2.'
]
