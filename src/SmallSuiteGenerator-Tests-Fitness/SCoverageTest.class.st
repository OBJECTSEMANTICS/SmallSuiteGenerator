Class {
	#name : #SCoverageTest,
	#superclass : #SUnitTestCase,
	#instVars : [
		'utility'
	],
	#category : #'SmallSuiteGenerator-Tests-Fitness'
}

{ #category : #'public - profiling' }
SCoverageTest >> profile: aBlock onClass: aClass [
	^ SBProfiler 
		profile: aBlock onClass: aClass;
		yourself
]

{ #category : #'public - profiling' }
SCoverageTest >> profile: aBlock onPackages: regex [
	^ SBProfiler
		profile: aBlock onPackagesMatching: regex;
		yourself
]

{ #category : #running }
SCoverageTest >> setUp [
	super setUp.
	utility := SUtilityTypeInfo new
]

{ #category : #running }
SCoverageTest >> tearDown [
	S2Lock value: false.
	S2Context value: nil.
	S2Profiler remove
]

{ #category : #tests }
SCoverageTest >> testCase: typeInfo withNumStatements: aNumber [
	^ (SSTestCase with: typeInfo) 
	numMaxStatements: aNumber;
	generateStatements
]
