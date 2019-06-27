Class {
	#name : #SGeneratorInfo,
	#superclass : #SSpyInfo,
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'as yet unclassified' }
SGeneratorInfo >> typeInfo: aProfiler [
	super typeInfo: aProfiler.
	scalars := aProfiler scalars.
	info at: 'scalars' put: scalars
]
