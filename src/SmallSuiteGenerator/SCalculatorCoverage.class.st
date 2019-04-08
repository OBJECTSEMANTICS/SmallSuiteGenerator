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
