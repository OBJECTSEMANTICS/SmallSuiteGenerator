Class {
	#name : #SAssignment,
	#superclass : #SExpression,
	#instVars : [
		'variable',
		'value'
	],
	#category : #'SmallSuiteGenerator-Nodes'
}

{ #category : #'instance creation' }
SAssignment class >> name: aVariable value: anExpression [
	^ self new
		variable: aVariable;
		value: anExpression;
		returnType: anExpression returnType;
		yourself
]

{ #category : #comparing }
SAssignment >> = other [
	^ (super = other) and: [ (variable = other variable) and: [ value = other value ] ]
]

{ #category : #copying }
SAssignment >> copy [ 
	|copy|
	copy := super copy.
	copy variable: variable copy;
	value: value copy.
	^ copy
]

{ #category : #comparing }
SAssignment >> hash [
	^ super hash xor: (variable hash xor: (value hash))
]

{ #category : #accessing }
SAssignment >> id [ 		
	^ variable id
]

{ #category : #'as yet unclassified' }
SAssignment >> insertAsParameter: aExpression using: aTestCase [
	^ variable insertAsParameter: aExpression using: aTestCase
]

{ #category : #'as yet unclassified' }
SAssignment >> insertMethodMessage: aExpression using: aTestCase [
	^ value insertMethodMessage: aExpression using: aTestCase
]

{ #category : #'as yet unclassified' }
SAssignment >> insertOn: aTestCase [
	^ value insertOn: aTestCase
]

{ #category : #'as yet unclassified' }
SAssignment >> insertRandomMessage: aExpression using: aTestCase [
	^ value insertRandomMessage:aExpression using: aTestCase
]

{ #category : #'as yet unclassified' }
SAssignment >> pickUpReferences: aExpression [
	^ value pickUpReferences: aExpression
]

{ #category : #printing }
SAssignment >> printOn: aStream [
	variable printOn: aStream.
	aStream nextPutAll: ' := '.
	value printOn: aStream
]

{ #category : #accessing }
SAssignment >> reference [ 
	^ variable
]

{ #category : #mutation }
SAssignment >> repairOn: aTestCase changing: aExpression [
	self reference = aExpression reference
		ifTrue:
			[ value repairOn: aTestCase changing: aExpression ]
]

{ #category : #'as yet unclassified' }
SAssignment >> replaceArgBy: aExpression [
	value replaceArgBy: aExpression
]

{ #category : #accessing }
SAssignment >> replaceBy: aExpression [
	self reference = aExpression reference ifTrue: [ value replaceBy: aExpression value ]
]

{ #category : #actions }
SAssignment >> replaceExpression: expression by: newExpression [
	value replaceExpression: expression by: newExpression
]

{ #category : #evaluating }
SAssignment >> value [ 
	^ value
]

{ #category : #accessing }
SAssignment >> value: anObject [
	value := anObject
]

{ #category : #accessing }
SAssignment >> variable [
	^ variable
]

{ #category : #accessing }
SAssignment >> variable: anObject [
	variable := anObject
]

{ #category : #'as yet unclassified' }
SAssignment >> variablesWithId [
	^ variable variablesWithId, value variablesWithId
]
