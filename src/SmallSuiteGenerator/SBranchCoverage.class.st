Class {
	#name : #SBranchCoverage,
	#superclass : #SSimpleFitnessFunction,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SBranchCoverage >> fitnessByClass [

	^ profiler branchCoverage1.
]

{ #category : #accesing }
SBranchCoverage >> functionName [

	^ 'branch-coverage'
]
