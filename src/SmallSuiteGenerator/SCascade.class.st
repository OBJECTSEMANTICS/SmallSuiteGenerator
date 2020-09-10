"
SCascade is a node equivalent to RBCascadeNode
"
Class {
	#name : #SCascade,
	#superclass : #SExpression,
	#instVars : [
		'messages'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #visitor }
SCascade >> accept: aSSVisitor [

	^ aSSVisitor visitCascade: self.
]

{ #category : #initialization }
SCascade >> addMessage: aMessage [ 

	messages add: aMessage
]

{ #category : #initialization }
SCascade >> initialize [

	super initialize.
	messages := OrderedCollection new
]

{ #category : #accessing }
SCascade >> messages [

	^ messages
]

{ #category : #accessing }
SCascade >> messages: anObject [

	messages := anObject
]
