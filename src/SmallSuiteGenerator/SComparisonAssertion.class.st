"
A SComparisonAssertion selects the execution context values that are comparable.

Collection's items of the same class are compared and for each one is created a new instance of this class with the selector depending the result of the comparison.

For example: 

	List with items that are comparable: 
		Array with: '_var1'-> 9
		with: '_var2' -> 5
		with: '_var3' -> 9
		with: '_var4' -> 'hello'.
	It returns items like: 
		self deny: _var1 equals: _var2.
		self assert: _var1 equals: _var3.
		


"
Class {
	#name : #SComparisonAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SComparisonAssertion class >> comparisonAssertion: anExecutionContext with: array [
			| varName1 varName2 val1 val2 |
			varName1 := array first.
			varName2 := array second.
			val1 := anExecutionContext at: varName1.
			val2 := anExecutionContext at: varName2.
			val1 class = val2 class
				ifTrue: [ (val1 class allSelectorsBelow: Object)
						detect: [ :selector | selector = #= ]
						ifFound: [ | selector |
							selector := val1 = val2
								ifTrue: [ #assert:equals: ]
								ifFalse: [ #deny:equals: ].
							^ self new
										selector: selector;
										args:
											(Array
												with: (SVariable nameOrId: varName1)
												with: (SVariable nameOrId: varName2));
										yourself ]
							 ].
						^ nil
]

{ #category : #'instance creation' }
SComparisonAssertion class >> for: anExecutionContext [
	| assertions |
	assertions := OrderedCollection new.
	anExecutionContext keys asOrderedCollection
		combinations: 2
		atATimeDo: [ :comb | 
			| compareAssert |
			compareAssert := self
				comparisonAssertion: anExecutionContext
				with: comb.
			compareAssert
				ifNotNil: [ assertions add: compareAssert
			 ] ].
	^ assertions
]

{ #category : #visitor }
SComparisonAssertion >> accept: aSSVisitor [
	aSSVisitor visitComparisonAssertionMessage: self.
]
