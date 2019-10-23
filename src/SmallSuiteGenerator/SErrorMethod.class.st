Class {
	#name : #SErrorMethod,
	#superclass : #SException,
	#category : #'SmallSuiteGenerator-Exceptions'
}

{ #category : #testing }
SErrorMethod class >> canResolve: aException [
	| messageText |
	aException className = 'Error'
		ifFalse: [ ^ false ].
	messageText := aException messageText splitOn: ' '.
	^ (messageText second beginsWith: '#')
		and: [ messageText third = 'instead.' ]
]

{ #category : #'as yet unclassified' }
SErrorMethod class >> solveException: aException of: aTestCase [
	|  className |
	(self canResolve: aException)
		ifFalse: [ ^ false ].
	className := self signalerName: aException.
	^ [ aTestCase changeStatementOfClassName: className.
	aTestCase addMessage: (aException messageText splitOn: ' ') second allButFirst asSymbol from: className.
	true ]
		on: SError
		do: [ false ]
]
