Class {
	#name : #SMethodCoverage,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accesing }
SMethodCoverage >> functionName [
	^ 'method-coverage'
]

{ #category : #actions }
SMethodCoverage >> run: testCaseCollection [
	| string |
	string := self functionName.
	testCaseCollection
		do: [ :testCase | 
			profiler cleanBlocksOfMethods.
			testCase runWithoutAssertions.
			testCase fitness at:string put: profiler methodCoverage.
			testCase fitnessByClass at: string put: profiler methodCoverage1 ]
		].
]

{ #category : #actions }
SMethodCoverage >> setUp [

]

{ #category : #actions }
SMethodCoverage >> tearDown [
	
]
