Class {
	#name : #SOutputCoverage,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'as yet unclassified' }
SOutputCoverage >> coverageCriteria: className [
  ^profiler outputCoverageCriteriaOf: className
]

{ #category : #actions }
SOutputCoverage >> fitnessByClass [
  ^ profiler outputCoverage
]

{ #category : #accesing }
SOutputCoverage >> functionName [
  ^'output-coverage'
]
