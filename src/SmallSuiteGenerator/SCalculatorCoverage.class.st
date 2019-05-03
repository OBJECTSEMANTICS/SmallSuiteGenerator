Class {
	#name : #SCalculatorCoverage,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SCalculatorCoverage class >> calculateCoverageOf: aTestCase using: profiler [
	^ self calculateCoverageOf: aTestCase using: profiler inLevel: 1
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage class >> calculateCoverageOf: aTestCase using: profiler inLevel: numLevel [
	| formattedNode |
	numLevel > self maxNumberOfIterations
		ifTrue: [ ^ profiler dictCoverage ].
	formattedNode := (self nodeFormattedOf: aTestCase) body formattedCode.
	[ STestCaseCompiler
		compile: 'testCaseCompiled' , String cr , formattedNode ]
		on: Error
		do: [ :e | 
			(aTestCase removeNumStatements: 5)
				ifTrue: [ ^ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ]
				ifFalse: [ ^ profiler dictCoverage ] ].
	[ profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ] ]
		on: Exception
		do: [ :exception | 
			(aTestCase
				changeStatementsOfClassName:
					([ exception signaler name ]
						on: MessageNotUnderstood
						do: [ exception signaler className ]))
				ifTrue: [ ^ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ] ].
	^ profiler dictCoverage
]

{ #category : #accessing }
SCalculatorCoverage class >> maxNumberOfIterations [
	^ 5
]

{ #category : #compiling }
SCalculatorCoverage class >> nodeFormattedOf: testCase [
	| statements varNames node temporaries |
	statements := testCase statements.
	varNames := testCase varNames.
	node := RBParser parseExpression: '[]'.
	temporaries := varNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	statements
		collect: [ :statement | 
			statement
				referencesToArgs: varNames;
				printString ]
		thenDo: [ :aString | node body addNode: (RBParser parseExpression: aString) ].
	^ node
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
SCalculatorCoverage >> calculateCoverageOf: aTestCase using: profiler [
	^ self calculateCoverageOf: aTestCase using: profiler inLevel: 1
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
SCalculatorCoverage >> calculateCoverageOf: aTestCase using: profiler inLevel: numLevel [
	| formattedNode |
	numLevel > self class maxNumberOfIterations
		ifTrue: [ ^ false ].
	formattedNode := (STransformValue nodeFormattedOf: aTestCase) body formattedCode.
	[ STestCaseCompiler
		compile: 'testCaseCompiled' , String cr , formattedNode ]
		on: Error
		do: [ :e | 
			^ (aTestCase removeNumStatements: 5)
				and: [ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ] ].
	[ profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ] ]
		on: Exception
		do: [ :exception | 
			^ (aTestCase
				changeStatementsOfClassName:
					([ exception signaler name ]
						on: MessageNotUnderstood
						do: [ exception signaler className ]))
				and: [ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> coverage: testCaseProfiler using: profiler inTestSuiteOfSize: aNumber [
	| listCoverage testSuite |
	listCoverage := OrderedCollection new.
	listCoverage add: profiler dictCoverage.
	[ testSuite := self testSuite: testCaseProfiler ofSize: aNumber.
	testSuite
		do: [ :aTestCase | 
			(self calculateCoverageOf: aTestCase using: profiler)
				ifTrue: [ listCoverage add: profiler dictCoverage ] ] ]
		on: Exception
		do: [ :e | 
			profiler cleanInstrumentation ].
	^ listCoverage
]

{ #category : #compiling }
SCalculatorCoverage >> nodeFormattedOf: testCase [
	| statements varNames node temporaries |
	statements := testCase statements.
	varNames := testCase varNames.
	node := RBParser parseExpression: '[]'.
	temporaries := varNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	statements
		collect: [ :statement | statement referencesToArgs: varNames; printString ]
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
