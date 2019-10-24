Class {
	#name : #SCoverageTest,
	#superclass : #TestCase,
	#instVars : [
		'utility',
		'fitness',
		'profiler'
	],
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #running }
SCoverageTest >> fitnessClass [
	^ self subclassResponsibility.
]

{ #category : #tests }
SCoverageTest >> fitnessOf: aTestCase [
	^ aTestCase fitness at: (fitness funtionName).
]

{ #category : #running }
SCoverageTest >> setUp [
	utility := SUtilityTypeInfo new.
	fitness := self fitnessClass new.
	profiler := SBProfiler new.
	fitness tagetPackagesRegex: 'SmallSuiteGenerator-Scenario'.
	S2Profiler clean.
	(S2CInstrumentator onPackagesMatching: 'SmallSuiteGenerator-Scenario')
		applyOn: profiler.
	fitness profiler: profiler.
	profiler injectCodeToMethods
]

{ #category : #running }
SCoverageTest >> tearDown [
	profiler cleanInstrumentation.
]

{ #category : #tests }
SCoverageTest >> testCase: typeInfo withNumStatements: aNumber [
	^ (SSTestCase with: typeInfo) 
	numMaxStatements: aNumber;
	generateStatements
]
