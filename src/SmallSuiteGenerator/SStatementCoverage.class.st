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
]

{ #category : #accesing }
SStatementCoverage >> functionName [
	^ 'block-coverage'
]

{ #category : #actions }
SStatementCoverage >> runPopulation: testCaseCollection [
	profiler cleanBlocksOfMethods.
	testCaseCollection
		do: [ :testCase | 
			testCase length > 0 ifTrue: [ testCase runWithoutAssertions ] ].
	^ profiler summaryMethodsOf: targetClass  
]

{ #category : #actions }
SStatementCoverage >> setUp [
	
]

{ #category : #actions }
SStatementCoverage >> tearDown [
	
]

{ #category : #accessing }
SStatementCoverage >> typeInfo: anObject [ 
	profiler typeInfo: anObject
]
