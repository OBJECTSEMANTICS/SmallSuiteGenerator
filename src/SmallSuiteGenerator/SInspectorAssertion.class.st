"
A SInspectorAssertion selects methods categorized as returnField and creates an instance for each one if the execution result is primitive.

	For example: 
	
	List with classes' items categorized as returnField: 
		Array with: '_var2' -> (2@10).
	It returns items like: 
		self assert: _var2 x equals: 2.
		self assert: _var2 y equals: 10.
"
Class {
	#name : #SInspectorAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SInspectorAssertion class >> for: anExecutionContext [
	^ anExecutionContext associations
		flatCollect: [ :assoc | self inspectorAssertionOf: assoc ]
]

{ #category : #'instance creation' }
SInspectorAssertion class >> inspectorAssertionOf: assoc [
	^ (assoc value class methods select: #isReturnField)
		collect:
			[ :compiledMethod | 
			self inspectorAssertionOf: assoc and: compiledMethod ]
		thenSelect: [ :assertion | 
			assertion isNotNil
			 ]
]

{ #category : #'instance creation' }
SInspectorAssertion class >> inspectorAssertionOf: assoc and: compiledMethod [
	|result|
	result := assoc value perform: compiledMethod selector.
	^ (self isPrimitive: result)
		ifFalse: [ nil ]
		ifTrue: [ self new
				selector: #assert:equals:;
				args:
					(Array
						with:
							(SMessage new
								receiver: (SVariable name: assoc key);
								selector: compiledMethod selector;
								yourself)
						with: (SLiteral new value: result));
				yourself ]
]
