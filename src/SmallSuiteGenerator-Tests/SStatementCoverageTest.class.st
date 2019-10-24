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
	testCase := self
		testCase: utility typeInfoSEvent2 
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase) <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageClassSFoo [
	| testCase |
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase)  <= 71.43	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase |
	testCase := self
		testCase: utility typeInfoSSTeacher3 
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase)  <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStack [
	| testCase |
	testCase := self
		testCase: utility typeInfoSStack3 
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase)  <= 73.68	"73.68 = (14/19) * 100 round: 2"
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
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase) <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase |
	testCase := self
		testCase:
			(SSTypeCollector
				profile: [ (SEvent price: 15)
						price;
						discount ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario')
				asTypeInfo
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase)  <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase |
	testCase := self
		testCase:
			(SSTypeCollector
				profile: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario')
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase)  <= 71.43	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase |
	testCase := self
		testCase:
			(SSTypeCollector
				profile: [ SSTeacher new
						nickname;
						yearsWorkExperience ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario')
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase)  <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStack [
	| testCase |
	testCase := self
		testCase:
			(SSTypeCollector
				profile: [ (SStack newStackWith: #(2 4 6 1))
						push: 8;
						pop;
						top ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario')
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase)  <= 73.68	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase |
	testCase := self
		testCase:
			(SSTypeCollector
				profile: [ SStudent new
						idStudent;
						scoreStudent: 10;
						scoreStudent ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario2') asTypeInfo
		withNumStatements: 20.
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness compute: {testCase}.
	self assert: (self fitnessOf:testCase) <= 75.0
]
