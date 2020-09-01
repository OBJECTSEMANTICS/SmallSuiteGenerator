Class {
	#name : #SSVisitor,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #util }
SSVisitor >> visitAbstractMessage: aMessage [
	"this only propagate the visit"
	aMessage receiver accept: self.
	aMessage args do:[ :arg| arg accept: self ].
]

{ #category : #'visiting-assertions' }
SSVisitor >> visitAssertionMessage: aMessage [
	^ self visitAbstractMessage: aMessage.
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitAssignment: anAssignmnet [
	anAssignmnet variable accept: self.
	anAssignmnet value accept: self.
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitCascade: aCascade [
	aCascade messages do: [ :msj | msj accept: self ]
]

{ #category : #'visiting-assertions' }
SSVisitor >> visitComparisonAssertionMessage: aMessage [
	^ self visitAssertionMessage: aMessage.
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitFactoryMessage: aMessage [
	^ self visitAbstractMessage: aMessage.
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitFieldAccessMessage: aMessage [
	^ self visitAbstractMessage: aMessage.
	
]

{ #category : #'visiting-assertions' }
SSVisitor >> visitInspectorAssertionMessage: aMessage [
	^ self visitAssertionMessage: aMessage.
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitLiteral: aLiteral [
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitMessage: aMessage [
	^  self visitAbstractMessage: aMessage.
	
]

{ #category : #'visiting-assertions' }
SSVisitor >> visitPrimitiveAssertionMessage: aMessage [
	^  self visitAssertionMessage: aMessage.
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitSelf: aSelf [
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitStatements: expresions [
	expresions do:[ :exp | exp accept: self.].
]

{ #category : #'visiting-assertions' }
SSVisitor >> visitStringAssertionMessage: aMessage [
	^ self visitAssertionMessage: aMessage.
	
]

{ #category : #'visiting-core' }
SSVisitor >> visitVariable: aVariable [
	
]
