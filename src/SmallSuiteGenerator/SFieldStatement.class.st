Class {
	#name : #SFieldStatement,
	#superclass : #SStatement,
	#instVars : [
		'receiverVarName',
		'fieldName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SFieldStatement >> changeUsing: aTestCase [
	| accessors |
	accessors := (aTestCase
		methodsOrAccessors: (aTestCase statementAt: self receiverVarName)
		toSelect: true)
		select: [ :m | m returnType name = self returnTypeName ].
	accessors shuffle
		detect: [ :accessor | accessor selector ~= self fieldName ]
		ifFound: [ :accessor | 
			(aTestCase statementAt: self varName) fieldName: accessor selector ]
]

{ #category : #'as yet unclassified' }
SFieldStatement >> collectDependencies [
	^ { receiverVarName }
]

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
	^ nil
]

{ #category : #'as yet unclassified' }
SFieldStatement >> insertParameterUsing: aTestcase [
	^ nil
]

{ #category : #accessing }
SFieldStatement >> insertRandomCallUsing: aTestCase [
	| aPosition newStatement |
	aPosition := STransformValue
		randomNumberFrom: (aTestCase indexOf: self receiverVarName) + 1
		to: aTestCase statements size
		default: aTestCase statements size + 1.
	newStatement := self createNewStatement.
	(aTestCase addStatement: newStatement at: aPosition)
		ifTrue: [ ^ {newStatement varName} ].
	^ nil
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
	"aTestCase changeField: aStatement."
	self changeUsing: aTestCase.
	^ #()
]

{ #category : #mutation }
SFieldStatement >> repairOn: aTestCase deleting: aStatement [
	| varNamesToDelete constructStatement |
	varNamesToDelete := #().
	aStatement varName = self receiverVarName
		ifFalse: [ ^ varNamesToDelete ].
	constructStatement := aTestCase
		addConstructor: aStatement
		before: self varName
		forField: true.
	constructStatement
		ifNil: [ varNamesToDelete := {self varName} ]
		ifNotNil: [ (aTestCase statementAt: self varName) receiverVarName: constructStatement varName ].
	^ varNamesToDelete
]

{ #category : #'as yet unclassified' }
SFieldStatement >> satisfyParameters: aTestCase with: otherTestCase [
	| blockCondition |
	blockCondition := [ :testCase :stmOfCollection :aStatement | 
	((testCase methodsOrAccessors: stmOfCollection toSelect: true)
		collect: #selector) includes: aStatement fieldName ].
	^ STransformValue
		satisfyParameters: aTestCase
		with: otherTestCase
		of: self
		withCondition: blockCondition
]
