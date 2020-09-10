"
A SPrimitiveAssertion collects instances of the class if the execution context's values are primitives.

For example: 
	
	List with items classified as primitive: 
		Array with: '_var1' -> 'hello'
		with: '_var2' -> 2
		with: '_var3' -> (3@5).
	It returns items like: 
		self assert: _var1 equals: 'hello'.
		self assert: _var2 equals: 2.
"
Class {
	#name : #SPrimitiveAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SPrimitiveAssertion class >> for: anExecutionContext [

	^ anExecutionContext associations
		select: [ :assoc | self isPrimitive: assoc value ]
		thenCollect: [ :assoc | 
			self new
				selector: #assert:equals:;
				args:
					(Array
						with: (SVariable nameOrId: assoc key)
						with: (SLiteral new value: assoc value));
				yourself ]
]

{ #category : #visitor }
SPrimitiveAssertion >> accept: aSSVisitor [

	^ aSSVisitor visitPrimitiveAssertionMessage: self.
]
