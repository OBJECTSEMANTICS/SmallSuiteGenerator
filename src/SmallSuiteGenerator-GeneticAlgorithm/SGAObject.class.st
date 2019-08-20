Class {
	#name : #SGAObject,
	#superclass : #SObject,
	#instVars : [
		'random'
	],
	#category : #'SmallSuiteGenerator-GeneticAlgorithm'
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

{ #category : #querying }
SGAObject >> randomNumber [
	^ random next
]

{ #category : #querying }
SGAObject >> randomNumber: aInt [
	^ random nextInt: aInt
]
