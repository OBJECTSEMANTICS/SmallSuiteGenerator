Class {
	#name : #SConstructorStatementTest,
	#superclass : #SStatementTest,
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #tests }
SConstructorStatementTest >> testDependenciesConsidering [
	| testCase dependencies |
	testCase := SStatementTest testCaseSFoo.
	dependencies := (testCase statements select: #isConstructor)
		collect:
			[ :stm | stm varName -> (stm dependenciesConsidering: testCase varNames) ].
	self
		assertCollection: dependencies
		hasSameElements:
			{('_var0' -> {}).
			('_var3' -> {'_var1'}).
			('_var6' -> {'_var5'}).
			('_var7' -> {'_var5'}).
			('_var8' -> {'_var1'}).
			('_var9' -> {'_var5'}).
			('_var11' -> {'_var5'}).
			('_var13' -> {'_var5'})}
]
