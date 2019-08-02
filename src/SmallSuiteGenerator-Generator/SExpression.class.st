Class {
	#name : #SExpression,
	#superclass : #Object,
	#instVars : [
		'returnType',
		'id'
	],
	#category : #'SmallSuiteGenerator-Generator-Nodes'
}

{ #category : #comparing }
SExpression >> = other [
	self class = other class
		ifFalse: [ ^ false ].
	^ self id = other id and: [ returnType = other returnType ]
]

{ #category : #copying }
SExpression >> copy [
	^ self class new
		id: self id;
		returnType: self returnType
]

{ #category : #'error handling' }
SExpression >> error: aString [
	^ SError signal: aString
]

{ #category : #comparing }
SExpression >> hash [
	^ self id hash bitXor: self returnType hash
]

{ #category : #accessing }
SExpression >> id [
	^ id
]

{ #category : #accessing }
SExpression >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
SExpression >> insertAsParameter: aExpression using: aTestCase [
	
	^ aTestCase insertAsParameter: self copy after: aExpression
]

{ #category : #'as yet unclassified' }
SExpression >> insertMethodMessage: aExpression using: aTestCase [
	self error: 'cant insert methodMessage'
]

{ #category : #'as yet unclassified' }
SExpression >> insertOn: aTestCase [
	
]

{ #category : #'as yet unclassified' }
SExpression >> insertRandomMessage: aExpression using: aTestCase [
	self error: 'cant insert randomMessage'
]

{ #category : #testing }
SExpression >> isFactoryMessage [
	^ false
]

{ #category : #'as yet unclassified' }
SExpression >> pickUpReferences: aExpression [
	^ #()
]

{ #category : #accessing }
SExpression >> reference [
	^ self
]

{ #category : #mutation }
SExpression >> repairOn: aTestCase changing: aExpression [
	
]

{ #category : #'as yet unclassified' }
SExpression >> replaceArgBy: aExpression [
	self error: 'cant insert as parameter'
]

{ #category : #accessing }
SExpression >> replaceBy: otherExpression [
	self subclassResponsibility 
]

{ #category : #actions }
SExpression >> replaceExpression: expression by: newExpression [
	
]

{ #category : #accessing }
SExpression >> returnType [
	^ returnType
]

{ #category : #accessing }
SExpression >> returnType: anObject [
	returnType := anObject
]

{ #category : #'as yet unclassified' }
SExpression >> variablesWithId [
	^ #()
]
