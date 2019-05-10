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
