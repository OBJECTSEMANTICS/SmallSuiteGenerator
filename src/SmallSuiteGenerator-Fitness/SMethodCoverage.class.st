Class {
	#name : #SMethodCoverage,
	#superclass : #SCoverageWithProfiler,
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #metric }
SMethodCoverage class >> coverage [
	^ self profiler methodCoverage
]
