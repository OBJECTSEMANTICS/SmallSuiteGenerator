Class {
	#name : #SPrimitiveAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGenerator-Assertion'
}

{ #category : #action }
SPrimitiveAssertion class >> applyOn: aName with: aLiteral of: testCase [
	| instance |
	(self preconditionChecking: aLiteral)
		ifFalse: [ ^ #() ].
	instance := self new
		nameValue: aName;
		valueAssert: aLiteral;
		comparableValue: aLiteral.
	^ Array with: instance
]

{ #category : #preconditions }
SPrimitiveAssertion class >> preconditionChecking: aObject [
	^ aObject isLiteral
]

{ #category : #printing }
SPrimitiveAssertion >> printString [ 
	^ ['self assert: ', nameValue asString, ' equals: ', comparableValue storeString ]
	on: Error do: [ '' ]
]
