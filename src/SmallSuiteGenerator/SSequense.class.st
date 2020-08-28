"
SSequence is a node equivalent to RBSequenceNode
"
Class {
	#name : #SSequense,
	#superclass : #SExpression,
	#instVars : [
		'temporaries',
		'messages'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #adding }
SSequense >> addMessage: aMessage [
	messages add: aMessage 
]

{ #category : #adding }
SSequense >> addTemporarie: tmp [ 
	temporaries add: tmp 
]

{ #category : #initialization }
SSequense >> initialize [
	super initialize.
	messages := OrderedCollection new.
	temporaries := OrderedCollection new.
]

{ #category : #accessing }
SSequense >> isSequence [ 
	^ true
]

{ #category : #accessing }
SSequense >> messages [
	^ messages
]

{ #category : #accessing }
SSequense >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
SSequense >> temporaries [
	^ temporaries
]

{ #category : #accessing }
SSequense >> temporaries: anObject [
	temporaries := anObject
]
