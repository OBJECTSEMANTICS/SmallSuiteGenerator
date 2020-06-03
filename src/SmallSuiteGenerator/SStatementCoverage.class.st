"
SStatementCoverage is responsible for calculating statement coverage of each testCase in the testSuite. 

It calculates how many statements were executed in each class defined of the testSuite. The number of statements refers to number of lines of code executed 
"
Class {
	#name : #SStatementCoverage,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SStatementCoverage >> computeFitness [
	^ profiler statementCoverage
]

{ #category : #actions }
SStatementCoverage >> fitnessOf: testCase withKey: string [
	testCase fitness at: string put: (profiler statementCoverageFor: targetClass ).
	testCase fitnessByClass at: string put: profiler statementCoverage1
]

{ #category : #accesing }
SStatementCoverage >> functionName [
	^ 'block-coverage'
]

{ #category : #actions }
SStatementCoverage >> setUp [
	
]

{ #category : #actions }
SStatementCoverage >> tearDown [
	
]
