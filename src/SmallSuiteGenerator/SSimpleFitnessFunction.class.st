Class {
	#name : #SSimpleFitnessFunction,
	#superclass : #SFitnessFunction,
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
