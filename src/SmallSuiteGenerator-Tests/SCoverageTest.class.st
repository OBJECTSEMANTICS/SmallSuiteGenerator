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

{ #category : #tests }
SCoverageTest >> computeFitnessOf: testCase [
	fitness compute: (Array with: testCase).
	^ self fitnessOf: testCase.
]

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
	profiler := self aSLProfilerCoverage profilerForPackagesMatching: aPackageName.
	fitness profiler: profiler.
	profiler uninstall.
	profiler beforeProfiling 
]

{ #category : #running }
SCoverageTest >> setUp [
	utility := SUtilityTypeInfo new.
	fitness := self fitnessClass new.
	profiler := self aSLProfilerCoverage new
]

{ #category : #running }
SCoverageTest >> tearDown [
	
]

{ #category : #tests }
SCoverageTest >> testCase: typeInfo withNumStatements: aNumber andTargetClassName: symbol [
	^ (SSTestCase with: typeInfo)
		numMaxStatements: aNumber;
		targetClassName: symbol;
		addFactoryMessage: symbol;
			generateStatements
]

{ #category : #running }
SCoverageTest >> uninstall [
	profiler uninstall
]
