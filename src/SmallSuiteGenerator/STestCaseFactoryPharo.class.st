"
STestCaseFactoryPharo is a subclass that it is called when the project runs in Pharo
"
Class {
	#name : #STestCaseFactoryPharo,
	#superclass : #STestCaseFactory,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #actions }
STestCaseFactoryPharo >> cleanInstrumentation [
	profiler cleanInstrumentation
]

{ #category : #actions }
STestCaseFactoryPharo >> initializeProfiler [
	profiler := SBProfiler new.
	(S2CInstrumentator onPackagesMatching: self targetPackageRegex)
		applyOn: profiler.
	(profiler allMethods select: #isNotMethodExtension)
		do: #installGhosts
		displayingProgress: 'Instrumenting ' , self targetPackageRegex.
]
