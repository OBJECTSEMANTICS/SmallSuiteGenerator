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
SFieldStatement >> createNewStatement: aId [
	^ (self class create: aId)
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
	newStatement := self createNewStatement: aTestCase assignedId.
	(aTestCase addStatement: newStatement at: aPosition)
		ifTrue: [ ^ {newStatement varName} ].
	^ nil
]

{ #category : #accessing }
SFieldStatement >> isField [
	^ true
]

{ #category : #'as yet unclassified' }
SFieldStatement >> notReferenced: referencedVarNames orIrrelevant: dictStringStatement [
| varName |
	varName := self varName.
	^ (referencedVarNames includes: varName) not
		and: [ (dictStringStatement at: self stringBody) first ~= varName ]
]

{ #category : #printing }
SFieldStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self stringBody
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
	| blockCondition blockInsertion |
	blockCondition := [ :testCase :stmOfCollection :aStatement | 
	((testCase methodsOrAccessors: stmOfCollection toSelect: true)
		collect: #selector) includes: aStatement fieldName ].
	blockInsertion := [ :testCase :aStatement :constructor | 
	^ testCase
		addStatement:
			((aStatement createNewStatement: aTestCase assignedId)
				receiverVarName: constructor varName;
				yourself) ].
	^ STransformValue
		satisfyParameters: aTestCase
		with: otherTestCase
		of: self
		withBlocks:
			{blockCondition.
			blockInsertion}
]

{ #category : #printing }
SFieldStatement >> stringBody [
	^ String streamContents: [ :aStream | 
		aStream nextPutAll: self receiverVarName asString;
		nextPutAll: ' ';
		nextPutAll: self fieldName;
		nextPut: $.]
]
