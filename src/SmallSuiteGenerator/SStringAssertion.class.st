Class {
	#name : #SStringAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SStringAssertion class >> for: anExecutionContext [
	| assertions |
	assertions := OrderedCollection new.
	anExecutionContext keys
		do: [ :varName | 
			| value |
			value := anExecutionContext at: varName.
			(self isPrimitive: value)
				ifFalse: [ (value class allSelectorsBelow: Object)
						detect: [ :selector | selector = #printOn: or: [ selector = #printString ] ]
						ifFound: [ | fieldValue |
							[ 
							fieldValue := value perform: #printString.
							assertions
								add:
									(self new
										selector: #assert:equals:;
										args:
											(Array
												with:
													(SMessage new
														receiver: (SVariable name: varName);
														selector: #printString;
														yourself)
												with: (SLiteral new value: fieldValue));
										yourself) ] on: Error do:[ Transcript show: (value class name),' cant answer printString without error']
										
										] ] ].
	^ assertions
]
