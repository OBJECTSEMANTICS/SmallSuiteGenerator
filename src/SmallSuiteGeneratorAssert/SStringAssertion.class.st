Class {
	#name : #SStringAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGeneratorAssert-Assertion'
}

{ #category : #'as yet unclassified' }
SStringAssertion class >> applyOn: aName with: aObject [
	| instance |
	(self preconditionChecking: aObject) ifFalse:[ ^ #()].
	instance := self new 
	nameValue: aName;
	valueAssert: aObject; 
	comparableValue: aObject.
	^ { instance }
]

{ #category : #preconditions }
SStringAssertion class >> preconditionChecking: aObject [
	^ (aObject class allSelectorsBelow: Object) 
	detect: [:selector | (selector = #printOn: or: [selector = #printString]) or: [selector = #asString]]
	ifFound: [ true ]
	ifNone: [ false ].
]

{ #category : #printing }
SStringAssertion >> printString [ 
	^ 'self assert: ', nameValue asString, ' asString equals: ''', comparableValue asString, ''''
]
