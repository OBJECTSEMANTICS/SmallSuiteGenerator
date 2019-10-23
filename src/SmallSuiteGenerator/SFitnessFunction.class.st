Class {
	#name : #SFitnessFunction,
	#superclass : #Object,
	#instVars : [
		'tagetPackagesRegex'
	],
	#classInstVars : [
		'operator'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SFitnessFunction >> compute: testCaseCollection [
	^ self subclassResponsibility.
]

{ #category : #accessing }
SFitnessFunction >> tagetPackagesRegex [
	^ tagetPackagesRegex
]

{ #category : #accessing }
SFitnessFunction >> tagetPackagesRegex: anObject [
	tagetPackagesRegex := anObject
]
