Class {
	#name : #SInspectorAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SInspectorAssertion class >> for: anExecutionContext [
	| assertions |
	assertions := OrderedCollection new.
	anExecutionContext keys 
	do: [ :varName | 
			| value |
			value := anExecutionContext at: varName.
			(value class methods select: #isReturnField)
				do: [ :compiledMethod | 
					| fieldValue |
					fieldValue := value perform: compiledMethod selector.
					(self isPrimitive: fieldValue)
						ifTrue: [ assertions
								add:
									(self new
										selector: #assert:equals:;
										args:
											(Array
												with:
													(SMessage new
														receiver: (SVariable name: varName);
														selector: compiledMethod selector;
														yourself)
												with: (SLiteral new value: fieldValue));
										yourself) ] ] ].
	^ assertions
]
