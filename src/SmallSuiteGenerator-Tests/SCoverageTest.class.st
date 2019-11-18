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
	^ aTestCase fitness at: (fitness functionName).
]

{ #category : #running }
SCoverageTest >> installOn: aPackageName [
	fitness tagetPackagesRegex: aPackageName.
	(S2CInstrumentator onPackagesMatching: aPackageName )
		applyOn: profiler.
	fitness profiler: profiler.
	profiler injectCodeToMethods
]

{ #category : #running }
SCoverageTest >> setUp [
	utility := SUtilityTypeInfo new.
	fitness := self fitnessClass new.
	profiler := SBProfiler new.
	"fitness tagetPackagesRegex: 'SmallSuiteGenerator-Scenario'"
]

{ #category : #running }
SCoverageTest >> tearDown [
	
]

{ #category : #tests }
SCoverageTest >> testCase: typeInfo withNumStatements: aNumber andTargetClassName: symbol [
	^ (SSTestCaseForTest with: typeInfo)
		numMaxStatements: aNumber;
		addTargetClassName: symbol;
		generateStatements
]

{ #category : #running }
SCoverageTest >> uninstall [
	profiler cleanInstrumentation.
	S2Profiler clean
]
