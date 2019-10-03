Class {
	#name : #SComparisonAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGenerator-Assertion-Assertion'
}

{ #category : #'as yet unclassified' }
SComparisonAssertion class >> applyOn: aName with: aObject of: testCase [
	| instance |
	instance := self new
		nameValue: aName;
		valueAssert: aObject;
		comparableValue: aObject.
	^ Array with: instance
]

{ #category : #preconditions }
SComparisonAssertion class >> preconditionChecking: aObject [
	aObject isLiteral
		ifTrue: [ ^ false ].
	[aObject smallStoreString ] on: SError do: [  ^ false ].
	^ (aObject class allSelectorsBelow: Object)
		detect: [ :selector | selector = #= ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #printing }
SComparisonAssertion >> printString [ 
	^ 'self assert: ', nameValue asString, (
	(self class preconditionChecking: comparableValue) ifTrue: [ ' equals: ', comparableValue storeString ] 
	ifFalse: [ ' className equals: ''', comparableValue className, '''' ]).
]
