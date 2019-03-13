Class {
	#name : #SCollectionSimilarityAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGeneratorAssert-Assertion'
}

{ #category : #'as yet unclassified' }
SCollectionSimilarityAssertion class >> applyOn: aName with: aCollection [
	| instance |
	(self preconditionChecking: aCollection) ifFalse:[ ^ #()].
	instance := self new 
	nameValue: aName;
	valueAssert: aCollection; 
	comparableValue: aCollection first.
	^ { instance }
]

{ #category : #preconditions }
SCollectionSimilarityAssertion class >> preconditionChecking: aObject [
	^ aObject isCollection and: [ [
		aObject allButFirst anySatisfy: [ :element | element = aObject first ]
		] on: Error do: [ false ]
	]
]

{ #category : #printing }
SCollectionSimilarityAssertion >> printString [ 
	^ 'self assert: ( ', nameValue asString, ' allButFirst anySatisfy: [:element | element = ', comparableValue storeString, '])'.
]
