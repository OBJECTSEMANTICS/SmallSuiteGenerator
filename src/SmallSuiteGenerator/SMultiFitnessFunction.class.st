"
SMultiFitnessFunciton is the fitness function that contains simple fitness function's collection.
"
Class {
	#name : #SMultiFitnessFunction,
	#superclass : #SFitnessFunction,
	#instVars : [
		'functionList'
	],
	#classInstVars : [
		'multiFitnessFunction'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'instance creation' }
SMultiFitnessFunction class >> methodAndStatementCoverage [
	| inst |
	inst := self new.
	inst add: SMethodCoverage new weight: 0.6.
	inst add: SStatementCoverage new weight: 0.4.
	^ inst
]

{ #category : #accessing }
SMultiFitnessFunction >> add: aFitness weight: aFloat [
	aFitness weight: aFloat.
	aFitness profiler: self profiler.
	aFitness targetClass: targetClass.
	functionList at: aFitness functionName put: aFitness.
]

{ #category : #accessing }
SMultiFitnessFunction >> computeFitness [
	| fitness |
	fitness := (functionList collect: [ :each | 
		(each computeFitness second) * each weight ]) sum.
	^ fitness
]

{ #category : #accessing }
SMultiFitnessFunction >> computeMultiFitnessOf: aTestCase [
	| fitness fitnessByClass |
	fitness := (functionList collect: [ :each | 
		(aTestCase fitnessFor: each functionName) * each weight ]) sum.
	fitnessByClass := Dictionary new.
	functionList collect: [ :each | 
		fitnessByClass sum: (aTestCase fitnessByClass at: each functionName) * each weight ].
	aTestCase fitnessByClass at: self functionName put: fitnessByClass.
	aTestCase fitness at: self functionName put: fitness.
]

{ #category : #accessing }
SMultiFitnessFunction >> consideringNSuperclasses: anInteger [
	functionList do: [ :func | func consideringNSuperclasses: anInteger ]
]

{ #category : #accessing }
SMultiFitnessFunction >> fitnessOf: aTestCase [
	functionList do: [ :func | func fitnessOf: aTestCase ].
	self computeMultiFitnessOf: aTestCase.
	
]

{ #category : #accessing }
SMultiFitnessFunction >> functionName [
	^ 'multi-coverage'
]

{ #category : #initialization }
SMultiFitnessFunction >> initialize [ 
	super initialize.
	functionList := Dictionary new.
]

{ #category : #accessing }
SMultiFitnessFunction >> profiler: aProfiler [
	profiler := aProfiler.
	self updateFunctionList
]

{ #category : #accessing }
SMultiFitnessFunction >> targetClass: anObject [
	targetClass := anObject.
	self updateFunctionList.
]

{ #category : #accessing }
SMultiFitnessFunction >> updateFunctionList [
	functionList do: [ :func |
		func profiler: profiler.
		func targetClass: targetClass.	
	 ]
]
