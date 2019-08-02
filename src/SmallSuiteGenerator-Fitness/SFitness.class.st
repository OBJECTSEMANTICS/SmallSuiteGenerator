Class {
	#name : #SFitness,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #running }
SFitness >> run: aSTestCase [
	^ self subclassResponsibility
]
