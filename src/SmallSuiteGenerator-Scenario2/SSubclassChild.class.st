Class {
	#name : #SSubclassChild,
	#superclass : #SAbstractClass,
	#category : #'SmallSuiteGenerator-Scenario2'
}

{ #category : #accessing }
SSubclassChild >> identifier [ 
	^ self className, '_', self id asString
]
