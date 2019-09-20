Class {
	#name : #SDeprecationMethod,
	#superclass : #SDeprecation,
	#category : #'SmallSuiteGenerator-Exception-Management'
}

{ #category : #'as yet unclassified' }
SDeprecationMethod class >> isExpectedSelector: aString [
	^ aString ~= '#initialize'
]

{ #category : #'as yet unclassified' }
SDeprecationMethod class >> modify: aTestCase solvingException: aException with: array [
	"(aTestCase changeStatementOfClassName: dataDeprecation first)
		ifFalse: [ aTestCase
				addFactoryMessage: (aException explanationString splitOn: ' ') fourth asSymbol ].
	^ true"

	^ false
]
