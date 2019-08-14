Class {
	#name : #SCoverageWithProfiler,
	#superclass : #SFitness,
	#instVars : [
		'numIteration',
		'maxNumOfIterations'
	],
	#classInstVars : [
		'compilerClassOfCoverage',
		'profiler'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SCoverageWithProfiler class >> compilerClassOfCoverage [
	compilerClassOfCoverage
		ifNil: [ compilerClassOfCoverage := self compiler
				evaluate: self stringToCreateNewClass ].
	^ compilerClassOfCoverage
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> coverageOf: aBlock onClass: aClass [
	profiler
		ifNil: [ profiler := SBProfiler new
				profileInstrumented: aBlock onClass: aClass;
				yourself ]
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> coverageOf: aBlock onPackagesMatching: regex [
	profiler
		ifNil: [ profiler := SBProfiler new
				profileInstrumented: aBlock onPackagesMatching: regex;
				yourself ]
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

{ #category : #running }
SCoverageWithProfiler class >> run: aTestCase [
	| instance |
	instance := self new.
	profiler ifNil: [ ^ self error: 'Need to set profiler'  ].
	instance profiler: profiler.
	^ instance run: aTestCase
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> stringToCreateNewClass [
	^ 'Object subclass: #SCompilerTestCase
    instanceVariableNames: ''''
    classVariableNames: ''''
    package: ''SmallSuiteGenerator-Core'''
]

{ #category : #metric }
SCoverageWithProfiler >> coverage [ 	
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler >> executeStatementsOf: aTestCase [
	[ self class profiler
		executeBlock: [ self class compilerClassOfCoverage new perform: #compileTestCase ] ]
		on: Exception
		do: [ :exception | 
			self halt.
			numIteration := numIteration + 1

			"(aTestCase
				changeStatementsOfClassName: (self signalerOfException: exception))
				ifTrue: [ ^ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ]" ]
]

{ #category : #initialization }
SCoverageWithProfiler >> initialize [
	numIteration := 0.
	maxNumOfIterations := 3
]

{ #category : #accessing }
SCoverageWithProfiler >> maxNumOfIterations: anObject [
	maxNumOfIterations := anObject
]

{ #category : #accessing }
SCoverageWithProfiler >> profiler: anObject [
	profiler := anObject
]

{ #category : #running }
SCoverageWithProfiler >> run: aSTestCase [
	self
		assert: [ aSTestCase notNil ]
		description: 'testCase must not be nil'.
	self
		assert: [ profiler notNil ]
		description: 'Need to set a profiler of coverage'.
	numIteration <= maxNumOfIterations
		ifTrue: [ [ self class compilerClassOfCoverage
				compile:
					'compileTestCase' , String cr
						, (self class nodeFormattedOf: aSTestCase) body formattedCode ]
				on: Error
				do: [ :e | 
					self halt.
					numIteration := numIteration + 1
					"(aTestCase removeNumStatements: 5)
				ifTrue: [ ^ self
						calculateCoverageOf: aTestCase
						using: profiler
						inLevel: numLevel + 1 ]
				ifFalse: [ ^ profiler dictCoverage ]" ].
			self executeStatementsOf: aSTestCase ].
	"profiler cleanInstrumentation."
	^ self coverage
]
