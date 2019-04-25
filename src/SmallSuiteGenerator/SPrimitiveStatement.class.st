Class {
	#name : #SPrimitiveStatement,
	#superclass : #SStatement,
	#instVars : [
		'value'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> collectDependencies [
	^ #()
]

{ #category : #private }
SPrimitiveStatement >> createNewStatement [
	^ (self class create)
		value: self value;
		returnTypeName: self returnTypeName;
		yourself
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> insertMethodCallUsing: aTestcase [
	^ nil
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> insertParameterUsing: aTestcase [
	^ nil
]

{ #category : #accessing }
SPrimitiveStatement >> insertRandomCallUsing: aTestCase [
	^ nil
]

{ #category : #accessing }
SPrimitiveStatement >> isPrimitive [ 
	^ true
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> notReferenced: referencedVarNames orIrrelevant: dictStringStatement [
	^ (referencedVarNames includes: self varName) not
]

{ #category : #printing }
SPrimitiveStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self stringBody
]

{ #category : #mutation }
SPrimitiveStatement >> repairOn: aTestCase changing: aStatement [
	| result |
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
	result := aTestCase createScalar: aStatement returnTypeName.
	(aTestCase statementAt: self varName)
		value: (STransformValue changeAndTransform: result first).

	^ #()
]

{ #category : #mutation }
SPrimitiveStatement >> repairOn: aTestCase deleting: aStatement [
	^ #()
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> satisfyParameters: aTestCase with: otherTestCase [
	^ aTestCase
		addStatement: self createNewStatement
]

{ #category : #printing }
SPrimitiveStatement >> stringBody [
	^ ([(STON fromString: value) storeString] on: STONReaderError do: [value storeString]) , $. asString
]

{ #category : #evaluating }
SPrimitiveStatement >> value [ 	
	^ value
]

{ #category : #accessing }
SPrimitiveStatement >> value: anObject [
	value := anObject.
]
