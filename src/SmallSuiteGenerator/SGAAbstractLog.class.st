"
I'm an abstract class for Log generation
"
Class {
	#name : #SGAAbstractLog,
	#superclass : #SObject,
	#instVars : [
		'generationNumber',
		'timeToProduceGeneration',
		'fittestTestCase',
		'lowestFit'
	],
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #accessing }
SGAAbstractLog >> fittestTestCase [
	^ fittestTestCase
]

{ #category : #accessing }
SGAAbstractLog >> fittestTestCase: anObject [
	fittestTestCase := anObject
]

{ #category : #accessing }
SGAAbstractLog >> generationNumber [
	^ generationNumber
]

{ #category : #accessing }
SGAAbstractLog >> generationNumber: anObject [
	generationNumber := anObject
]

{ #category : #accessing }
SGAAbstractLog >> lowestFit [
	^ lowestFit
]

{ #category : #accessing }
SGAAbstractLog >> lowestFit: anObject [
	lowestFit := anObject
]

{ #category : #accessing }
SGAAbstractLog >> timeToProduceGeneration [
	^ timeToProduceGeneration
]

{ #category : #accessing }
SGAAbstractLog >> timeToProduceGeneration: anObject [
	timeToProduceGeneration := anObject
]
