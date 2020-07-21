Class {
	#name : #SStatementCoverageTest,
	#superclass : #SCoverageTest,
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #tests }
SStatementCoverageTest >> fitnessClass [
	^ SStatementCoverage
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageClassSEvent [
	| testCase valueFitness targetClass |
	targetClass := #SEvent fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSEvent2
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageClassSFoo [
	| testCase valueFitness targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.43 ])	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase valueFitness targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStack [
	| testCase valueFitness targetClass |
	targetClass := #SStack fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSStack3
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 73.68 ])	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStudent [
	| testCase valueFitness targetClass |
	targetClass := #SStudent fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfosSStudent first
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase valueFitness targetClass |
	targetClass := #SEvent fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSEventOnPackage1
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase valueFitness targetClass |
	targetClass := #SFoo fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSFooOnPackage2
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.43 ])	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase targetClass |
	targetClass := #SSTeacher fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSSTeacherOnPackage2
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStack [
	| testCase valueFitness targetClass |
	targetClass := #SStack fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSStackOnPackage1
		withNumStatements: 20
		andTargetClassName: targetClass.
	testCase inspect.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 73.68 ])	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase valueFitness targetClass |
	targetClass := #SStudent fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSStudentOnPackage1
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])
]
