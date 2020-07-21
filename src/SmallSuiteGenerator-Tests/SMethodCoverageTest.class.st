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
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSEvent2
		withNumStatements: 20
		andTargetClassName: #SEvent fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 83.33 ])	"83.33 = (5/6) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageClassSFoo [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20
		andTargetClassName: #SFoo fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ])	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSSTeacher3
		withNumStatements: 20
		andTargetClassName: #SSTeacher fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 60.0 ])	"60.0 = (3/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStack [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSStack3
		withNumStatements: 20
		andTargetClassName: #SStack fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 57.14 ])	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStudent [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfosSStudent first
		withNumStatements: 20
		andTargetClassName: #SStudent fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 80.0 ])	"80.0 = (4/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSEventOnPackage1 " (STON fromString: utility typeInfoStringSEvent)"
		withNumStatements: 20
		andTargetClassName: #SEvent fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 83.33 ])
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSFooOnPackage2  "(STON fromString: utility typeInfoStringSFoo2)"
		withNumStatements: 20
		andTargetClassName: #SFoo fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ])	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSSTeacherOnPackage2 "(STON fromString: utility typeInfoStringSSTeacher2)."
		withNumStatements: 20
		andTargetClassName: #SSTeacher fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ])	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStack [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSStackOnPackage1 "(STON fromString: utility typeInfoStringSStack2)."
		withNumStatements: 20
		andTargetClassName: #SStack fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 57.14 ])	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSStudentOnPackage1 "(STON fromString: utility typeInfoStringSStudent1)."
		withNumStatements: 20
		andTargetClassName: #SStudent fullClassNameSymbol.
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 80.0 ])
]
