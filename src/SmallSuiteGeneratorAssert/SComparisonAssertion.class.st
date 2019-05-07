Class {
	#name : #SComparisonAssertion,
	#superclass : #SSAssertion,
	#category : #'SmallSuiteGeneratorAssert-Assertion'
}

{ #category : #'as yet unclassified' }
SComparisonAssertion class >> applyOn: aName with: aObject of: testCase [
	| instance |
	"mejorar para que se genere el constructor del profile y no el storeString"
	instance := self new
		nameValue: aName;
		valueAssert: aObject;
		comparableValue: aObject.
	^ {instance}
]

{ #category : #preconditions }
SComparisonAssertion class >> preconditionChecking: aObject [
	aObject isLiteral
		ifTrue: [ ^ false ].
	^ (aObject class allSelectorsBelow: Object)
		detect: [ :selector | selector = #= ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #printing }
SComparisonAssertion >> printString [ 
	^ 'self assert: ', nameValue asString, (
	(self class preconditionChecking: comparableValue) ifTrue: [ ' equals: ', comparableValue storeString ] 
	ifFalse: [ ' className equals: ''', comparableValue className, '''' ]).
]
