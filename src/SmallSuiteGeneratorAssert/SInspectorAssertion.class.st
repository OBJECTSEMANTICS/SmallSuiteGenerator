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

{ #category : #'as yet unclassified' }
SInspectorAssertion class >> preconditionChecking: aObject [
	| method copyObject |
	method := nil.
	aObject ifNotNil: [ 
	copyObject := aObject deepCopy.
	(aObject class methods reject: [:meth | meth isQuick or: [meth selector includes: $: ]]) shuffle
	detect: [ :aCompileMethod | 
		[ | result |
		result := copyObject perform: aCompileMethod selector.
		copyObject := aObject deepCopy.
		result isLiteral] on: Error do: [ false ]
	] ifFound: [ :aCompileMethod | method := aCompileMethod selector ]].
	^ method
]

{ #category : #printing }
SInspectorAssertion >> printString [ 	
	^ 'self assert: ', nameValue asString, ' ', comparableValue asString , ' equals: ', (valueAssert perform: comparableValue) storeString
]
