"
SFitnessFunction is an abstract class that represents a fitness abstract function used in genetic algorithm evolution to determine how fit a testCase is.




"
Class {
	#name : #SFitnessFunction,
	#superclass : #SGAObject,
	#instVars : [
		'tagetPackagesRegex',
		'targetClass',
		'aClass'
	],
	#classInstVars : [
		'operator'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SFitnessFunction >> aClass [
	aClass ifNotNil: [ ^ aClass ].
	aClass := self class environment at: targetClass.
	^ aClass
]

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
