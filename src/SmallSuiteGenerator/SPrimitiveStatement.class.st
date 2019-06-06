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
	^ (self class create)
		value: self value;
		returnTypeName: self returnTypeName;
		yourself
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> dependenciesConsidering: varNames [
	^ #()
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

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> referencesToArgs: varNames [
]

{ #category : #mutation }
SPrimitiveStatement >> repairOn: aTestCase changing: aStatement [
	| result |
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
	result := aTestCase createScalar: aStatement returnTypeName.
	(aTestCase statementAt: self varName)
		value: result first mutateToChange.
	^ #()
]

{ #category : #mutation }
SPrimitiveStatement >> repairOn: aTestCase deleting: aStatement [
	^ #()
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> replace: varName varNameBy: valueToReplace [
	
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> satisfyParameters: aTestCase with: otherTestCase [
	^ aTestCase
		addStatement: self createNewStatement
]

{ #category : #printing }
SPrimitiveStatement >> stringBody [
	^ 
	value storeString, $. asString
	"(value isLiteral
		ifTrue: [ value storeString ]
		ifFalse: [ 
			(SAuxiliar isVeryDeep: value)
				ifTrue: [ '' ]
				ifFalse: [ value storeString ] ]) , $. asString"	"value storeString"
]

{ #category : #evaluating }
SPrimitiveStatement >> value [ 	
	^ value
]

{ #category : #accessing }
SPrimitiveStatement >> value: anObject [
	value := anObject.
]

{ #category : #'as yet unclassified' }
SPrimitiveStatement >> valueInline [
	^ value
]
