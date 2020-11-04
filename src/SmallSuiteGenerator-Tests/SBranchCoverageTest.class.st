Class {
	#name : #SBranchCoverageTest,
	#superclass : #SCoverageTest,
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #running }
SBranchCoverageTest >> fitnessClass [
	^ SBranchCoverage
]

{ #category : #tests }
SBranchCoverageTest >> testCoverageClassSEvent [
	| testCase valueFitness targetClass |
	targetClass := #SEvent fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSEvent2
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	valueFitness := self computeFitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 62.5 ]). "62.5 = (5/8) * 100 round: 2"
	self uninstall.
]

{ #category : #tests }
SBranchCoverageTest >> testCoverageClassSFoo [
	| testCase valueFitness targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	valueFitness := self computeFitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ]). "22.22 = (2/9) * 100 round: 2"
	self uninstall.
]

{ #category : #tests }
SBranchCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase valueFitness targetClass |
	targetClass := #SSTeacher fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSSTeacher3
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	valueFitness := self computeFitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 60.0 ]).	"57.14 = (4/7) * 100 round: 2"
	self uninstall.
]

{ #category : #tests }
SBranchCoverageTest >> testCoverageOnClassSStack [
	| testCase valueFitness targetClass |
	targetClass := #SStack fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSStack3
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	valueFitness := self computeFitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 70.00 ]).	"60= (6/10) * 100 round: 2"
	self uninstall.
]
