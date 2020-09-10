"
SGANullLog saves only the data that is important for the genetic evolution algorithm to work, that is: generationNumber, fittestTestCase, timeToProduceGeneration and lowestFit.
"
Class {
	#name : #SGANullLog,
	#superclass : #SGAAbstractLog,
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #log }
SGANullLog class >> logOf: aSGAEngine inGeneration: anInteger inTime: t [
	| log |
	log := self new 
		generationNumber: anInteger;
		fittestTestCase: aSGAEngine population first;
		timeToProduceGeneration: Time new asSeconds - t;
		lowestFit: aSGAEngine population last fitness.
	^ log
]

{ #category : #summaries }
SGANullLog class >> summaryExecutionMethodsOf: aTestCase with: aProfiler [
]
