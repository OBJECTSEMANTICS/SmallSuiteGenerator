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
