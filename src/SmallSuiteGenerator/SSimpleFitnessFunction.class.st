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
SSimpleFitnessFunction >> funtionName [
	^ self subclassResponsibility
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
