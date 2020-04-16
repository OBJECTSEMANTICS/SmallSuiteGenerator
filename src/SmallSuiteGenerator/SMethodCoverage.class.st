"
SMethodCoverage is responsible for calculating the method coverage in each testCase of a testSuite. It means that for each class defined in the testCase it calculates how many methods were executed.
"
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
			testCase summaryExecutionMethods: profiler summaryExecutionMethods.
			"self abstractDataOn: testCase."
			testCase fitness at:string put: profiler methodCoverage.
			testCase fitnessByClass at: string put: profiler methodCoverage1 ]
]

{ #category : #actions }
SMethodCoverage >> setUp [

]

{ #category : #actions }
SMethodCoverage >> tearDown [
	
]
