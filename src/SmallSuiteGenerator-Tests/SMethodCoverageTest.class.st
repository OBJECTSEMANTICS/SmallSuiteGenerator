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
		andTargetClassName: (self fullSymbolOf: #SEvent).
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
		andTargetClassName: (self fullSymbolOf: #SFoo).
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
		andTargetClassName: (self fullSymbolOf: #SSTeacher).
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
		andTargetClassName: (self fullSymbolOf: #SStack).
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
		andTargetClassName: (self fullSymbolOf: #SStudent).
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
		andTargetClassName: (self fullSymbolOf: #SEvent).
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 83.33 ])
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase valueFitness |
	testCase := SSTestCase
		with: utility typeInfoSFooOnPackage2  "(STON fromString: utility typeInfoStringSFoo2)".
	testCase
		addTargetClassName: (self fullSymbolOf: #SFoo);
		addFactoryMessage: (self fullSymbolOf: #SFoo);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ])	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase valueFitness |
	testCase := SSTestCase
		with: utility typeInfoSSTeacherOnPackage2."(STON fromString: utility typeInfoStringSSTeacher2)."
	testCase
		addTargetClassName: (self fullSymbolOf: #SSTeacher);
		addFactoryMessage: (self fullSymbolOf: #SSTeacher);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 77.78 ])	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStack [
	| testCase valueFitness |
	testCase := SSTestCase
		with: utility typeInfoSStackOnPackage1. "(STON fromString: utility typeInfoStringSStack2)."
	testCase
		addTargetClassName: (self fullSymbolOf: #SStack);
		addFactoryMessage: (self fullSymbolOf: #SStack);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 57.14 ])	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase valueFitness |
	testCase := SSTestCase
		with: utility typeInfoSStudentOnPackage1. "(STON fromString: utility typeInfoStringSStudent1)."
	testCase
		addTargetClassName: (self fullSymbolOf: #SStudent);
		addFactoryMessage: (self fullSymbolOf: #SStudent);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 80.0 ])
]
