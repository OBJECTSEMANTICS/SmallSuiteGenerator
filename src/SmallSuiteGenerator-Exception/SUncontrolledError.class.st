Class {
	#name : #SUncontrolledError,
	#superclass : #SException,
	#category : #'SmallSuiteGenerator-Exception'
}

{ #category : #testing }
SUncontrolledError class >> canResolve: aException [
	^ aException className = 'Error' and: [ self listMessages includes: aException messageText  ]
]

{ #category : #'as yet unclassified' }
SUncontrolledError class >> listMessages [ 
	^ OrderedCollection new 
	add: 'Incorrect number of arguments'; yourself
]

{ #category : #'as yet unclassified' }
SUncontrolledError class >> signalerName: aException [
	^ [ super signalerName: aException  ] on: Error do: [ aException signalerContext sender methodClass name ]
]

{ #category : #'as yet unclassified' }
SUncontrolledError class >> solveException: aException of: aTestCase [
	| className |
	(self canResolve: aException)
		ifFalse: [ ^ false ].
	className := self signalerName: aException.
	^ [ aTestCase changeStatementOfClassName: className.
	
	true ]
		on: SError
		do: [ false ]
]
