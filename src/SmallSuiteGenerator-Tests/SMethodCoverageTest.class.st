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
	| testCase |
	testCase := self
		testCase: utility typeInfoSEvent2
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 83.33	"83.33 = (5/6) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageClassSFoo [
	| testCase |
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 77.78	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase |
	testCase := self
		testCase: utility typeInfoSSTeacher3
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 60.0	"60.0 = (3/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStack [
	| testCase |
	testCase := self
		testCase: utility typeInfoSStack3
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 57.14	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStudent [
	| testCase |
	testCase := self
		testCase: utility typeInfosSStudent first
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 80.0	"80.0 = (4/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase |
	testCase := self
		testCase:
			(SSTypeCollector
				profile: [ (SEvent price: 15)
						price;
						discount ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario')
		withNumStatements: 20.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 83.33
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSFoo [
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
	self assert: (self fitnessOf: testCase) <= 77.78	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSSTeacher [
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
	self assert: (self fitnessOf: testCase) <= 60.0	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStack [
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
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 57.14	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase |
	testCase := SSTestCase
		with:
			(SSTypeCollector
				profile: [ SStudent new
						idStudent;
						scoreStudent: 10;
						scoreStudent ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario2').
	testCase addFactoryMessage: #SStudent.
	testCase generateStatements: 19.
	self install.
	fitness compute: {testCase}.
	self uninstall.
	self assert: (self fitnessOf: testCase) <= 80.0
]
