Class {
	#name : #SAssertionMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SAssertionMessage class >> for: aExecutionContext [
	^ self subclassResponsibility.
]

{ #category : #override }
SAssertionMessage >> changeSelectorFrom: aExpression in: aTestCase [
	"not sure what it should return"
]

{ #category : #initialization }
SAssertionMessage >> initialize [
	super initialize.
	receiver := SSelf new.
	 
]
