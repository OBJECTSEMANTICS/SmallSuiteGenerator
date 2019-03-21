Class {
	#name : #SFieldStatement,
	#superclass : #SStatement,
	#instVars : [
		'receiverVarName',
		'fieldName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #private }
SFieldStatement >> createNewStatement [
	^ self class create
		fieldName: self fieldName;
		receiverVarName: self receiverVarName;
		returnTypeName: self returnTypeName;
		yourself
]

{ #category : #accessing }
SFieldStatement >> fieldName [
	^ fieldName
]

{ #category : #accessing }
SFieldStatement >> fieldName: anObject [
	fieldName := anObject
]

{ #category : #'as yet unclassified' }
SFieldStatement >> insertMethodCallUsing: aTestcase [
	^ -1
]

{ #category : #'as yet unclassified' }
SFieldStatement >> insertParameterUsing: aTestcase [
	^ -1
]

{ #category : #accessing }
SFieldStatement >> insertRandomCallAt: position using: aTestCase [
	| aPosition interval |
	interval := ((aTestCase indexOf: self receiverVarName) + 1 to: aTestCase statements size).
	aPosition := interval ifEmpty: [ aTestCase statements size + 1 ] ifNotEmpty: [ interval atRandom ].
	(aTestCase
		addStatement:
			(SFieldStatement create
				returnTypeName: self returnTypeName;
				receiverVarName: self receiverVarName;
				fieldName: self fieldName;
				yourself)
		at: aPosition)
		ifTrue: [ ^ aPosition ].
	^ -1
]

{ #category : #accessing }
SFieldStatement >> isField [
	^ true
]

{ #category : #printing }
SFieldStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self receiverVarName asString.
	aStream nextPutAll: ' '.
	aStream nextPutAll: self fieldName.
	aStream nextPut: $.
]

{ #category : #accessing }
SFieldStatement >> receiverVarName [
	^ receiverVarName
]

{ #category : #accessing }
SFieldStatement >> receiverVarName: anObject [
	receiverVarName := anObject
]

{ #category : #mutation }
SFieldStatement >> repairOn: aTestCase changing: aStatement [
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
	aTestCase changeField: aStatement.
	^ #()
]

{ #category : #mutation }
SFieldStatement >> repairOn: aTestCase deleting: aStatement [
	| varNamesToDelete |
	varNamesToDelete := #().
	aStatement varName = self receiverVarName
		ifFalse: [ ^ varNamesToDelete ].
	(aTestCase addConstructorField: aStatement before: self varName)
		ifFalse: [ varNamesToDelete := {self varName} ].
	^ varNamesToDelete
]
