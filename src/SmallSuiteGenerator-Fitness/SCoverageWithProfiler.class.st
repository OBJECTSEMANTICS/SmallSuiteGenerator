Class {
	#name : #SCoverageWithProfiler,
	#superclass : #SSimpleFitnessFunction,
	#classInstVars : [
		'testRunner',
		'profiler',
		'numIteration'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SCoverageWithProfiler class >> clean [
	profiler
		ifNotNil: [ self cleanInstrumentation.
			profiler := nil.
			numIteration := 0 ].
	testRunner ifNotNil: [ SSTestRunner removeSelector: #compileTestCase ]
]

{ #category : #accessing }
SCoverageWithProfiler class >> cleanInstrumentation [
[ profiler cleanInstrumentation ]
				on: AssertionFailure
				do: [  ].
]

{ #category : #compiling }
SCoverageWithProfiler class >> compileTestCase: aTestCase [
	testRunner
		compile: aTestCase parseTree
		withName: #compileTestCase
		on: SSTestRunner
]

{ #category : #running }
SCoverageWithProfiler class >> computeFitness: aTestCase [
	self
		assert: [ aTestCase notNil ]
		description: 'testCase must not be nil'.
	profiler ifNil: [ self defaultFitnessInitialization ].
	self
		assert: [ profiler notNil ]
		description: 'Need to set a profiler of coverage'.
	numIteration <= self maxNumIterations
		ifTrue: [ [ self compileTestCase: aTestCase ]
				on: Error
				do: [ :e | 
					self halt.
					numIteration := numIteration + 1 ].
			self executeStatementsOf: aTestCase ].
	^ self functionName -> self coverage
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

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> defaultFitnessInitialization [
	SCoverageWithProfiler allSubclasses
		detect: [ :cls | cls profiler isNotNil ]
		ifFound: [ :cls | self profiler: cls profiler ]
		ifNone: [ self initializeProfiler ]
]

{ #category : #'class initialization' }
SCoverageWithProfiler class >> defaultInitialization [
	numIteration := 0.
	operator := #>.
	self testRunner 
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> executeStatementsOf: aTestCase [
	[ self profiler
		executeBlock: [ self testRunner perform: #compileTestCase ] ]
		on: Exception
		do: [ :exception | 
			self halt.
			(SException solve: exception of: aTestCase)
				ifFalse: [ ^ exception ].
			numIteration := numIteration + 1.
			self computeFitness: aTestCase ]
]

{ #category : #initialization }
SCoverageWithProfiler class >> initializeProfiler [
	| instanceFacade |
			instanceFacade := SSmallSuiteGenerator instance.
			instanceFacade
				ifNotNil: [ | dataProfiler |
					dataProfiler := instanceFacade dataFitnessCoverage.
					instanceFacade ofClass
						ifTrue: [ self coverageOf: dataProfiler first onClass: dataProfiler second ]
						ifFalse: [ self
								coverageOf: dataProfiler first
								onPackagesMatching: dataProfiler second ] ]
]

{ #category : #testing }
SCoverageWithProfiler class >> is: aTestCase1 betterThan: aTestCase2 [
	^ (aTestCase1 fitness at: self functionName)
				perform: self operator
				with: (aTestCase2 fitness at: self functionName)
]

{ #category : #accessing }
SCoverageWithProfiler class >> maxNumIterations [
	^ 3
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
SCoverageWithProfiler class >> stringToCreateNewClass: aClassName with: aSuperClassName and: aPackageName [
	^ aSuperClassName, ' subclass: #', aClassName, ' 
    instanceVariableNames: ''''
    classVariableNames: ''''
    package: ''', aPackageName, ''''
]

{ #category : #accessing }
SCoverageWithProfiler class >> testRunner [
	testRunner ifNil: [ testRunner := SSTestRunner new ].
	^ testRunner 
]
