Class {
	#name : #SAssertionMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'instance creation' }
SAssertionMessage class >> for: aExecutionContext [
	^ self subclassResponsibility.
]

{ #category : #'instance creation' }
SAssertionMessage class >> isPrimitive: anObject [
	^ ((anObject isKindOf: Magnitude) or: [ anObject isKindOf: Boolean ]) or: [ anObject isKindOf: String ]
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
