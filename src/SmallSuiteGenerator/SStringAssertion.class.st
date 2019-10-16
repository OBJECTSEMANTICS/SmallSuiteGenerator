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
			(self isPrimitive: value) ifFalse:[
			(value class allSelectorsBelow: Object)
				detect: [ :selector | selector = #printOn: or: [ selector = #printString ] ]
				ifFound: [
					| fieldValue |
					fieldValue := value perform: #printString.
					assertions
						add:
							(self new
								selector: #assert:equals:;
								args:
									{(SMessage new
										receiver: (SVariable name: varName);
										selector: #printString;
										yourself).
									(SLiteral new value: fieldValue)};
								yourself) ] ]].
	^ assertions
]

{ #category : #visiting }
SStringAssertion >> accept: visitor [
	visitor visitStringAssertion: self.
	
]

{ #category : #'as yet unclassified' }
SStringAssertion >> adjust: aString [
	^ aString copyWithRegex: '''+' matchesReplacedWith: ''''''
]
