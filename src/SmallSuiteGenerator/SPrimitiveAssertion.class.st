Class {
	#name : #SPrimitiveAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'as yet unclassified' }
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

{ #category : #'instance creation' }
SPrimitiveAssertion class >> for: anExecutionContext [
	| assertions |
	assertions := OrderedCollection new.
	anExecutionContext keys
		do: [ :varName | 
			| value |
			value := anExecutionContext at: varName.
			(self isPrimitive: value)
				ifTrue: [ assertions
						add:
							(self new
								selector: #assert:equals:;
								args:
									{(SVariable name: varName).
									(SLiteral new value: value)};
								yourself) ] ].
	^ assertions
]

{ #category : #preconditions }
SPrimitiveAssertion class >> preconditionChecking: aObject [
	^ aObject isLiteral
]

{ #category : #visiting }
SPrimitiveAssertion >> accept: visitor [
	visitor visitPrimitiveAssertion: self
]
