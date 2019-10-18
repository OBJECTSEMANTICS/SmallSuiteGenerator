Class {
	#name : #SFitnessFunction,
	#superclass : #Object,
	#classInstVars : [
		'operator'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SFitnessFunction class >> allFitnessFunction [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SFitnessFunction class >> clean [
	self subclassResponsibility
]

{ #category : #running }
SFitnessFunction class >> computeFitness: aTestCase [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SFitnessFunction class >> functionName [
	^ self name
]

{ #category : #testing }
SFitnessFunction class >> is: aTestCase1 betterThan: aTestCase2 [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SFitnessFunction class >> operator [
	^ operator
]
