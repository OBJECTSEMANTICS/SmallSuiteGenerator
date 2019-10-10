Class {
	#name : #SFitnessFunction,
	#superclass : #Object,
	#classInstVars : [
		'inputData',
		'isOnClass',
		'operator'
	],
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #'as yet unclassified' }
SFitnessFunction class >> allFitnessFunction [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SFitnessFunction class >> clean [
	self subclassResponsibility
]

{ #category : #actions }
SFitnessFunction class >> cleanAll [
	self clean.
	inputData := nil.
	isOnClass := nil
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

{ #category : #'as yet unclassified' }
SFitnessFunction class >> configureWith: smallSuiteGenerator [
]

{ #category : #accessing }
SFitnessFunction class >> inputData [
	^ inputData
]

{ #category : #accessing }
SFitnessFunction class >> inputData: array [
	inputData := array
]

{ #category : #testing }
SFitnessFunction class >> is: aTestCase1 betterThan: aTestCase2 [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SFitnessFunction class >> isOnClass [
	^ isOnClass
]

{ #category : #accessing }
SFitnessFunction class >> isOnClass: boolean [
	isOnClass := boolean
]

{ #category : #'as yet unclassified' }
SFitnessFunction class >> nameFunction [
	^ self name
]
