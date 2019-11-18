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
	testCase := SSTestCaseForTest with: utility typeInfoSEvent2.
	testCase
		addTargetClassName: #SEvent;
		addFactoryMessage: #SEvent;
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageClassSFoo [
	| testCase valueFitness |
	testCase := SSTestCaseForTest with: utility typeInfoSFoo4.
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage: #SFoo;
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
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
		andTargetClassName: #SFoo.
	self installOn: 'SmallSuiteGenerator-Scenario'.
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
		andTargetClassName: #SStack.
	self installOn: 'SmallSuiteGenerator-Scenario'.
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
		andTargetClassName: #SStudent.
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase valueFitness |
	testCase := SSTestCaseForTest with: utility typeInfoSEventOnPackage1.	" (STON fromString: utility typeInfoStringSEvent)."
	testCase
		addTargetClassName: #SEvent;
		addFactoryMessage: #SEvent;
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase valueFitness |
	testCase := SSTestCaseForTest with: utility typeInfoSFooOnPackage2.	"(STON fromString: utility typeInfoStringSFoo2)."
	testCase
		addTargetClassName: #SFoo;
		addFactoryMessage: #SFoo;
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 71.43 ])	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase |
	testCase := SSTestCaseForTest with: utility typeInfoSSTeacherOnPackage2.	"(STON fromString: utility typeInfoStringSSTeacher2)."
	testCase
		addTargetClassName: #SSTeacher;
		addFactoryMessage: #SSTeacher;
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStack [
	| testCase valueFitness |
	testCase := SSTestCaseForTest with: utility typeInfoSStackOnPackage1.	"(STON fromString: utility typeInfoStringSStack2)"
	testCase
		addTargetClassName: #SStack;
		addFactoryMessage: #SStack;
		generateStatements: 19.
	testCase inspect.
	self installOn: 'SmallSuiteGenerator-Scenario'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 73.68 ])	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase valueFitness |
	testCase := SSTestCaseForTest with: utility typeInfoSStudentOnPackage1.	"(STON fromString: utility typeInfoStringSStudent1)."
	testCase
		addTargetClassName: #SStudent;
		addFactoryMessage: #SStudent;
		generateStatements: 19.
	self installOn: 'SmallSuiteGenerator-Scenario2'.
	fitness compute: (Array with: testCase).
	self uninstall.
	valueFitness := self fitnessOf: testCase.
	self assert: (valueFitness > 0 and: [ valueFitness <= 75.0 ])
]
