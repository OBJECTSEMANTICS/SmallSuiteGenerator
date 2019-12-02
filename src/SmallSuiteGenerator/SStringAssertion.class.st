"
A SStringAssertion select execution context's values that their class implement some method of printing like: 'printOn:', 'asString'. 

From the resulting collection each item is used to create an instance of the class using #printString as selector.

	For example: 
	
	List with classes' items which have implemented printing methods: 
		Array with: '_var1' -> 'hello'
		with: '_var2' -> 2.3
		with: '_var3' -> (3@5).
	It returns items like: 
		self assert: _var1 printString equals: ''hello''.
		self assert: _var2 printString equals: '2.3'.
		self assert: _var3 printString equals: (2@3).
"
Class {
	#name : #SStringAssertion,
	#superclass : #SAssertionMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SStringAssertion class >> for: anExecutionContext [
	^ (anExecutionContext associations
		reject: [ :assoc | self isPrimitive: assoc value ])
		collect: [ :assoc | self stringAssertionsOf: assoc ]
		thenSelect: [ :stringAssertion |  stringAssertion isNotNil ]
]

{ #category : #'instance creation' }
SStringAssertion class >> stringAssertionsOf: assoc [
	| aValue |
	aValue := assoc value.
	^ (aValue class allSelectorsBelow: Object)
		detect: [ :aSelector | aSelector = #printOn: or: [ aSelector = #asString ] ]
		ifFound: [ | fieldValue |
			[ fieldValue := aValue perform: #printString.
			self new
				selector: #assert:equals:;
				args:
					(Array
						with:
							(SMessage new
								receiver: (SVariable name: assoc key);
								selector: #printString;
								yourself)
						with: (SLiteral new value: fieldValue));
				yourself ]
				on: Error
				do: [ Transcript
						show: aValue class name , ' cant answer printString without error' ] ]
		ifNone: [ nil ]
]
