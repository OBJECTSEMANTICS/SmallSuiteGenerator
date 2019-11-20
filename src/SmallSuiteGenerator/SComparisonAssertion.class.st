Class {
	#name : #SComparisonAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SComparisonAssertion class >> for: anExecutionContext [
	| assertions |
	assertions := OrderedCollection new.
	anExecutionContext keys
		combinations: 2
		atATimeDo: [ :comb | 
			| varName1 varName2 val1 val2 |
			varName1 := comb first.
			varName2 := comb second.
			val1 := anExecutionContext at: varName1.
			val2 := anExecutionContext at: varName2.
			val1 class = val2 class
				ifTrue: [ (val1 class allSelectorsBelow: Object)
						detect: [ :selector | selector = #= ]
						ifFound: [ | selector |
							selector := val1 = val2
								ifTrue: [ #assert:equals: ]
								ifFalse: [ #deny:equals: ].
							assertions
								add:
									(self new
										selector: selector;
										args:
											(Array
												with: (SVariable name: varName1)
												with: (SVariable name: varName2));
										yourself) ] ] ].
	^ assertions
]
