Class {
	#name : #SStringAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGenerator-Assertion-Assertion'
}

{ #category : #'as yet unclassified' }
SStringAssertion class >> applyOn: aName with: aObject of: testCase [
	| instance |
	(self preconditionChecking: aObject)
		ifFalse: [ ^ #() ].
	instance := self new
		nameValue: aName;
		valueAssert: aObject;
		comparableValue: aObject.
	^ {instance}
]

{ #category : #preconditions }
SStringAssertion class >> preconditionChecking: aObject [
	^ (aObject class allSelectorsBelow: Object) 
	detect: [:selector | (selector = #printOn: or: [selector = #printString]) or: [selector = #asString]]
	ifFound: [ true ]
	ifNone: [ false ].
]

{ #category : #'as yet unclassified' }
SStringAssertion >> adjust: aString [
	^ aString copyWithRegex: '''+' matchesReplacedWith: ''''''
]

{ #category : #printing }
SStringAssertion >> printString [ 
	^ 'self assert: ', nameValue asString, ' asString equals: ''', (self adjust: comparableValue asString), ''''
]
