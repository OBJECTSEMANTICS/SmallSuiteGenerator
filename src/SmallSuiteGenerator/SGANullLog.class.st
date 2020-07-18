Class {
	#name : #SGANullLog,
	#superclass : #SGALog,
	#category : #'SmallSuiteGenerator-Core'
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
