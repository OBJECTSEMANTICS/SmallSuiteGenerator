Class {
	#name : #SMethodCoverage,
	#superclass : #SCoverageWithProfiler,
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #metric }
SMethodCoverage >> coverage [
	^ self class profiler methodCoverage
]
