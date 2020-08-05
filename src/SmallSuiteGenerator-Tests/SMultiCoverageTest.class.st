Class {
	#name : #SMultiCoverageTest,
	#superclass : #SCoverageTest,
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #running }
SMultiCoverageTest >> fitnessClass [
	^ SMultiFitnessFunction
]

{ #category : #tests }
SMultiCoverageTest >> fitnessOf: testCase withMethodCov: aFloat1 andStmCov:  aFloat2 [
	fitness add: SMethodCoverage new weight: aFloat1.
	fitness add: SStatementCoverage new weight: aFloat2.
	^ self computeFitnessOf: testCase
]

{ #category : #tests }
SMultiCoverageTest >> testCoverageClassSEvent [
	| testCase valueFitness targetClass |
	targetClass := #SEvent fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSEvent2
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	valueFitness := self fitnessOf: testCase withMethodCov: 0.6 andStmCov: 0.4.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"block-coverage-66.67, method-coverage-71.43 = 69.52".
	valueFitness := self fitnessOf: testCase withMethodCov: 0.4 andStmCov: 0.6.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])"block-coverage-66.67, method-coverage-71.43 = 68.57".
	self uninstall.
	
]

{ #category : #tests }
SMultiCoverageTest >> testCoverageClassSFoo [
	| testCase valueFitness targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	valueFitness := self fitnessOf: testCase withMethodCov: 0.6 andStmCov: 0.4.
	"block-coverage-14.28, method-coverage-22.22 = 19.05"
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.43 ]).
	valueFitness := self fitnessOf: testCase withMethodCov: 0.4 andStmCov: 0.6.
	"block-coverage-14.28, method-coverage-22.22 = 17.46"
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.43 ]). 
	self uninstall.
]

{ #category : #tests }
SMultiCoverageTest >> testCoverageOnClassSStack [
	| testCase valueFitness targetClass |
	targetClass := #SStack fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSStack3
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	valueFitness := self fitnessOf: testCase withMethodCov: 0.6 andStmCov: 0.4.
	"block-coverage-73.33, method-coverage-71.42 = 72.42"
	self assert: (valueFitness > 0 and: [ valueFitness <= 73.68 ]).
	valueFitness := self fitnessOf: testCase withMethodCov: 0.6 andStmCov: 0.4.
	"block-coverage-73.33, method-coverage-71.42 = 72.19"
	self assert: (valueFitness > 0 and: [ valueFitness <= 73.68 ]).
	self uninstall.
]
