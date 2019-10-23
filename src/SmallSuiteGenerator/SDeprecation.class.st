Class {
	#name : #SDeprecation,
	#superclass : #SException,
	#category : #'SmallSuiteGenerator-Exceptions'
}

{ #category : #testing }
SDeprecation class >> canResolve: aException [
	^ aException className = 'Deprecation'
]

{ #category : #'as yet unclassified' }
SDeprecation class >> isExpectedSelector: aSymbol [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SDeprecation class >> modify: aTestCase solvingException: aException with: array [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SDeprecation class >> solveException: aException of: aTestCase [
	| dataDeprecation methodName |
	
	((self canResolve: aException) and: [ aException deprecatedMethodName isNotNil ])
		ifFalse: [ ^ false ].
		methodName := aException deprecatedMethodName.
	dataDeprecation := methodName splitOn: '>>'.
	^ self subclasses
		detect: [ :aClass | 
			[ (aClass isExpectedSelector: dataDeprecation second)
				and: [ aClass
						modify: aTestCase
						solvingException: aException
						with: dataDeprecation ] ]
				on: Exception
				do: [ false ] ]
		ifFound: [ true ]
		ifNone: [ false ]
]
