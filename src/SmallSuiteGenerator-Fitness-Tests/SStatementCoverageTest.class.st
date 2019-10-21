Class {
	#name : #SStatementCoverageTest,
	#superclass : #SCoverageTest,
	#category : #'SmallSuiteGenerator-Fitness-Tests'
}

{ #category : #running }
SStatementCoverageTest >> setUp [
	super setUp.
	fitness := SStatementCoverage
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageClassSEvent [
	| testCase |
	testCase := self
		testCase: utility typeInfoSEvent2 
		withNumStatements: 20.
	fitness
		coverageOf: [ (SEvent price: 15)
				price;
				discount ]
		onClass: SEvent.
	self assert: (fitness computeFitness: testCase) value <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageClassSFoo [
	| testCase |
	testCase := self
		testCase: utility typeInfoSFoo4
		withNumStatements: 20.
	fitness
		coverageOf: [ (SFoo score: 15)
				returnCollection;
				returnFloat;
				score;
				return: #(1 5 6) ]
		onClass: SFoo.
	self assert: (fitness computeFitness: testCase) value <= 71.43	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase |
	testCase := self
		testCase: utility typeInfoSSTeacher3 
		withNumStatements: 20.
	fitness
		coverageOf: [ SSTeacher new
				nickname;
				yearsWorkExperience ]
		onClass: SSTeacher.
	self assert: (fitness computeFitness: testCase) value <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStack [
	| testCase |
	testCase := self
		testCase: utility typeInfoSStack3 
		withNumStatements: 20.
	fitness
		coverageOf: [ (SStack newStackWith: #(2 4 6 1))
				push: 8;
				pop;
				top ]
		onClass: SStack.
	self assert: (fitness computeFitness: testCase) value <= 73.68	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnClassSStudent [
	| testCase |
	testCase := self
		testCase: utility typeInfosSStudent first
		withNumStatements: 20.
	fitness
		coverageOf: [ SStudent new
				idStudent;
				scoreStudent: 10;
				scoreStudent ]
		onClass: SStudent.
	self assert: (fitness computeFitness: testCase) value <= 75.0	"75.0 = (6/8) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ (SEvent price: 15)
						price;
						discount ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario')
				asTypeInfo
		withNumStatements: 20.
	fitness
		coverageOf: [ (SEvent price: 15)
				price;
				discount ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'.
	self assert: (fitness computeFitness: testCase) value <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario') asTypeInfo
		withNumStatements: 20.
	fitness
		coverageOf: [ (SFoo score: 15)
				returnCollection;
				returnFloat;
				score;
				return: #(1 5 6) ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'.
	self assert: (fitness computeFitness: testCase) value <= 71.43	"71.43 = (10/14) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ SSTeacher new
						nickname;
						yearsWorkExperience ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario') asTypeInfo
		withNumStatements: 20.
	fitness
		coverageOf: [ SSTeacher new
				nickname;
				yearsWorkExperience ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'.
	self assert: (fitness computeFitness: testCase) value <= 75.0
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStack [
	| testCase |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ (SStack newStackWith: #(2 4 6 1))
						push: 8;
						pop;
						top ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario') asTypeInfo
		withNumStatements: 20.
	fitness
		coverageOf: [ (SStack newStackWith: #(2 4 6 1))
				push: 8;
				pop;
				top ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'.
	self assert: (fitness computeFitness: testCase) value <= 73.68	"73.68 = (14/19) * 100 round: 2"
]

{ #category : #tests }
SStatementCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ SStudent new
						idStudent;
						scoreStudent: 10;
						scoreStudent ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario2') asTypeInfo
		withNumStatements: 20.
	fitness
		coverageOf: [ SStudent new
				idStudent;
				scoreStudent: 10;
				scoreStudent ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario2'.
	self assert: (fitness computeFitness: testCase) value <= 75.0
]
