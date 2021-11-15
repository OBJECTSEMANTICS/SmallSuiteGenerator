"
SSimpleFitnessFunction is an abstract class of simple fitness function like: 
	
	- SMethodCoverage -> It calculates the number of class methods executed
	- SStatementCoverage -> It calculates the number of statements executed 
	
Instance Variables
	profiler:		<SSTypeCollector>
	

"
Class {
	#name : #SSimpleFitnessFunction,
	#superclass : #SFitnessFunction,
	#instVars : [
		'weight',
		'superclasses',
		'n'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SSimpleFitnessFunction class >> profiler: aProfiler [
	^ self new profiler: aProfiler 
]

{ #category : #actions }
SSimpleFitnessFunction >> computeCoverageWith: assoc [
	| sum |
	
	sum := [assoc at: targetClass] on: Error do: [0].
	sum := superclasses
		inject: sum 
		into: [ :v :e | |val|
			val := [ assoc at: e ] on: Error do: [0].
			v + val ].
	^ sum / (n + 1)
]

{ #category : #actions }
SSimpleFitnessFunction >> computeFitness [
	| assoc |
	
	assoc := self fitnessByClass.
	^ Array with: (self computeCoverageWith: assoc) with: assoc.
]

{ #category : #accessing }
SSimpleFitnessFunction >> consideringNSuperclasses: anInteger [

	n := anInteger.
	self updateSuperclasses.
]

{ #category : #'as yet unclassified' }
SSimpleFitnessFunction >> coverageCriteria: className [
  ^self subclassResponsibility
]

{ #category : #actions }
SSimpleFitnessFunction >> fitnessByClass [

	self subclassResponsibility
]

{ #category : #actions }
SSimpleFitnessFunction >> fitnessOf: testCase [
	| fitness |
  fitness := self computeFitness.
  testCase fitness at: self functionName put: fitness first.
  testCase fitnessByClass at: self functionName put: fitness second
]

{ #category : #initialization }
SSimpleFitnessFunction >> initialize [

	super initialize.
	weight := 1.0.
	n := 0.
	superclasses := #().
]

{ #category : #actions }
SSimpleFitnessFunction >> multiFitnessByClassOf: testCase [
  SSimpleFitnessFunction subclasses do: [:subClass |  | instance |
        instance := subClass profiler: profiler.
        testCase multiFitnessByClass at: instance functionName put: (instance coverageCriteria: testCase targetClassesName) ].
	testCase multiFitnessByClass ifEmpty: [ self halt ]
]

{ #category : #actions }
SSimpleFitnessFunction >> run: testCaseCollection [
  testCaseCollection do: [:testCase |  testCase length > 0 ifTrue: [ profiler cleanBlocksOfMethods.
              testCase runWithoutAssertionsAndLastStatement.
              SGAEngine logClass summaryExecutionMethodsOf: testCase with: profiler.
              self fitnessOf: testCase.
				  self multiFitnessByClassOf: testCase
					 ] ifFalse: [ testCase fitness at: self functionName put: 0 ] ]
]

{ #category : #accessing }
SSimpleFitnessFunction >> updateSuperclasses [

	superclasses := self aClass allSuperclasses collect: [:e | e name].
	n := (n min: superclasses size - 2). "avoid add Object and ProtoObject in superclasses"
	superclasses := (superclasses first: n) 
	
]

{ #category : #accesing }
SSimpleFitnessFunction >> weight [

	^ weight
]

{ #category : #accesing }
SSimpleFitnessFunction >> weight: aFloat [

	weight := aFloat.
]
