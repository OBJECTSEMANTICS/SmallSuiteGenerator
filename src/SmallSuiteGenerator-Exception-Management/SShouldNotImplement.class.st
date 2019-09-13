Class {
	#name : #SShouldNotImplement,
	#superclass : #SException,
	#category : #'SmallSuiteGenerator-Exception-Management'
}

{ #category : #testing }
SShouldNotImplement class >> canResolve: aException [
	^ aException className = 'ShouldNotImplement'
]

{ #category : #'as yet unclassified' }
SShouldNotImplement class >> solveException: aException of: aTestCase [
	| signalerName |
	^ (self canResolve: aException)
		and: [
			signalerName := self signalerName: aException.
			aTestCase changeStatementOfClassName: signalerName.
			aTestCase addMessage: aException selector from: signalerName.
			true ]
]
