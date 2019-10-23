"
Public API and Key Messages

- solve: exception of: testCase.

   One simple example is simply gorgeous.
 
It tries to selve the exception that is of kind: CollectionIsEmpty. To solve the exception, it looks in typeInfo to replace by another that is of the same type and contains elements.
"
Class {
	#name : #SCollectionEmpty,
	#superclass : #SException,
	#category : #'SmallSuiteGenerator-Exceptions'
}

{ #category : #testing }
SCollectionEmpty class >> canResolve: aException [
	^ aException className = 'CollectionEmpty'
]

{ #category : #'as yet unclassified' }
SCollectionEmpty class >> solveException: aException of: aTestCase [
	(self canResolve: aException)
		ifFalse: [ ^ false ].
	
]
