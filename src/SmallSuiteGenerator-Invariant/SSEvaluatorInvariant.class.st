Class {
	#name : #SSEvaluatorInvariant,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Invariant'
}

{ #category : #accessing }
SSEvaluatorInvariant >> apply: selectedInvariants invariantsTo: varName varNameWith: aValue valueIn: testCase [
	| filteredInvariants invariants |
	filteredInvariants := OrderedCollection new.
	invariants := (selectedInvariants isNil or: [selectedInvariants isEmpty]) ifTrue: [ SSAssertion allSubclasses ] ifFalse: [ selectedInvariants ].
	invariants
		do:
			[ :rule | filteredInvariants addAll: (rule applyOn: varName with: aValue of: testCase) ].
	^ filteredInvariants
]
