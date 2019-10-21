Class {
	#name : #SErrorFactoryMessage,
	#superclass : #SException,
	#category : #'SmallSuiteGenerator-Exception'
}

{ #category : #testing }
SErrorFactoryMessage class >> canResolve: aException [
	| messageText |
	aException className = 'Error'
		ifFalse: [ ^ false ].self halt.
	messageText := aException messageText splitOn: ' '.
	^ (messageText second beginsWith: '#') not
]

{ #category : #'as yet unclassified' }
SErrorFactoryMessage class >> solveException: aException of: aTestCase [
	|  className |
	(self canResolve: aException)
		ifFalse: [ ^ false ].
	className := self signalerName: aException.
	^ [ aTestCase changeStatementOfClassName: className.
	true ]
		on: SError
		do: [ false ]
]
