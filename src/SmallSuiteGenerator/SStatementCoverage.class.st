Class {
	#name : #SStatementCoverage,
	#superclass : #SSimpleFitnessFunction,
	#instVars : [
		'profiler'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SStatementCoverage >> computeFitness [
	^ profiler statementCoverage
]

{ #category : #accesing }
SStatementCoverage >> funtionName [
	^ 'block-coverage'
]

{ #category : #actions }
SStatementCoverage >> run: testCaseCollection [
	
	testCaseCollection do:[ :testCase|
			profiler cleanBlocksOfMethods.
			testCase runWithoutAssertions.
			testCase fitness at: self funtionName put: profiler statementCoverage.].
]

{ #category : #actions }
SStatementCoverage >> setUp [
	profiler := SBProfiler new.
	(S2CInstrumentator onPackagesMatching: tagetPackagesRegex) applyOn: profiler.
	profiler injectCodeToMethods.
]

{ #category : #actions }
SStatementCoverage >> tearDown [
	profiler cleanInstrumentation.
]
