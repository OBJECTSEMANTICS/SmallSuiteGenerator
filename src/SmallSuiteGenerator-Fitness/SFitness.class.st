Class {
	#name : #SFitness,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Fitness'
}

{ #category : #running }
SFitness >> run: aSTestCase [
	^ self subclassResponsibility
]
