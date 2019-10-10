Class {
	#name : #SMutationFunction,
	#superclass : #SSimpleFitnessFunction,
	#instVars : [
		'classesToMutate',
		'operators',
		'evaluationStrategy',
		'invariants',
		'generalResult',
		'testNameClasses'
	],
	#classInstVars : [
		'function',
		'classesNamesOfTest'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #'as yet unclassified' }
SMutationFunction class >> classesForRegex: regexExpressions [
	^ (regexExpressions
		flatCollect: [ :regex | 
			RPackage organizer packages
				select: [ :p | regex match: p name asString ] ]) asSet
		flatCollect: #definedClasses
]

{ #category : #accessing }
SMutationFunction class >> classesNamesOfTest: strings [
	classesNamesOfTest := strings
]

{ #category : #accessing }
SMutationFunction class >> clean [
	SUtil resetCreatedClasses 
]

{ #category : #'as yet unclassified' }
SMutationFunction class >> computeFitness: aTestCase [
	self
		assert: [ aTestCase notNil ]
		description: 'testCase must not be nil'.
	function ifNil: [ self defaultInitializationFunction].
	self
		assert: [ function notNil ]
		description: 'Need to set an analyzer of coverage'.
	^ super computeFitness: aTestCase
]

{ #category : #'as yet unclassified' }
SMutationFunction class >> configureWith: smallSuiteGenerator [
	self
		classesNamesOfTest: (Array with: smallSuiteGenerator classNameOfTest).
]

{ #category : #'as yet unclassified' }
SMutationFunction class >> defaultInitializationFunction [
	self mutationScoreOf: self testClasses using: classesNamesOfTest
]

{ #category : #'as yet unclassified' }
SMutationFunction class >> executeStatements [
	self compilerTest new perform: #compileTestCase

	
]

{ #category : #testing }
SMutationFunction class >> is: aTestCase1 betterThan: aTestCase2 [
		^ (aTestCase1 fitness at: self nameFunction)
		perform: self comparisonOperator
		with: (aTestCase2 fitness at: self nameFunction)
]

{ #category : #'as yet unclassified' }
SMutationFunction class >> mutationScoreOf: classes using: testClassesNames [
	self
		mutationScoreOf: classes
		using: testClassesNames
		operators: MutantOperator contents
		and: AllTestsMethodsRunningMutantEvaluationStrategy new
]

{ #category : #'as yet unclassified' }
SMutationFunction class >> mutationScoreOf: classes using: testClassesNames operators: operators and: evalStrategy [
	self defaultInitialization.
	function := self new
		classesToMutate: classes;
		classesNames: testClassesNames;
		operators: operators;
		evaluationStrategy: evalStrategy
]

{ #category : #tests }
SMutationFunction class >> testClasses [
	self assert: inputData description: 'Set input data #(block (class or regex))'.
	^ isOnClass
		ifTrue: [ Array with: inputData second ]
		ifFalse: [ self classesForRegex: inputData second ]
]

{ #category : #'as yet unclassified' }
SMutationFunction class >> valueFunction: testCase [
	^ function computeFitness: testCase
]

{ #category : #accessing }
SMutationFunction >> classes [
	testNameClasses
		do: [ :string | 
			(Smalltalk classNamed: string)
				ifNil: [ SUtil
						createClass: string
						ofPackage: SConfiguration defaultTestPackage ] ].
	^ SUtil compilersTests 
]

{ #category : #accessing }
SMutationFunction >> classesNames: strings [
	testNameClasses := strings
]

{ #category : #accessing }
SMutationFunction >> classesToMutate: classes [
	classesToMutate := classes
]

{ #category : #'as yet unclassified' }
SMutationFunction >> computeFitness: testCase [
	| analyzer |
	self
		assert: (testNameClasses isNotNil and: [ testNameClasses isNotEmpty ])
		description: 'Set test classes.'.
	self
		assert: (classesToMutate isNotNil and: [ classesToMutate isNotEmpty ])
		description: 'Set classes to mutate.'.
	testCase generateTestsWith: invariants.
	analyzer := MutationTestingAnalysis
		testCasesFrom: self classes 
		mutating: classesToMutate
		using: operators
		with: evaluationStrategy.
	analyzer run.
	generalResult := analyzer generalResult.
	^ self mutationScore
]

{ #category : #accessing }
SMutationFunction >> evaluationStrategy: anEvaluationStrategy [
	evaluationStrategy := anEvaluationStrategy 
]

{ #category : #initialization }
SMutationFunction >> initialize [
	operators := MutantOperator contents.
	evaluationStrategy := AllTestsMethodsRunningMutantEvaluationStrategy
		new.
	invariants := #()
]

{ #category : #details }
SMutationFunction >> mutationScore [ 
	^ (generalResult numberOfAliveMutants = 0 and: [ generalResult  numberOfKilledMutants = 0 ]) ifTrue: [ 0 ] ifFalse: [ generalResult mutationScore ]
]

{ #category : #accessing }
SMutationFunction >> operators: collection [
	operators := collection
]
