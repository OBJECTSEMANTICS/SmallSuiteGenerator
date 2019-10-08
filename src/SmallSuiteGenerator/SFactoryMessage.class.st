Class {
	#name : #SFactoryMessage,
	#superclass : #SAbstractMessage,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #accessing }
SFactoryMessage class >> default: aClassName [
	^ self new
		receiver:
			(SVariable new
				varName: aClassName;
				returnType: aClassName;
				yourself);
		selector: #new;
		returnType: aClassName;
		yourself
]

{ #category : #creation }
SFactoryMessage class >> method: aMethodTypeInfo previousStatements: statements [
	|returnType|
	returnType := aMethodTypeInfo returnType type.
	^ self new
		receiver:
			(SVariable new
				varName: returnType ;
				returnType: returnType ;
				yourself);
		returnType: returnType;
		selector: aMethodTypeInfo selector;
		args: (self args: aMethodTypeInfo with: statements);
		yourself
]

{ #category : #'as yet unclassified' }
SFactoryMessage >> changeSelectorFrom: aExpression in: aTestCase [
	| otherFactoryMessage |
	otherFactoryMessage := aTestCase
		alternativeFactoryMessage: self
		before: aExpression.
	self selector: otherFactoryMessage selector.
	self args: otherFactoryMessage args
]

{ #category : #'as yet unclassified' }
SFactoryMessage >> insertOn: aTestCase [
	^ aTestCase
		addFactoryMessage: self returnType
		ofSelector: self selector
]

{ #category : #testing }
SFactoryMessage >> isFactoryMessage [
	^ true
]

{ #category : #accessing }
SFactoryMessage >> referenceTo: aClassName [
	^ receiver referenceTo: aClassName
]
