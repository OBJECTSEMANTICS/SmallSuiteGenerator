"
SGALog saves some important data about genetic algorithm evolution like: genetic algotithm's generation number, testCase with the highest fitness and time in which is produced the generation.

In each iteration of the genetic algorithm a new instance of the class is created.

Instance Variables

	fittestTestCase:				<STestCase>
	generationNumber:				<Smallnteger>
	timeToProduceGeneration:		<SmallInteger>
"
Class {
	#name : #SGALog,
	#superclass : #SObject,
	#instVars : [
		'generationNumber',
		'timeToProduceGeneration',
		'fittestTestCase',
		'mutationResult'
	],
	#category : #'SmallSuiteGenerator-GA'
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

{ #category : #initialization }
SGALog >> initialize [ 	
	mutationResult := Dictionary new
]

{ #category : #accessing }
SGALog >> mutationResult [
	^ mutationResult 
]

{ #category : #accessing }
SGALog >> mutationResult: mutationTestingResult [
	self
		assert: mutationResult isEmpty
		description: 'The analysis of mutants has already been calculated'.
	[ mutationResult
		at: 'noEvaluatedMutants'
			put: mutationTestingResult numberOfEvaluatedMutants;
		at: 'noKilledOrTerminatedMutants'
			put: mutationTestingResult numberOfKilledOrTerminatedMutants;
		at: 'noAliveMutants'
			put: mutationTestingResult numberOfAliveMutants;
		at: 'mutationScore' put: mutationTestingResult mutationScore ]
		on: Exception
		do: [ nil ]
]

{ #category : #printing }
SGALog >> printOn: str [
	super printOn: str.
	str
		nextPut: $<;
		nextPutAll: fittestTestCase statements printString;
		nextPut: $>
]

{ #category : #accessing }
SGALog >> timeToProduceGeneration [
	^ timeToProduceGeneration
]

{ #category : #accessing }
SGALog >> timeToProduceGeneration: anInteger [
	timeToProduceGeneration := anInteger
]
