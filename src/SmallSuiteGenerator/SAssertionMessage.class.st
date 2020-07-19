"
Superclass of assertion messages nodes for 
	- comparison assertion (it compares an object with other)
	- inspector assertion (it compares the result of a method executed with a value)
	- primitive assertion (it compares the primitive values)
	- string assertion (it compares the way to represent an object as string with a string)
"
Class {
	#name : #SAssertionMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SAssertionMessage class >> for: aExecutionContext [
	^ self subclassResponsibility.
]

{ #category : #visitor }
SAssertionMessage >> accept: aSSVisitor [
	aSSVisitor visitAssertionMessage: self.
]

{ #category : #initialization }
SAssertionMessage >> initialize [
	super initialize.
	receiver := SSelf new.
	 
]
