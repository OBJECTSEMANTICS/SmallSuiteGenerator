Class {
	#name : #SErrorMethod,
	#superclass : #SException,
	#category : #'SmallSuiteGenerator-Exception-Management'
}

{ #category : #testing }
SErrorMethod class >> canResolve: aException [
	|messageText|
	aException className = 'Error' ifFalse: [ ^ false ].
	messageText := aException messageText splitOn: ' '.
	^ (messageText second beginsWith: '#') and: [messageText fourth = 'instead']
]

{ #category : #'as yet unclassified' }
SErrorMethod class >> solveException: aException of: aTestCase [
	| selector className |
	(self canResolve: aException)
		ifFalse: [ ^ false ].
	selector := (aException messageText splitOn: ' ') second allButFirst
		asSymbol.
	className := self signalerName: aException.
	^ [
	
	aTestCase changeStatementOfClassName: className.
	aTestCase addMessage: selector from: className.
	true ]
		on: SError
		do: [ false ]
]
