Class {
	#name : #SMethodCoverageTest,
	#superclass : #SCoverageTest,
	#category : #'SmallSuiteGenerator-Fitness-Tests'
}

{ #category : #running }
SMethodCoverageTest >> setUp [
	super setUp.
	fitness := SMethodCoverage
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageClassSEvent [
	| testCase |
	testCase := self
		testCase: utility typeInfoSEvent2 
		withNumStatements: 20.
	fitness
		coverageOf: [ (SEvent price: 15)
				price;
				discount ]
		onClass: SEvent.
	self assert: (fitness computeFitness: testCase) value <= 83.33	"83.33 = (5/6) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageClassSFoo [
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
	self assert: (fitness computeFitness: testCase) value <= 77.78	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase |
	testCase := self
		testCase: utility typeInfoSSTeacher3 
		withNumStatements: 20.
	fitness
		coverageOf: [ SSTeacher new
				nickname;
				yearsWorkExperience ]
		onClass: SSTeacher.
	self assert: (fitness computeFitness: testCase) value <= 60.0	"60.0 = (3/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStack [
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
	self assert: (fitness computeFitness: testCase) value <= 57.14	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStudent [
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
	self assert: (fitness computeFitness: testCase) value <= 80.0	"80.0 = (4/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ (SEvent price: 15)
						price;
						discount ]
				onPackagesMatching: 'SmallSuiteGenerator-Scenario') asTypeInfo
		withNumStatements: 20.
	fitness
		coverageOf: [ (SEvent price: 15)
				price;
				discount ]
		onPackagesMatching: 'SmallSuiteGenerator-Scenario'.
	self assert: (fitness computeFitness: testCase) value <= 83.33
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSFoo [
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
	self assert: (fitness computeFitness: testCase) value <= 77.78	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSSTeacher [
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
	self assert: (fitness computeFitness: testCase) value <= 60.0	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStack [
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
	self assert: (fitness computeFitness: testCase) value <= 57.14	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStudent [
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
	self assert: (fitness computeFitness: testCase) value <= 80.0
]
