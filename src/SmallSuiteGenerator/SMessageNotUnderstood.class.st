Class {
	#name : #SMessageNotUnderstood,
	#superclass : #SException,
	#category : #'SmallSuiteGenerator-Exceptions'
}

{ #category : #testing }
SMessageNotUnderstood class >> canResolve: aException [
	^ aException className = 'MessageNotUnderstood'
]

{ #category : #'as yet unclassified' }
SMessageNotUnderstood class >> solveException: aException of: aTestCase [
	^ (self canResolve: aException)
		and: [ aTestCase
				changeMessageNotUnderstood: aException message selector
				from: (self signalerName: aException) ]
]
