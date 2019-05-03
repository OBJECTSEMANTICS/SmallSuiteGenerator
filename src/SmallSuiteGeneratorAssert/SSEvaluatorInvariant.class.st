Class {
	#name : #SSEvaluatorInvariant,
	#superclass : #Object,
	#category : #'SmallSuiteGeneratorAssert-Invariant'
}

{ #category : #'as yet unclassified' }
SSEvaluatorInvariant >> applyRule: aName to: aValue of: testCase [
	| invariants |
	invariants := OrderedCollection new.
	SSAssertion allSubclasses
		do:
			[ :rule | invariants addAll: (rule applyOn: aName with: aValue of: testCase) ].
	^ invariants
]
