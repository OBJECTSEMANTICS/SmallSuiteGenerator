Class {
	#name : #SMethodCoverage,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accesing }
SMethodCoverage >> funtionName [
	^ 'method-coverage'
]

{ #category : #actions }
SMethodCoverage >> run: testCaseCollection [
	
	testCaseCollection do:[ :testCase|
			profiler cleanBlocksOfMethods.
			testCase runWithoutAssertions.
			testCase fitness at: self funtionName put: profiler methodCoverage.
		].
]

{ #category : #actions }
SMethodCoverage >> setUp [

]

{ #category : #actions }
SMethodCoverage >> tearDown [
	
]
