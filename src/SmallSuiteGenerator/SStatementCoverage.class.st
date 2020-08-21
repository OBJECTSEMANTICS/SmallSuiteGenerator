"
SStatementCoverage is responsible for calculating statement coverage of each testCase in the testSuite. 

It calculates how many statements were executed in each class defined of the testSuite. The number of statements refers to number of lines of code executed 
"
Class {
	#name : #SStatementCoverage,
	#superclass : #SIndependentFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SStatementCoverage >> fitnessByClass [
	^ profiler statementCoverage1.
]

{ #category : #accesing }
SStatementCoverage >> functionName [
	^ 'block-coverage'
]
