Class {
	#name : #SSimpleFitnessFunction,
	#superclass : #SFitnessFunction,
	#classInstVars : [
		'numIteration',
		'compilerTest'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #'as yet unclassified' }
SSimpleFitnessFunction class >> allFitnessFunction [
	^ Array with: self
]

{ #category : #actions }
SSimpleFitnessFunction class >> cleanAll [
	self clean.
	inputData := nil.
	isOnClass := nil
]

{ #category : #compiling }
SSimpleFitnessFunction class >> compileTestCase: aTestCase [
	self compilerTest
		compile:
			'compileTestCase' , String cr
				, (SCompilerMethod nodeFormedFrom: aTestCase) body formattedCode
]

{ #category : #accessing }
SSimpleFitnessFunction class >> compilerTest [
	compilerTest
		ifNil: [ compilerTest := self compiler
				evaluate:
					(SCompilerMethod
						stringToCreateNewClass: 'SCompilerTestCase'
						with: 'Object'
						and: 'SmallSuiteGenerator-Core') ].
	^ compilerTest
]

{ #category : #'as yet unclassified' }
SSimpleFitnessFunction class >> computeFitness: aTestCase [
	|result|
	numIteration ifNil: [ numIteration := 0 ].
	numIteration <= self maxNumIterations
		ifTrue: [ [ self compileTestCase: aTestCase ]
				on: Error
				do: [ :e | 
					self halt.
					numIteration := numIteration + 1 ].
			self executeStatementsOf: aTestCase ].
	result := self nameFunction -> (self valueFunction: aTestCase).
	self clean.
	^ result
]

{ #category : #'class initialization' }
SSimpleFitnessFunction class >> defaultInitialization [
	numIteration := 0.
	operator := #>
]

{ #category : #'as yet unclassified' }
SSimpleFitnessFunction class >> executeStatements [
	self subclassResponsibility 
	"self instance
		executeBlock: [ self compilerTest new perform: #compileTestCase ]"
]

{ #category : #'as yet unclassified' }
SSimpleFitnessFunction class >> executeStatementsOf: aTestCase [
	[ self executeStatements ]
		on: Exception
		do: [ :exception | 
			self halt.
			(SException solve: exception of: aTestCase)
				ifFalse: [ ^ exception ].
			numIteration := numIteration + 1.
			self computeFitness: aTestCase ]
]

{ #category : #accessing }
SSimpleFitnessFunction class >> maxNumIterations [
	^ 3
]

{ #category : #'as yet unclassified' }
SSimpleFitnessFunction class >> valueFunction: testCase [
	^ self subclassResponsibility
]
