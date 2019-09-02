Class {
	#name : #SStatementCoverage,
	#superclass : #SCoverageWithProfiler,
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #metric }
SStatementCoverage class >> coverage [
	^ self profiler statementCoverage
]
