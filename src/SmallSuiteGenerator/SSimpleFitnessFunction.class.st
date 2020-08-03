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
		'profiler',
		'superclasses',
		'n'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SSimpleFitnessFunction >> compute: testCaseCollection [
	self setUp.
	self run: testCaseCollection.
	self tearDown.
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

{ #category : #accessing }
SSimpleFitnessFunction >> consideringNSuperclasses: anInteger [
	n := anInteger.
	self updateSuperclasses.
]

{ #category : #actions }
SSimpleFitnessFunction >> fitnessByClass [
	self subclassResponsibility
]

{ #category : #actions }
SSimpleFitnessFunction >> fitnessOf: testCase withKey: string [
	| assoc |
	assoc := self fitnessByClass.
	testCase fitnessByClass at: string put: assoc.
	testCase fitness at: string put: (self computeCoverageWith: assoc).
]

{ #category : #accesing }
SSimpleFitnessFunction >> functionName [
	^ self subclassResponsibility
]

{ #category : #initialization }
SSimpleFitnessFunction >> initialize [
	super initialize.
	n := 0.
	superclasses := #().
]

{ #category : #accesing }
SSimpleFitnessFunction >> profiler [
	^ profiler 
]

{ #category : #accesing }
SSimpleFitnessFunction >> profiler: aProfiler [
	profiler := aProfiler.
]

{ #category : #actions }
SSimpleFitnessFunction >> run: testCaseCollection [
	| string |
	string := self functionName.
	testCaseCollection
		do: [ :testCase | 
			testCase length > 0 ifTrue: [
				profiler cleanBlocksOfMethods.
				testCase "runWithoutAssertions"runWithoutAssertionsAndLastStatement.
				SGAEngine logClass summaryExecutionMethodsOf: testCase with: profiler.
				"testCase summaryExecutionMethods: profiler summaryExecutionMethods."
				"self abstractDataOn: testCase."
				self fitnessOf: testCase withKey: string. ]
			ifFalse: [ testCase fitness at: string put: 0 ] ]
	
]

{ #category : #actions }
SSimpleFitnessFunction >> runPopulation: testCaseCollection [
	profiler cleanBlocksOfMethods.
	testCaseCollection
		do: [ :testCase | 
			testCase length > 0 ifTrue: [ testCase "runWithoutAssertions"runWithoutAssertionsAndLastStatement ] ].
	^ profiler summaryMethodsOf: targetClass  
]

{ #category : #actions }
SSimpleFitnessFunction >> setUp [
]

{ #category : #actions }
SSimpleFitnessFunction >> tearDown [
]

{ #category : #accessing }
SSimpleFitnessFunction >> typeInfo: anObject [ 
	profiler typeInfo: anObject
]

{ #category : #accessing }
SSimpleFitnessFunction >> updateSuperclasses [
	superclasses := self aClass allSuperclasses collect: [:e | e name].
	n := (n min: superclasses size - 2). "avoid add Object and ProtoObject in superclasses"
	superclasses := (superclasses first: n) 
	
]
