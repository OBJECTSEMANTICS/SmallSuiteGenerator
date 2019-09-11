Class {
	#name : #SCoverageWithProfiler,
	#superclass : #SSimpleFitnessFunction,
	#classInstVars : [
		'compilerClassOfCoverage',
		'profiler',
		'numIteration'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SCoverageWithProfiler class >> clear [
	profiler
		ifNotNil: [ [ profiler cleanInstrumentation ]
				on: AssertionFailure
				do: [ ].
			profiler := nil.
			numIteration := 0 ]
]

{ #category : #accessing }
SCoverageWithProfiler class >> compilerClassOfCoverage [
	compilerClassOfCoverage
		ifNil: [ compilerClassOfCoverage := self compiler
				evaluate: self stringToCreateNewClass ].
	^ compilerClassOfCoverage
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> computeFitness: aTestCase [
	self
		assert: [ aTestCase notNil ]
		description: 'testCase must not be nil'.
	self
		assert: [ profiler notNil ]
		description: 'Need to set a profiler of coverage'.
	numIteration <= self maxNumIterations
		ifTrue: [ [ self compilerClassOfCoverage
				compile:
					'compileTestCase' , String cr
						, (self nodeFormattedOf: aTestCase) body formattedCode ]
				on: Error
				do: [ :e | 
					self halt.
					numIteration := numIteration + 1 ].
			self executeStatementsOf: aTestCase ].
	^ (self nameFunction -> self coverage)
]

{ #category : #metric }
SCoverageWithProfiler class >> coverage [ 
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> coverageOf: aBlock onClass: aClass [
	profiler
		ifNil: [ self defaultInitialization .
			profiler := SBProfiler new
				profile: aBlock onClass: aClass;
				yourself ]
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> coverageOf: aBlock onPackagesMatching: regex [
	profiler
		ifNil: [ self defaultInitialization .
			profiler := SBProfiler new
				profile: aBlock onPackagesMatching: regex;
				yourself ]
]

{ #category : #'class initialization' }
SCoverageWithProfiler class >> defaultInitialization [
	numIteration := 0.
	operator := #>
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> executeStatementsOf: aTestCase [
	[ self profiler
		executeBlock: [ self compilerClassOfCoverage new perform: #compileTestCase ] ]
		on: Exception
		do: [ :exception | 
			self halt.
			SException solve: exception of: aTestCase.
			numIteration := numIteration + 1.
			self computeFitness: aTestCase

]
]

{ #category : #testing }
SCoverageWithProfiler class >> is: aTestCase1 betterThan: aTestCase2 [
	^ (aTestCase1 fitness at: self nameFunction)
				perform: self comparisonOperator
				with: (aTestCase2 fitness at: self nameFunction)
]

{ #category : #accessing }
SCoverageWithProfiler class >> maxNumIterations [
	^ 3
]

{ #category : #compiling }
SCoverageWithProfiler class >> nodeFormattedOf: testCase [
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

{ #category : #accessing }
SCoverageWithProfiler class >> profiler [ 
	^ profiler
]

{ #category : #accessing }
SCoverageWithProfiler class >> profiler: aProfiler [
	profiler ifNil: [ self defaultInitialization ].
	profiler := aProfiler
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> signalerException: exception [
	"get the className of exception"
	^ [ exception signaler name ]
		on: MessageNotUnderstood
		do: [ exception signaler className ]
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> stringToCreateNewClass [
	^ 'Object subclass: #SCompilerTestCase
    instanceVariableNames: ''''
    classVariableNames: ''''
    package: ''SmallSuiteGenerator-Core'''
]
