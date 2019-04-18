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
