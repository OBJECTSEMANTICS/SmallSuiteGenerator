Class {
	#name : #SFitnessFunction,
	#superclass : #Object,
	#classInstVars : [
		'operator'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #accessing }
SFitnessFunction class >> clear [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SFitnessFunction class >> comparisonOperator [
	^ operator
]

{ #category : #'as yet unclassified' }
SFitnessFunction class >> comparisonOperator: aSymbol [
	operator := aSymbol
]

{ #category : #'as yet unclassified' }
SFitnessFunction class >> computeFitness: aTestCase [
	^ self subclassResponsibility 
]

{ #category : #testing }
SFitnessFunction class >> is: aTestCase1 betterThan: aTestCase2 [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SFitnessFunction class >> nameFunction [
	^ self name
]
