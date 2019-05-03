Class {
	#name : #SSAssertion,
	#superclass : #Object,
	#instVars : [
		'comparableValue',
		'valueAssert',
		'nameValue'
	],
	#category : #'SmallSuiteGeneratorAssert-Assertion'
}

{ #category : #'as yet unclassified' }
SSAssertion class >> applyOn: aName with: aCollection of: aTestCase [
	self subclassResponsibility 
]

{ #category : #accessing }
SSAssertion >> comparableValue [
	^ comparableValue
]

{ #category : #accessing }
SSAssertion >> comparableValue: anObject [
	comparableValue := anObject
]

{ #category : #accessing }
SSAssertion >> nameValue [
	^ nameValue
]

{ #category : #accessing }
SSAssertion >> nameValue: anObject [
	nameValue := anObject
]

{ #category : #'as yet unclassified' }
SSAssertion >> statement [
	^ nameValue asString, ' := ', valueAssert storeString
]

{ #category : #accessing }
SSAssertion >> valueAssert [
	^ valueAssert
]

{ #category : #accessing }
SSAssertion >> valueAssert: anObject [
	valueAssert := anObject
]
