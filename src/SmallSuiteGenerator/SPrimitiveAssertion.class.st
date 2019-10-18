Class {
	#name : #SPrimitiveAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SPrimitiveAssertion class >> for: anExecutionContext [
	| assertions |
	assertions := OrderedCollection new.
	anExecutionContext
		keys
		do: [ :varName | 
			| value |
			value := anExecutionContext at: varName.
			(self isPrimitive: value)
				ifTrue: [ assertions
						add:
							(self new
								selector: #assert:equals:;
								args:
									(Array
										with: (SVariable name: varName)
										with: (SLiteral new value: value));
								yourself) ] ].
	^ assertions
]
