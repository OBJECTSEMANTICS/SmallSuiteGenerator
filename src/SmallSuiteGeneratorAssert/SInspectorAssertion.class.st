Class {
	#name : #SInspectorAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGeneratorAssert-Assertion'
}

{ #category : #'as yet unclassified' }
SInspectorAssertion class >> applyOn: aName with: aObject [
	| instance selector |
	selector := self preconditionChecking: aObject.
	selector ifNil: [ ^ #() ].
	instance := self new 
	nameValue: aName;
	valueAssert: aObject; 
	comparableValue: selector.
	^ { instance }
]

{ #category : #preconditions }
SInspectorAssertion class >> preconditionChecking: aObject [
	| method |
	(aObject class methods reject: [:meth | meth isQuick or: [meth selector includes: $: ]]) shuffle
	detect: [ :aCompileMethod | 
		[(aObject perform: aCompileMethod selector) isLiteral] on: Exception do: [ false ]
	] ifFound: [ :aCompileMethod | method := aCompileMethod selector ].
	^ method
]

{ #category : #printing }
SInspectorAssertion >> printString [ 	
	^ 'self assert: ', nameValue asString, ' ', comparableValue asString , ' equals: ', (valueAssert perform: comparableValue) storeString
]
