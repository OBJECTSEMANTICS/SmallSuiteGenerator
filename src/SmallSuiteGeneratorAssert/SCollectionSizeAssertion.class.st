Class {
	#name : #SCollectionSizeAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGeneratorAssert-Assertion'
}

{ #category : #'as yet unclassified' }
SCollectionSizeAssertion class >> applyOn: aName with: aCollection [
	| instance |
	(self preconditionChecking: aCollection) ifFalse:[ ^ #()].
	instance := self new 
	nameValue: aName;
	valueAssert: aCollection; 
	comparableValue: aCollection size.
	^ { instance }
]

{ #category : #preconditions }
SCollectionSizeAssertion class >> preconditionChecking: aObject [
	^ aObject isCollection
]

{ #category : #printing }
SCollectionSizeAssertion >> printString [ 
	^ 'self assert: ', nameValue asString, (comparableValue = 0 ifTrue: [ ' isEmpty' ] 
	ifFalse: [ ' size equals: ', comparableValue storeString ]).
]
