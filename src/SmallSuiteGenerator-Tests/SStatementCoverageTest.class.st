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
	| testCase valueFitness |
	testCase := SSTestCase with: utility typeInfoSEvent2.
	testCase
		addTargetClassName: (self fullSymbolOf: #SEvent);
		addFactoryMessage: (self fullSymbolOf: #SEvent);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: (self fullSymbolOf: #SEvent).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageClassSFoo [
	| testCase valueFitness |
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase
		addTargetClassName: (self fullSymbolOf: #SFoo);
		addFactoryMessage: (self fullSymbolOf: #SFoo);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: (self fullSymbolOf: #SFoo).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.43 ])	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20
		andTargetClassName: (self fullSymbolOf: #SFoo).
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: (self fullSymbolOf: #SFoo).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStack [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfoSStack3
		withNumStatements: 20
		andTargetClassName: (self fullSymbolOf: #SStack).
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: (self fullSymbolOf: #SStack).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 73.68 ])	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStudent [
	| testCase valueFitness |
	testCase := self
		testCase: utility typeInfosSStudent first
		withNumStatements: 20
		andTargetClassName: (self fullSymbolOf:#SStudent).
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness targetClass: (self fullSymbolOf:#SStudent).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase valueFitness |
	testCase := SSTestCase
		with: utility typeInfoSEventOnPackage1." (STON fromString: utility typeInfoStringSEvent)."
	testCase
		addTargetClassName: (self fullSymbolOf:#SEvent);
		addFactoryMessage: (self fullSymbolOf:#SEvent);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: (self fullSymbolOf:#SEvent).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase valueFitness |
	testCase := SSTestCase
		with: utility typeInfoSFooOnPackage2. "(STON fromString: utility typeInfoStringSFoo2)."
	testCase
		addTargetClassName: (self fullSymbolOf:#SFoo);
		addFactoryMessage: (self fullSymbolOf:#SFoo);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: (self fullSymbolOf:#SFoo).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.43 ])	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase |
	testCase := SSTestCase
		with: utility typeInfoSSTeacherOnPackage2.	"(STON fromString: utility typeInfoStringSSTeacher2)."
	testCase
		addTargetClassName: (self fullSymbolOf:#SSTeacher);
		addFactoryMessage: (self fullSymbolOf:#SSTeacher);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: (self fullSymbolOf:#SSTeacher).
	fitness compute: (Array with: testCase).
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStack [
	| testCase valueFitness |
	testCase := SSTestCase
		with: utility typeInfoSStackOnPackage1. "(STON fromString: utility typeInfoStringSStack2)"
	testCase
		addTargetClassName: (self fullSymbolOf:#SStack);
		addFactoryMessage: (self fullSymbolOf:#SStack);
		generateStatements: 19.
	testCase inspect.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness targetClass: (self fullSymbolOf:#SStack).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 73.68 ])	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase valueFitness |
	testCase := SSTestCase
		with: utility typeInfoSStudentOnPackage1."(STON fromString: utility typeInfoStringSStudent1)."
	testCase
		addTargetClassName: (self fullSymbolOf:#SStudent);
		addFactoryMessage: (self fullSymbolOf:#SStudent);
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness targetClass: (self fullSymbolOf:#SStudent).
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])
]
