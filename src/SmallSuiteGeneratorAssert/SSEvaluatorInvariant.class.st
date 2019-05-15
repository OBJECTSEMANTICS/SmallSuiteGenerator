Class {
	#name : #SSEvaluatorInvariant,
	#superclass : #Object,
	#category : #'SmallSuiteGeneratorAssert-Invariant'
}

{ #category : #'as yet unclassified' }
SSEvaluatorInvariant >> apply: selectedInvariants invariantsTo: varName varNameWith: aValue valueIn: testCase [
	| filteredInvariants invariants |
	filteredInvariants := OrderedCollection new.
	invariants := (selectedInvariants isNil or: [selectedInvariants isEmpty]) ifTrue: [ SSAssertion allSubclasses ] ifFalse: [ selectedInvariants ].
	invariants
		do:
			[ :rule | filteredInvariants addAll: (rule applyOn: varName with: aValue of: testCase) ].
	^ filteredInvariants
]
