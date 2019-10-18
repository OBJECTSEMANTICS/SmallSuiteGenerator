Class {
	#name : #SGAObject,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm-Core'
}

{ #category : #accessing }
SGAObject >> random [ 
	^ random
]

{ #category : #accessing }
SGAObject >> random: aRandomNumberGenerator [
	"The argument must be an instance of Random"

	random := aRandomNumberGenerator
]

{ #category : #'as yet unclassified' }
SGAObject >> randomNumber [
	^ random next
]

{ #category : #'as yet unclassified' }
SGAObject >> randomNumber: aInt [
	^ random nextInt: aInt
]
