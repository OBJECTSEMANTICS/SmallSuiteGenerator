Class {
	#name : #SCollectionSizeAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGenerator-Assertion-Assertion'
}

{ #category : #'as yet unclassified' }
SCollectionSizeAssertion class >> applyOn: aName with: aCollection of: testCase [
	| instance |
	(self preconditionChecking: aCollection)
		ifFalse: [ ^ #() ].
	instance := self new
		nameValue: aName;
		valueAssert: aCollection;
		comparableValue: aCollection size.
	^ {instance}
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
