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
SCoverageTest >> install [
	fitness tagetPackagesRegex: 'SmallSuiteGenerator-Scenario'.
	(S2CInstrumentator onPackagesMatching: 'SmallSuiteGenerator-Scenario')
		applyOn: profiler.
	fitness profiler: profiler.
	
	profiler injectCodeToMethods
]

{ #category : #running }
SCoverageTest >> setUp [
	utility := SUtilityTypeInfo new.
	fitness := self fitnessClass new.
	profiler := SBProfiler new.
	fitness tagetPackagesRegex: 'SmallSuiteGenerator-Scenario'.

]

{ #category : #running }
SCoverageTest >> tearDown [
	
]

{ #category : #tests }
SCoverageTest >> testCase: typeInfo withNumStatements: aNumber [
	^ (SSTestCase with: typeInfo) 
	numMaxStatements: aNumber;
	generateStatements
]

{ #category : #running }
SCoverageTest >> uninstall [
	profiler cleanInstrumentation.
	S2Profiler clean
]
