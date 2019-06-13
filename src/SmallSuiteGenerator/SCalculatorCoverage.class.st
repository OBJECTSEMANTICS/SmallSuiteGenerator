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
	^ self executeStatementsOf: aTestCase using: profiler inLevel: numLevel.
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage class >> executeStatementsOf: aTestCase using: profiler inLevel: numLevel [
	[ profiler executeBlock: [ STestCaseCompiler new testCaseCompiled ] ]
		on: Exception
		do: [ :exception | 
			(aTestCase
				changeStatementsOfClassName: (self signalerOfException: exception))
				ifTrue: [ ^ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ]].
	^ profiler dictCoverage
]

{ #category : #accessing }
SCalculatorCoverage class >> maxNumberOfIterations [
	^ 3
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
SCalculatorCoverage class >> signalerOfException: exception [
	^ [ exception signaler name ]
		on: MessageNotUnderstood
		do: [ exception signaler className ]
]
