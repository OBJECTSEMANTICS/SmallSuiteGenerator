Class {
	#name : #SCalculatorCoverage,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SCalculatorCoverage class >> calculateCoverage: testCase using: coverageProfiler [
]

{ #category : #compiling }
SCalculatorCoverage class >> coverageOf: statements using: varNames [
	| profiler node temporaries |
	node := RBParser parseExpression: '[]'.
	temporaries := varNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	statements
		collect: [ :statement | statement printString ]
		thenDo: [ :aString | node body addNode: (RBParser parseExpression: aString) ].
	STestCaseCompiler
		compile: 'testCaseCompiled' , String cr , node body formattedCode.
	profiler := SBProfiler
		profile: [ STestCaseCompiler new testCaseCompiled ]
		onPackagesMatching: 'SmallSuiteExampl*'.
	^ profiler dictCoverage
]

{ #category : #accessing }
SCalculatorCoverage class >> maxNumberOfIterations [
	^ 5
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> calculateCoverage2: aBlock [
	| originProfiler testCaseProfiler testCase1 testCase2 offSprings offSpring1Profiler offSpring2Profiler |
	originProfiler := SBProfiler
		profile: aBlock
		onPackagesMatching: 'SmallSuiteExam*'.
	testCaseProfiler := SSGenerator profile: aBlock onClass: SStack.
	testCase1 := STestCase seed: testCaseProfiler.
	testCase1 generateStatements.
	testCase2 := STestCase seed: testCaseProfiler.
	testCase2 generateStatements.
	offSprings := SGACrossoverOperation new crossover: testCase1 with: testCase2.
	offSpring1Profiler := self class
		coverageOf: offSprings first statements
		using: offSprings first varNames.
	offSpring2Profiler := self class
		coverageOf: offSprings second statements
		using: offSprings second varNames.
	^ {originProfiler dictCoverage.
	offSpring1Profiler.
	offSpring2Profiler}
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> calculateCoverage: aBlock onClass: aClass inTestSuiteOfSize: aNumber [
	| profiler coverageTestSuite  testCaseProfiler |
	testCaseProfiler := SSGenerator profile: aBlock onClass: aClass.
	profiler := SBProfiler new.
	profiler profileInstrumented: aBlock onClass: aClass.
	coverageTestSuite := self
		coverage: testCaseProfiler
		using: profiler
		inTestSuiteOfSize: aNumber.
	profiler cleanInstrumentation.
	^ coverageTestSuite
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> calculateCoverage: aBlock onPackagesMatching: regex inTestSuiteOfSize: aNumber [
	| profiler coverageTestSuite testCaseProfiler |
	testCaseProfiler := SSGenerator
		profile: aBlock
		onPackagesMatching: regex.
	profiler := SBProfiler new.
	profiler profileInstrumented: aBlock onPackagesMatching: regex.
	coverageTestSuite := self
		coverage: testCaseProfiler
		using: profiler
		inTestSuiteOfSize: aNumber.
	profiler cleanInstrumentation.
	^ coverageTestSuite
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> coverage: testCaseProfiler using: profiler inTestSuiteOfSize: aNumber [
	| listCoverage testSuite |
	listCoverage := OrderedCollection new.
	listCoverage add: profiler dictCoverage.
	[ testSuite := self testSuite: testCaseProfiler ofSize: aNumber.
	testSuite
		do: [ :aTestCase | 
			(self executedStatementsOf: aTestCase with: profiler)
				ifTrue: [ listCoverage add: profiler dictCoverage ] ] ]
		on: Exception
		do: [ profiler cleanInstrumentation ].
	^ listCoverage
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> coverageTestCase: testCase onClass: aClass [
	| profiler coverage |
	profiler := SBProfiler new.
	profiler profileInstrumented: [  ] onClass: aClass.
	(self executedStatementsOf: testCase with: profiler)
		ifTrue: [ coverage := profiler dictCoverage ].
	profiler cleanInstrumentation.
	^ coverage
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> coverageTestCase: testCase onPackagesMatching: regex [
	| profiler coverage |
	profiler := SBProfiler new.
	profiler profileInstrumented: [  ] onPackagesMatching: regex.
	(self executedStatementsOf: testCase with: profiler)
		ifTrue: [ coverage := profiler dictCoverage ].
	profiler cleanInstrumentation.
	^ coverage
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> coverageTestCase: testCase using: profiler [
	| coverage |
	(self executedStatementsOf: testCase with: profiler)
		ifTrue: [ coverage := profiler dictCoverage ].
	^ coverage
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> executedStatementsOf: aTestCase with: profiler [
	^ self executedStatementsOf: aTestCase with: profiler inLevel: 1
	"| formattedNode |
	formattedNode := self
		nodeFormattedOf: aTestCase statements
		and: aTestCase varNames.
	[ STestCaseCompiler
		compile: 'testCaseCompiled' , String cr , formattedNode ]
		on: Error
		do: [ :e | 
			^ (aTestCase removeNumStatements: 5)
				and: [ self executedStatementsOf: aTestCase with: profiler ] ].
	[ profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ] ]
		on: ShouldNotImplement
		do: [ :e | 
			^ (aTestCase removeStatementsOfClassName: e signaler name)
				and: [ self executedStatementsOf: aTestCase with: profiler ] ].
	^ true"
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> executedStatementsOf: aTestCase with: profiler inLevel: numLevel [
	| formattedNode |
	numLevel > self class maxNumberOfIterations ifTrue: [ ^ false  ].
	formattedNode := self
		nodeFormattedOf: aTestCase statements
		and: aTestCase varNames.
	[ STestCaseCompiler
		compile: 'testCaseCompiled' , String cr , formattedNode ]
		on: Error
		do: [ :e | 
			^ (aTestCase removeNumStatements: 5)
				and: [ self executedStatementsOf: aTestCase with: profiler inLevel: numLevel + 1] ].
	[ profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ] ]
		on: Exception
		do: [ :exception | 
			^ (aTestCase changeStatementsOfClassName: ([exception signaler name] on: MessageNotUnderstood do: [exception signaler className]))
				and: [ self executedStatementsOf: aTestCase with: profiler inLevel: numLevel + 1 ] ].
	^ true
]

{ #category : #compiling }
SCalculatorCoverage >> nodeFormattedOf: statements and: varNames [
	| node temporaries |
	node := RBParser parseExpression: '[]'.
	temporaries := varNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	statements
		collect: [ :statement | statement printString ]
		thenDo: [ :aString | node body addNode: (RBParser parseExpression: aString) ].
	^ node body formattedCode
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> testSuite: profiler ofSize: aNumber [
	| collection |
	collection := OrderedCollection new.
	1 to: aNumber do: [ :index | 
		| testCase |
		testCase := STestCase seed: profiler.
		testCase generateStatements: (10 to: 54) atRandom.
		collection add: testCase ].
	^ collection
]
