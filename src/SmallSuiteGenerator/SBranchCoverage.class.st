Class {
	#name : #SBranchCoverage,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'as yet unclassified' }
SBranchCoverage >> coverageCriteria: className [
  ^profiler branchCoverageCriteriaOf: className
]

{ #category : #actions }
SBranchCoverage >> fitnessByClass [
  ^ profiler branchCoverage
]

{ #category : #accesing }
SBranchCoverage >> functionName [
  ^ 'branch-coverage'
]
