Class {
	#name : #SVisitor,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #visiting }
SVisitor >> visitAssertion: anAssertion [
	self visitMessage: anAssertion
]

{ #category : #visiting }
SVisitor >> visitAssignment: anAssignment [
	anAssignment variable accept: self.
	anAssignment value accept: self.
]

{ #category : #visiting }
SVisitor >> visitComparisonAssertion: anAssertion [
	self visitMessage: anAssertion
]

{ #category : #visiting }
SVisitor >> visitFactoryMessage: aMessage [
	self visitMessage: aMessage.
]

{ #category : #visiting }
SVisitor >> visitFieldAccessMessage: aMessage [
	self visitMessage: aMessage
]

{ #category : #visiting }
SVisitor >> visitInspectorAssertion: anAssertion [
	self visitMessage: anAssertion
]

{ #category : #visiting }
SVisitor >> visitLiteral: aLiteral [
	
]

{ #category : #visiting }
SVisitor >> visitMessage: aMessage [
	aMessage receiver accept: self.
	aMessage args do:[ :arg| arg accept: self].
	
]

{ #category : #visiting }
SVisitor >> visitPrimitiveAssertion: anAssertion [
	self visitMessage: anAssertion
]

{ #category : #visiting }
SVisitor >> visitSelf: aSelf [
]

{ #category : #visiting }
SVisitor >> visitStringAssertion: anAssertion [
	
]

{ #category : #visiting }
SVisitor >> visitVariable: aSelf [
	
]
