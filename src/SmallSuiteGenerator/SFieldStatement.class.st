Class {
	#name : #SFieldStatement,
	#superclass : #SStatement,
	#instVars : [
		'receiverVarName',
		'fieldName'
	],
	#classInstVars : [
		'blockCondition',
		'blockInsertion'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SFieldStatement class >> blockCondition [
	blockCondition ifNil: [ blockCondition := [ :testCase :stmOfCollection :aStatement | 
	((testCase methodsOrAccessors: stmOfCollection toSelect: true)
		collect: #selector) includes: aStatement fieldName ] ].
	^ blockCondition
]

{ #category : #accessing }
SFieldStatement class >> blockInsertion [
	blockInsertion
		ifNil: [ blockInsertion := [ :testCase :aStatement :constructor | 
			testCase
				addStatement:
					(aStatement createNewStatement
						receiverVarName: constructor varName;
						yourself) ] ].
	^ blockInsertion
]

{ #category : #'as yet unclassified' }
SFieldStatement >> changeUsing: aTestCase [
	| accessors |
	accessors := (aTestCase
		methodsOrAccessors: (aTestCase statementAt: self receiverVarName)
		toSelect: true)
		select: [ :m | m returnType name = self returnTypeName ].
	accessors shuffle
		detect: [ :accessor | accessor selector ~= self fieldName ]
		ifFound:
			[ :accessor | (aTestCase statementAt: self varName) fieldName: accessor selector ].
]

{ #category : #private }
SFieldStatement >> createNewStatement [
	^ super createNewStatement 
		fieldName: self fieldName;
		receiverVarName: self receiverVarName;
		returnTypeName: self returnTypeName;
		yourself
]

{ #category : #'as yet unclassified' }
SFieldStatement >> dependenciesConsidering: varNames [
	^ varNames
		detect: [ :varName | SAuxiliar string: receiverVarName equalsOrIncludes: varName "varName = receiverVarName" ]
		ifFound: [ :varName | {varName} ]
		ifNone: [ {} ]
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
	| aPosition newStatement size |
	size := aTestCase numberOfStatements.
	aPosition := SAuxiliar
		randomNumberFrom: (aTestCase indexOf: self receiverVarName) + 1
		to: size
		default: size + 1.
	newStatement := self createNewStatement.
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

{ #category : #'as yet unclassified' }
SFieldStatement >> referencesToArgs: varNames [
]

{ #category : #mutation }
SFieldStatement >> repairOn: aTestCase changing: aStatement [
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
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
		ifNotNil: [ (aTestCase statementAt: self varName)
				receiverVarName: constructStatement varName ].
	^ varNamesToDelete
]

{ #category : #'as yet unclassified' }
SFieldStatement >> replace: varName varNameBy: object [
	receiverVarName := receiverVarName = varName
		ifTrue: [ SAuxiliar transformReplacement: object ]
		ifFalse: [ SAuxiliar
				replace: varName
				varNameIn: receiverVarName
				receiverBy: object
			"| index |
			index := 
			(receiverVarName indexOfSubCollection: varName) > 0
				ifTrue: [ receiverVarName replace: varName with: object ]" ]
]

{ #category : #'as yet unclassified' }
SFieldStatement >> satisfyParameters: aTestCase with: otherTestCase [
	^ SAuxiliar
		satisfyParameters: aTestCase
		with: otherTestCase
		of: self
		withBlocks:
			{self class blockCondition.
			self class blockInsertion}
]

{ #category : #printing }
SFieldStatement >> stringBody [
	^ String streamContents: [ :aStream | 
		aStream nextPutAll: self receiverVarName asString;
		nextPutAll: ' ';
		nextPutAll: self fieldName;
		nextPut: $.]
]
