Class {
	#name : #SGALog,
	#superclass : #Object,
	#instVars : [
		'generationNumber',
		'timeToProduceGeneration',
		'fittestTestCase'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
}

{ #category : #accessing }
SGALog >> fitness [ 	
	^ fittestTestCase fitness
	
]

{ #category : #accessing }
SGALog >> fittestTestCase [
	^ fittestTestCase
]

{ #category : #accessing }
SGALog >> fittestTestCase: anTestCase [
	fittestTestCase := anTestCase
]

{ #category : #accessing }
SGALog >> generationNumber [
	^ generationNumber
]

{ #category : #accessing }
SGALog >> generationNumber: anObject [
	generationNumber := anObject
]

{ #category : #printing }
SGALog >> printOn: str [
	super printOn: str.
	str nextPut: $<;
	nextPutAll: fittestTestCase statements asString;
	nextPut: $>.
]

{ #category : #accessing }
SGALog >> timeToProduceGeneration [
	^ timeToProduceGeneration
]

{ #category : #accessing }
SGALog >> timeToProduceGeneration: anInteger [
	timeToProduceGeneration := anInteger
]
