Class {
	#name : #SDeprecationInitialization,
	#superclass : #SDeprecation,
	#classInstVars : [
		'instance'
	],
	#category : #'SmallSuiteGenerator-Exception-Management'
}

{ #category : #'as yet unclassified' }
SDeprecationInitialization class >> isExpectedSelector: aString [
	^ aString = '#initialize'
]

{ #category : #'as yet unclassified' }
SDeprecationInitialization class >> modify: aTestCase solvingException: aException with: dataDeprecation [
	(aTestCase changeStatementOfClassName: dataDeprecation first asSymbol)
		ifFalse: [ aTestCase
				addFactoryMessage: (aException explanationString splitOn: ' ') third asSymbol ].
	^ true
]
