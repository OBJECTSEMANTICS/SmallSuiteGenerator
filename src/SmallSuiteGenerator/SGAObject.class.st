Class {
	#name : #SGAObject,
	#superclass : #Object,
	#instVars : [
		'randomGenerator'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SGAObject >> randomGenerator: sRandom [
	"The argument must be an instance of Random"

	randomGenerator := sRandom
]
