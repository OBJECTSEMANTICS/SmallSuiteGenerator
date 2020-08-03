Class {
	#name : #SMethodCoverageTest,
	#superclass : #SCoverageTest,
	#category : #'SmallSuiteGenerator-Tests-GA'
}

{ #category : #running }
SMethodCoverageTest >> fitnessClass [
	^ SMethodCoverage
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageClassSEvent [
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
	self assert: (valueFitness > 0 and: [ valueFitness <= 83.33 ])	"83.33 = (5/6) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageClassSFoo [
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
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ])	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase valueFitness targetClass |
	targetClass := #SSTeacher fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSSTeacher3
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 60.0 ])	"60.0 = (3/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStack [
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
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.429 ])	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStudent [
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
	self assert: (valueFitness > 0 and: [ valueFitness <= 80.0 ])	"80.0 = (4/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSEvent [
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
	self assert: (valueFitness > 0 and: [ valueFitness <= 83.33 ])
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSFoo [
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
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ])	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase valueFitness targetClass |
	targetClass := #SSTeacher fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSSTeacherOnPackage2
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ])	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStack [
	| testCase valueFitness targetClass |
	targetClass := #SStack fullClassNameSymbol.
	testCase := self
		testCase: utility typeInfoSStackOnPackage1
		withNumStatements: 20
		andTargetClassName: targetClass.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: targetClass.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.429 ])	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStudent [
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
	self assert: (valueFitness > 0 and: [ valueFitness <= 80.0 ])
]
