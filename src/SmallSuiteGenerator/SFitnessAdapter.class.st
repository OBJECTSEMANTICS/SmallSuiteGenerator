Class {
	#name : #SFitnessAdapter,
	#superclass : #SGAObject,
	#instVars : [
		'fitness',
		'engine'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'instance creation' }
SFitnessAdapter class >> withFitness: aFitness on: aEngine [
	^ self new 
		fitness: aFitness;
		engine: aEngine;
		yourself
]

{ #category : #actions }
SFitnessAdapter >> compute: aTestCaseColl [
	fitness isIndependent ifTrue: [ 
		fitness compute: aTestCaseColl.
	] ifFalse: [ 
	 	fitness compute: aTestCaseColl regardingAll: engine population.
	]
]

{ #category : #accessing }
SFitnessAdapter >> engine [
	^ engine
]

{ #category : #accessing }
SFitnessAdapter >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
SFitnessAdapter >> fitness [
	^ fitness
]

{ #category : #accessing }
SFitnessAdapter >> fitness: anObject [
	fitness := anObject
]
