Class {
	#name : #SObject,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SObject >> random [
	^ random
]

{ #category : #accessing }
SObject >> random: anObject [
	random := anObject
]
