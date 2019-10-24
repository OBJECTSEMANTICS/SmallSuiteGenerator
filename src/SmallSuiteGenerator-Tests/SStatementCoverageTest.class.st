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
	| testCase |
	testCase := SSTestCase with: utility typeInfoSEvent2.
	testCase addFactoryMessage: #SEvent.
	testCase generateStatements: 19.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageClassSFoo [
	| testCase |
	testCase := SSTestCase with: utility typeInfoSFoo4.
	testCase addFactoryMessage: #SFoo.
	testCase generateStatements: 19.
	
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 71.43	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase |
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStack [
	| testCase |
	testCase := self
		testCase: utility typeInfoSStack3
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 73.68	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStudent [
	| testCase |
	testCase := self
		testCase: utility typeInfosSStudent first
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase |
	testCase := SSTestCase with: (SSTypeCollector
				profile: [ (SEvent price: 15)
						price;
						discount ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	testCase addFactoryMessage: #SEvent.
	testCase generateStatements: 19.

	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase |
	testCase := SSTestCase
		with:
			(SSTypeCollector
				profile: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	testCase addFactoryMessage: #SFoo.
	testCase generateStatements: 19.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 71.43	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase |
	testCase := SSTestCase
		with:
			(SSTypeCollector
				profile: [ SSTeacher new
						nickname;
						yearsWorkExperience ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	testCase addFactoryMessage: #SSTeacher.
	testCase generateStatements: 19.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStack [
	| testCase |
	testCase := SSTestCase
		with:
			(SSTypeCollector
				profile: [ (SStack newStackWith: #(2 4 6 1))
						push: 8;
						pop;
						top ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	testCase addFactoryMessage: #SStack.
	testCase generateStatements: 19.
	testCase inspect.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 73.68	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase |
	testCase := SSTestCase
		with:
			(SSTypeCollector
				profile: [ SStudent new
						idStudent;
						scoreStudent: 10;
						scoreStudent ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario').
	testCase addFactoryMessage: #SStudent.
	testCase generateStatements: 19.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 75.0
]
