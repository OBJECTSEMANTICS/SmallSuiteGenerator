Class {
	#name : #SAssignment,
	#superclass : #SExpression,
	#instVars : [
		'variable',
		'value'
	],
	#category : #SSGenerator
}

{ #category : #'instance creation' }
SAssignment class >> name: aVariable value: anExpression [
	^ self new
		variable: aVariable;
		value: anExpression;
		returnType: anExpression returnType;
		yourself.
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
