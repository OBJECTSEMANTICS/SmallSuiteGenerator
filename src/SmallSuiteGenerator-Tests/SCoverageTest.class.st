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
	profiler := SLProfilerCoverage profilerForPackagesMatching: aPackageName.
	fitness profiler: profiler.
	profiler uninstall.
	profiler beforeProfiling 
]

{ #category : #running }
SCoverageTest >> setUp [
	utility := SUtilityTypeInfo new.
	fitness := self fitnessClass new.
	profiler := SLProfilerCoverage new
]

{ #category : #running }
SCoverageTest >> tearDown [
	
]

{ #category : #tests }
SCoverageTest >> testCase: typeInfo withNumStatements: aNumber andTargetClassName: symbol [
	^ (SSTestCase with: typeInfo)
		numMaxStatements: aNumber;
		addTargetClassName: symbol;
			generateStatements
]

{ #category : #running }
SCoverageTest >> uninstall [
	profiler uninstall
]
