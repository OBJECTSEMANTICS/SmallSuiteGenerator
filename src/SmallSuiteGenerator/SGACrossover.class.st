"
SGACrossover is an abstract class that defines a technique that decides whether two GA individuals should crossover or not.
"
Class {
	#name : #SGACrossover,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Strategies'
}

{ #category : #asserting }
SGACrossover >> shouldCrossOver: testCaseA with: testCaseB [
	self subclassResponsibility 
]
