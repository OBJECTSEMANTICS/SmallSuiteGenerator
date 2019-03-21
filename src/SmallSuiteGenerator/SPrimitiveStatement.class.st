Class {
	#name : #SPrimitiveStatement,
	#superclass : #SStatement,
	#instVars : [
		'value'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #private }
SPrimitiveStatement >> createNewStatement [
	^ self class create
		value: self value;
		returnTypeName: self returnTypeName;
		yourself
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> insertMethodCallUsing: aTestcase [
	^ -1
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> insertParameterUsing: aTestcase [
	^ -1
]

{ #category : #accessing }
SPrimitiveStatement >> insertRandomCallAt: position using: aTestCase [
	^ -1
]

{ #category : #accessing }
SPrimitiveStatement >> isPrimitive [ 
	^ true
]

{ #category : #printing }
SPrimitiveStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: value asString.
	aStream nextPut: $.
]

{ #category : #mutation }
SPrimitiveStatement >> repairOn: aTestCase changing: aStatement [
	| result |
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
	result := aTestCase createScalar: aStatement returnTypeName.
	(aTestCase statements at: (aTestCase indexOf: aStatement varName))
		value:
			(self
				change: (self transform: result first)).
	^ #()
]

{ #category : #mutation }
SPrimitiveStatement >> repairOn: aTestCase deleting: aStatement [
	^ #()
]

{ #category : #evaluating }
SPrimitiveStatement >> value [ 	
	^ value
]

{ #category : #accessing }
SPrimitiveStatement >> value: anObject [
	value := anObject.
]
