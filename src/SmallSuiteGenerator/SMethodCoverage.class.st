"
SMethodCoverage is responsible for calculating the method coverage in each testCase of a testSuite. It means that for each class defined in the testCase it calculates how many methods were executed.
"
Class {
	#name : #SMethodCoverage,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'as yet unclassified' }
SMethodCoverage >> coverageCriteria: className [
  ^profiler methodCoverageCriteriaOf: className
]

{ #category : #actions }
SMethodCoverage >> fitnessByClass [

	^ profiler methodCoverage1.
]

{ #category : #accesing }
SMethodCoverage >> functionName [

	^ 'method-coverage'
]
