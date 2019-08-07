Class {
	#name : #SInspectorAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGenerator-Assertion-Assertion'
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
	^ Array with: instance
]

{ #category : #'as yet unclassified' }
SInspectorAssertion class >> preconditionChecking: aObject using: aTestCase [
	| typeClass selector methods |
	selector := nil.
	(aObject isNil or: [ aTestCase isNil ])
		ifTrue: [ ^ selector ].
	typeClass := aTestCase typeInfo
		classAt: aObject class name
		ifNone: [ ^ selector ].
	methods := typeClass allMethods
		select: [ :meth | 
			| argTypes |
			argTypes := meth argTypes.
			meth returnType type isNotNil
				and: [ (argTypes isNil or: [ argTypes isEmpty ])
						and: [ meth selector ~= #initialize ] ] ].
	methods ifNotEmpty: [ selector := methods first selector ].
	^ selector
]

{ #category : #printing }
SInspectorAssertion >> printString [ 	
	^ 'self assert: ', nameValue asString, ' ', comparableValue asString , ' equals: ', (valueAssert perform: comparableValue) storeString
]
