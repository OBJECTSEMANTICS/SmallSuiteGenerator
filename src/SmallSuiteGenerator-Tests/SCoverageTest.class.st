Class {
	#name : #SCoverageTest,
	#superclass : #TestCase,
	#instVars : [
		'utility',
		'fitness'
	],
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #running }
SCoverageTest >> setUp [
	super setUp.
	utility := SUtilityTypeInfo new
]

{ #category : #running }
SCoverageTest >> tearDown [
	fitness clean.
	super tearDown 
]

{ #category : #tests }
SCoverageTest >> testCase: typeInfo withNumStatements: aNumber [
	^ (SSTestCase with: typeInfo) 
	numMaxStatements: aNumber;
	generateStatements
]
