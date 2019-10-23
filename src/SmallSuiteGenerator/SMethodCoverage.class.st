Class {
	#name : #SMethodCoverage,
	#superclass : #SSimpleFitnessFunction,
	#instVars : [
		'profiler'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accesing }
SMethodCoverage >> funtionName [
	^ 'method-coverage'
]

{ #category : #actions }
SMethodCoverage >> run: testCaseCollection [
	
	testCaseCollection do:[ :testCase|
			profiler cleanBlocksOfMethods.
			testCase runWithoutAssertions.
			testCase fitness at: self funtionName put: profiler methodCoverage.
		].
]

{ #category : #actions }
SMethodCoverage >> setUp [
	profiler := SBProfiler new.
	(S2CInstrumentator onPackagesMatching: tagetPackagesRegex) applyOn: profiler.
	profiler injectCodeToMethods.
]

{ #category : #actions }
SMethodCoverage >> tearDown [
	profiler cleanInstrumentation.
]
