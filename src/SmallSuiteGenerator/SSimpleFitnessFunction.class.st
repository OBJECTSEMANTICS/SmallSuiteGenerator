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
		'profiler'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SSimpleFitnessFunction >> compute: testCaseCollection [
	self setUp.
	self run: testCaseCollection.
	self tearDown.
]

{ #category : #accesing }
SSimpleFitnessFunction >> functionName [
	^ self subclassResponsibility
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
	
	^ self subclassResponsibility.
	
]

{ #category : #actions }
SSimpleFitnessFunction >> setUp [
]

{ #category : #actions }
SSimpleFitnessFunction >> tearDown [
]
