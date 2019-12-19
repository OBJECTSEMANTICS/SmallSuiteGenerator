"
STestCaseFactoryPharo is a subclass that it is called when the project runs in Pharo
"
Class {
	#name : #STestCaseFactoryPharo,
	#superclass : #STestCaseFactory,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #actions }
STestCaseFactoryPharo >> initializeProfiler [
	profiler := SLProfilerCoverage profilerForPackagesMatching: self targetPackageRegex.
	(profiler allMethods select: #isNotMethodExtension)
		do: #installGhosts
		displayingProgress: 'Instrumenting ' , self targetPackageRegex.
]

{ #category : #actions }
STestCaseFactoryPharo >> uninstall [
	profiler uninstall
]
