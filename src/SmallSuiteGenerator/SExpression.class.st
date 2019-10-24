Class {
	#name : #SExpression,
	#superclass : #Object,
	#instVars : [
		'returnType',
		'id'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #'error handling' }
SExpression class >> error: string [
	
	^ SError signal: string 
]

{ #category : #'instance creation' }
SExpression class >> isPrimitive: anObject [
	^ self new isPrimitive: anObject.
]

{ #category : #comparing }
SExpression >> = other [
	^ (self class = other class) and: [ (self id = other id) and: [ returnType = other returnType ] ]
	
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

{ #category : #mutation }
SExpression >> insertAsParameter: aExpression using: aTestCase [
	
	^ aTestCase insertAsParameter: self copy after: aExpression
]

{ #category : #mutation }
SExpression >> insertMethodMessage: aExpression using: aTestCase [
	self error: 'cant insert methodMessage'
]

{ #category : #mutation }
SExpression >> insertOn: aTestCase [
	
]

{ #category : #mutation }
SExpression >> insertRandomMessage: aExpression using: aTestCase [
	self error: 'cant insert randomMessage'
]

{ #category : #testing }
SExpression >> isFactoryMessage [
	^ false
]

{ #category : #comparing }
SExpression >> isPrimitive: anObject [
	^ ((anObject isKindOf: Magnitude) or: [ anObject isKindOf: Boolean ]) or: [ anObject isKindOf: String ]
]

{ #category : #mutation }
SExpression >> pickUpReferences: aExpression [
	^ #()
]

{ #category : #accessing }
SExpression >> reference [
	^ self
]

{ #category : #accessing }
SExpression >> referenceTo: aClassName [
	^ false
]

{ #category : #mutation }
SExpression >> repairOn: aTestCase changing: aExpression [
	
]

{ #category : #mutation }
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

{ #category : #mutation }
SExpression >> variablesWithId [
	^ #()
]
