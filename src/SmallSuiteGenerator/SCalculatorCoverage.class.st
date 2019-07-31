Class {
	#name : #SCalculatorCoverage,
	#superclass : #Object,
	#instVars : [
		'maxNumToIterate'
	],
	#classInstVars : [
		'compilerClassOfCalculator'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SCalculatorCoverage class >> calculateCoverageOf: aTestCase using: profiler [
	^ self new
		maxNumToIterate: self maxNumberOfIterations;
		calculateCoverageOf: aTestCase using: profiler inLevel: 1
]

{ #category : #accessing }
SCalculatorCoverage class >> compilerClassOfCalculator [
	compilerClassOfCalculator
		ifNil: [ compilerClassOfCalculator := self compiler evaluate: self stringToCreateNewClass ].
	^ compilerClassOfCalculator
]

{ #category : #accessing }
SCalculatorCoverage class >> maxNumberOfIterations [
	^ 3
]

{ #category : #compiling }
SCalculatorCoverage class >> nodeFormattedOf: testCase [
	| node temporaries |
	node := RBParser parseExpression: '[]'.
	temporaries := testCase allVarNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	testCase statements
		collect: #printString
		thenDo: [ :aString | node body addNode: (RBParser parseExpression: aString) ].
	^ node
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage class >> stringToCreateNewClass [
	^ 'Object subclass: #SCompilerTestCase
    instanceVariableNames: ''''
    classVariableNames: ''''
    package: ''SmallSuiteGenerator-Core'''
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> calculateCoverageOf: aTestCase using: profiler inLevel: numLevel [
	| formattedNode |
	numLevel > maxNumToIterate
		ifTrue: [ ^ profiler dictCoverage ].
	formattedNode := (self class nodeFormattedOf: aTestCase) body
		formattedCode.
	[ self class compilerClassOfCalculator
		compile: 'compileTestCase' , String cr , formattedNode ]
		on: Error
		do: [ :e | 
			self halt.
			"(aTestCase removeNumStatements: 5)
				ifTrue: [ ^ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ]
				ifFalse: [ ^ profiler dictCoverage ]" ].
	^ self
		executeStatementsOf: aTestCase
		using: profiler
		inLevel: numLevel
]

{ #category : #'as yet unclassified' }
SCalculatorCoverage >> executeStatementsOf: aTestCase using: profiler inLevel: numLevel [
	[ profiler
		executeBlock: [ self class compilerClassOfCalculator new perform: #compileTestCase ] ]
		on: Exception
		do: [ :exception | 
			self halt
			"(aTestCase
				changeStatementsOfClassName: (self signalerOfException: exception))
				ifTrue: [ ^ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ]" ].
	^ profiler dictCoverage
]

{ #category : #accessing }
SCalculatorCoverage >> maxNumToIterate: aNumber [
	maxNumToIterate := aNumber
]
