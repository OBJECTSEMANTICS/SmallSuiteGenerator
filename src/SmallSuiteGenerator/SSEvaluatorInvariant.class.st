Class {
	#name : #SSEvaluatorInvariant,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SSEvaluatorInvariant >> apply: selectedInvariants invariantsTo: varName varNameWith: aValue valueIn: testCase [
	| invariants |
	invariants := (selectedInvariants isNil
		or: [ selectedInvariants isEmpty ])
		ifTrue: [ SSAssertion allSubclasses ]
		ifFalse: [ selectedInvariants ].
	^ invariants
		flatCollect: [ :invariant | 
			[ invariant applyOn: varName with: aValue of: testCase ]
				on: Exception
				do: [ #() ] ]
]
