Class {
	#name : #SCalculatorCoverage,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

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

{ #category : #compiling }
SCalculatorCoverage class >> coverageOf: statements using: varNames and: aBlock [
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
	profiler := aBlock value: [ STestCaseCompiler new testCaseCompiled ].
	^ profiler dictCoverage
]

{ #category : #compiling }
SCalculatorCoverage class >> coverageOf: statements using: varNames onClass: aClass [
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
		onClass: aClass.
	^ profiler dictCoverage
]

{ #category : #compiling }
SCalculatorCoverage class >> coverageOf: statements using: varNames onPackagesMatching: regex [
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
		onPackagesMatching: regex.
	^ profiler dictCoverage
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
	offSprings := testCase1 crossOverWith: testCase2.
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
SCalculatorCoverage >> calculateCoverage: aBlock [
	| originProfiler testCaseProfiler testCase coverageTestCase |
	originProfiler := SBProfiler
		profile: aBlock
		onPackagesMatching: 'SmallSuiteExam*'.
	testCaseProfiler := SSGenerator profile: aBlock onClass: SStack.
	testCase := STestCase seed: testCaseProfiler.
	testCase generateStatements.
	coverageTestCase := testCase coverage.
	^ {originProfiler dictCoverage. coverageTestCase}
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> calculateCoverage: aBlock onClass: aClass [
	| originProfiler testCaseProfiler testCase coverageTestCase |
	originProfiler := SBProfiler
		profile: aBlock
		onClass: aClass.
	testCaseProfiler := SSGenerator profile: aBlock onClass: SStack.
	testCase := STestCase seed: testCaseProfiler.
	testCase generateStatements.
	coverageTestCase := testCase coverage.
	^ {originProfiler dictCoverage. coverageTestCase}
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> calculateCoverage: aBlock onClass: aClass inTestSuiteOfSize: aNumber [
	| profiler coverageTestSuite formattedNodes testCaseProfiler |
	testCaseProfiler := SSGenerator profile: aBlock onClass: aClass.
	formattedNodes := self
		formattedNodes: testCaseProfiler
		ofSize: aNumber.
	profiler := SBProfiler new.
	profiler profileInstrumented: aBlock onClass: aClass.
	coverageTestSuite := self
		coverageTestSuite: formattedNodes
		using: profiler.
	profiler cleanInstrumentation.
	^ coverageTestSuite
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> calculateCoverage: aBlock onPackagesMatching: regex inTestSuiteOfSize: aNumber [
	| profiler coverageTestSuite testCaseProfiler |
	testCaseProfiler := SSGenerator
		profile: aBlock
		onPackagesMatching: regex.
	"formattedNodes := self
		formattedNodes: testCaseProfiler
		ofSize: aNumber."
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
	testSuite := self testSuite: testCaseProfiler ofSize: aNumber.
	testSuite do: [ :aTestCase | 
		"| formattedNode |
		formattedNode := self nodeFormattedOf: aTestCase statements and: aTestCase varNames.
		STestCaseCompiler
						compile: 'testCaseCompiled' , String cr , formattedNode.
		[ profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ]] 
		on: ShouldNotImplement do: [ :e | e signaler name ]"
		(self executedStatementsOf: aTestCase with: profiler) ifTrue: [ listCoverage add: profiler dictCoverage ]
	].
	"listCoverage
		addAll:
			(formattedNodes
				collect: [ :formattedNode | 
					STestCaseCompiler
						compile: 'testCaseCompiled' , String cr , formattedNode.
					profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ].
					profiler dictCoverage ])."
	^ listCoverage
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> coverageTestSuite: formattedNodes using: profiler [
	| listCoverage |
	listCoverage := OrderedCollection new.
	listCoverage add: profiler dictCoverage.
	listCoverage addAll: (formattedNodes
				collect: [ :formattedNode | 
					STestCaseCompiler
						compile: 'testCaseCompiled' , String cr , formattedNode.
					profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ].
					profiler dictCoverage ]).
	^ listCoverage 
	
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> executedStatementsOf: aTestCase with: profiler [
	| formattedNode |
	formattedNode := self
		nodeFormattedOf: aTestCase statements
		and: aTestCase varNames.
	STestCaseCompiler
		compile: 'testCaseCompiled' , String cr , formattedNode.
	[ profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ] ]
		on: ShouldNotImplement
		do: [ :e | 
			^ (aTestCase removeStatementsOfClassName: e signaler name)
				and: [ self executedStatementsOf: aTestCase with: profiler ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> formattedNodes: profiler ofSize: aNumber [
	| collection |
	collection := OrderedCollection new.
	1 to: aNumber do: [ :index | 
		| testCase |
		testCase := STestCase seed: profiler.
		testCase generateStatements: (10 to: 63) atRandom.
		collection
			add: (self nodeFormattedOf: testCase statements and: testCase varNames) ].
	^ collection
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
		testCase generateStatements: (10 to: 63) atRandom.
		collection add: testCase ].
	^ collection
]
