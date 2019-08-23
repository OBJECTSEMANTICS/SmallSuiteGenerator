Class {
	#name : #SMethodCoverageTest,
	#superclass : #SCoverageTest,
	#instVars : [
		'fitness'
	],
	#category : #'SmallSuiteGenerator-Tests-Fitness'
}

{ #category : #running }
SMethodCoverageTest >> setUp [
	super setUp.
	fitness := SMethodCoverage new

	
]

{ #category : #running }
SMethodCoverageTest >> tearDown [ 
	super tearDown 
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageClassSEvent [
	| testCase profiler |
	profiler := SBProfiler
		profile: [ (SEvent price: 15)
						price;
						discount ]
				onClass: SEvent.
	testCase := self
		testCase: utility typeInfosSEvent second
		withNumStatements: 20.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 83.33	"83.33 = (5/6) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageClassSFoo [
	| testCase profiler |
	testCase := self
		testCase: utility typeInfosSFoo fourth
		withNumStatements: 20.
	profiler := SBProfiler profile: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ] onClass: SFoo.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 77.78	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSSTeacher [
	| testCase profiler |
	testCase := self
		testCase: utility typeInfosSSTeacher third
		withNumStatements: 20.
		profiler := SBProfiler profile: [ SSTeacher new
						nickname;
						yearsWorkExperience ]
				onClass: SSTeacher.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 60.0	"60.0 = (3/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStack [
	| testCase profiler |
	testCase := self
		testCase: utility typeInfosSStack third
		withNumStatements: 20.
		profiler := SBProfiler profile: [ (SStack newStackWith: #(2 4 6 1))
						push: 8;
						pop;
						top ]
				onClass: SStack.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 57.14	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnClassSStudent [
	| testCase profiler  |
	testCase := self
		testCase: utility typeInfosSStudent first
		withNumStatements: 20.
		profiler := SBProfiler profile: [ SStudent new
						idStudent;
						scoreStudent: 10;
						scoreStudent ]
				onClass: SStudent.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 80.0	"80.0 = (4/5) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSEvent [
	| testCase profiler |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ (SEvent price: 15)
						price;
						discount ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples') asTypeInfo
		withNumStatements: 20.
		profiler := SBProfiler profile: [ (SEvent price: 15)
						price;
						discount ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples'.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 83.33
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSFoo [
	| testCase profiler |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples') asTypeInfo
		withNumStatements: 20.
		profiler := SBProfiler profile: [ (SFoo score: 15)
						returnCollection;
						returnFloat;
						score;
						return: #(1 5 6) ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples'.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 77.78	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSSTeacher [
	| testCase profiler |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ SSTeacher new
						nickname;
						yearsWorkExperience ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples') asTypeInfo
		withNumStatements: 20.
		profiler := SBProfiler profile: [ SSTeacher new
						nickname;
						yearsWorkExperience ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples'.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 60.0	"77.78 = (7/9) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStack [
	| testCase profiler |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ (SStack newStackWith: #(2 4 6 1))
						push: 8;
						pop;
						top ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples') asTypeInfo
		withNumStatements: 20.
		profiler := SBProfiler profile: [ (SStack newStackWith: #(2 4 6 1))
						push: 8;
						pop;
						top ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples'.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 57.14	"57.14 = (4/7) * 100 round: 2"
]

{ #category : #tests }
SMethodCoverageTest >> testCoverageOnPackagesSStudent [
	| testCase profiler |
	testCase := self
		testCase:
			(SSGenerator
				profile: [ SStudent new
						idStudent;
						scoreStudent: 10;
						scoreStudent ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples') asTypeInfo
		withNumStatements: 20.
		profiler := SBProfiler profile: [ SStudent new
						idStudent;
						scoreStudent: 10;
						scoreStudent ]
				onPackagesMatching: 'SmallSuiteGenerator-Examples'.
	fitness
		profiler:
			profiler.
	self assert: (fitness run: testCase) <= 80.0
]
