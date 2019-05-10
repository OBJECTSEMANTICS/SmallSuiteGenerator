Class {
	#name : #SInspectorAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGeneratorAssert-Assertion'
}

{ #category : #'as yet unclassified' }
SInspectorAssertion class >> applyOn: aName with: aObject of: testCase [
	| instance selector |
	selector := self preconditionChecking: aObject using: testCase.
	selector ifNil: [ ^ #() ].
	instance := self new
		nameValue: aName;
		valueAssert: aObject;
		comparableValue: selector.
	^ {instance}
]

{ #category : #'as yet unclassified' }
SInspectorAssertion class >> preconditionChecking: aObject using: aTestCase [
	| class copyObject selector |
	selector := nil.
	(aObject isNil or: [ aTestCase isNil ])
		ifTrue: [ ^ selector ].
	class := aTestCase profile classAt: aObject class name ifNone: [ ^ selector ].
	[ copyObject := aObject deepCopy ]
		on: Error
		do: [ ^ selector ].
	(class methods
		select: [ :method | 
			(method argTypes isNil
				and:
					((method selector includes: $:) not
						and: [ method returnType isNotNil ]))
				or: [ method argTypes isNotNil and: [ method argTypes isEmpty ] ] ])
		shuffle
		detect: [ :aCompileMethod | 
			[ | result |
			result := copyObject perform: aCompileMethod selector.
			copyObject := aObject deepCopy.
			result isLiteral ]
				on: Error
				do: [ false ] ]
		ifFound: [ :aCompileMethod | selector := aCompileMethod selector ].
	^ selector
]

{ #category : #printing }
SInspectorAssertion >> printString [ 	
	^ 'self assert: ', nameValue asString, ' ', comparableValue asString , ' equals: ', (valueAssert perform: comparableValue) storeString
]
