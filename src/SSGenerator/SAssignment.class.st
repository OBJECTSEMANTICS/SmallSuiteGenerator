Class {
	#name : #SAssignment,
	#superclass : #SExpression,
	#instVars : [
		'variable',
		'value'
	],
	#category : #'SSGenerator-Nodes'
}

{ #category : #'instance creation' }
SAssignment class >> name: aVariable value: anExpression [
	^ self new
		variable: aVariable;
		value: anExpression;
		returnType: anExpression returnType;
		yourself.
]

{ #category : #comparing }
SAssignment >> = other [
	^ super = other and: [ variable = other variable and: [ value = other value ] ]
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

{ #category : #'as yet unclassified' }
SAssignment >> references: aExpression [
	^ (variable references: aExpression)
		, (value references: aExpression)
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
