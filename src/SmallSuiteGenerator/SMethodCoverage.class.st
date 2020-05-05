"
SMethodCoverage is responsible for calculating the method coverage in each testCase of a testSuite. It means that for each class defined in the testCase it calculates how many methods were executed.
"
Class {
	#name : #SMethodCoverage,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SMethodCoverage >> fitnessOf: testCase withKey: string [
	testCase fitness at:string put: profiler methodCoverage.
]

{ #category : #accesing }
SMethodCoverage >> functionName [
	^ 'method-coverage'
]

{ #category : #actions }
SMethodCoverage >> runPopulation: testCaseCollection [
	
]

{ #category : #actions }
SMethodCoverage >> setUp [

]

{ #category : #actions }
SMethodCoverage >> tearDown [
	
]
