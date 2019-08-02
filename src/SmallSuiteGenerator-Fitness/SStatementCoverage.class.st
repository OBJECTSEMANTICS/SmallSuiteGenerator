Class {
	#name : #SStatementCoverage,
	#superclass : #SCoverageWithProfiler,
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #metric }
SStatementCoverage >> coverage [ 
	^ profiler statementCoverage
]
