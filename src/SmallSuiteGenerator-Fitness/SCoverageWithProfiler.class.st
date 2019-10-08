Class {
	#name : #SCoverageWithProfiler,
	#superclass : #SSimpleFitnessFunction,
	#classInstVars : [
		'profiler'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SCoverageWithProfiler class >> clean [
	profiler
		ifNotNil: [ self cleanInstrumentation.
			profiler := nil.
			numIteration := 0.
			]
]

{ #category : #accessing }
SCoverageWithProfiler class >> cleanInstrumentation [
[ profiler cleanInstrumentation ]
				on: AssertionFailure
				do: [  ].
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> computeFitness: aTestCase [
	self
		assert: [ aTestCase notNil ]
		description: 'testCase must not be nil'.
	self defaultFitnessInitialization.
	self
		assert: [ profiler notNil ]
		description: 'Need to set a profiler of coverage'.
	^ super computeFitness: aTestCase
]

{ #category : #metric }
SCoverageWithProfiler class >> coverage [ 
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> coverageOf: aBlock onClass: aClass [
	profiler
		ifNil: [ self defaultInitialization.
			isOnClass := true.
			inputData := Array with: aBlock with: aClass.
			profiler := SBProfiler new
				profile: aBlock onClass: aClass;
				yourself ]
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> coverageOf: aBlock onPackagesMatching: regex [
	profiler
		ifNil: [ self defaultInitialization.
			isOnClass := false.
			inputData := Array with: aBlock with: regex.
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

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> executeStatements [
	self profiler
		executeBlock: [ self compilerTest new perform: #compileTestCase ]
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> initializeProfiler [
	| block anObject |
	self
		assert:
			(isOnClass isNotNil
				and: [ inputData isNotNil and: [ inputData size = 2 ] ])
		description: 'Set fitness data.'.
	block := inputData first.
	anObject := inputData second.
	isOnClass
		ifTrue: [ self coverageOf: block onClass: anObject ]
		ifFalse: [ self coverageOf: block onPackagesMatching: anObject ]
]

{ #category : #testing }
SCoverageWithProfiler class >> is: aTestCase1 betterThan: aTestCase2 [
	^ (aTestCase1 fitness at: self nameFunction)
				perform: self comparisonOperator
				with: (aTestCase2 fitness at: self nameFunction)
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
SCoverageWithProfiler class >> stringToCreateNewClass: aClassName with: aSuperClassName and: aPackageName [
	^ aSuperClassName, ' subclass: #', aClassName, ' 
    instanceVariableNames: ''''
    classVariableNames: ''''
    package: ''', aPackageName, ''''
]

{ #category : #'as yet unclassified' }
SCoverageWithProfiler class >> valueFunction: testCase [
	^ self coverage
]
