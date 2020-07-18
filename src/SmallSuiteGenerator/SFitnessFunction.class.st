"
SFitnessFunction is an abstract class that represents a fitness abstract function used in genetic algorithm evolution to determine how fit a testCase is.




"
Class {
	#name : #SFitnessFunction,
	#superclass : #SGAObject,
	#instVars : [
		'tagetPackagesRegex',
		'targetClass'
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

{ #category : #accessing }
SFitnessFunction >> targetClass: anObject [
	targetClass := anObject
]
