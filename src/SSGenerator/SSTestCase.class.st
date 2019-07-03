Class {
	#name : #SSTestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'typeInfo',
		'nextId'
	],
	#category : #SSGenerator
}

{ #category : #'as yet unclassified' }
SSTestCase class >> with: aTypeInfo [
	|testCase|
	testCase := self new.
	testCase typeInfo: aTypeInfo.
	^ testCase.
]

{ #category : #actions }
SSTestCase >> addAssignment: anExpression [
	self
		addStatement:
			(SAssignment
				name:
					(SVariable new
						nameVar: '_var';
						id: self assignId;
						returnType: anExpression returnType;
						yourself)
				value: anExpression)
]

{ #category : #actions }
SSTestCase >> addFactoryMessage [
	self addFactoryMessage: typeInfo randomNoneAbstractClass
]

{ #category : #actions }
SSTestCase >> addFactoryMessage: aClass [
	| methods factory |
	methods := typeInfo factoryMethods: aClass.
	factory := methods
		ifEmpty: [ SFactoryMessage default: aClass ]
		ifNotEmpty: [ 
			SFactoryMessage
				method: methods shuffle anyOne
				previousStatements: statements ].
	self addAssignment: factory
]

{ #category : #actions }
SSTestCase >> addFieldAccessMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickAnAccessorOf: receiver.
	methods
		ifNotEmpty: [ self addAssignment: (SFieldAccessMessage
				receiver: receiver
				selector: methods shuffle anyOne) ]
]

{ #category : #adding }
SSTestCase >> addLiteral [
	typeInfo scalars ifEmpty: [ self error: 'scalars are not defined' ].
	self addLiteral: typeInfo scalars keys shuffle anyOne.
	
]

{ #category : #adding }
SSTestCase >> addLiteral: aClassName [
	|aObject|
aObject := (typeInfo scalars at: aClassName) asArray shuffle anyOne.
	aObject isLiteral
		ifTrue: [ self
				addAssignment:
					(SLiteral new
						returnType: aClassName;
						value: aObject) ]
]

{ #category : #actions }
SSTestCase >> addMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickMessagesOf: receiver.
	methods
		ifNotEmpty: [ self addAssignment: (SMessage
				receiver: receiver
				selector: methods shuffle anyOne
				previousStatements: statements) ]
]

{ #category : #actions }
SSTestCase >> addStatement: anExpression [
	statements add: anExpression.
]

{ #category : #'as yet unclassified' }
SSTestCase >> assignId [
	| idToAssign assignedIds |
	assignedIds := self assignedIds.
	[ assignedIds includes: nextId ] whileTrue: [ nextId := nextId + 1 ].
	idToAssign := nextId.
	nextId := nextId + 1.
	^ idToAssign
]

{ #category : #accessing }
SSTestCase >> assignedIds [
	^ statements collect: #id
]

{ #category : #'as yet unclassified' }
SSTestCase >> factoryMessageVariables [
	^ statements
		select: [ :stm | stm value isFactoryMessage ]
		thenCollect: [ :stm | stm variable ]
]

{ #category : #initialization }
SSTestCase >> initialize [
	statements := OrderedCollection new.
	nextId := 0
]

{ #category : #'as yet unclassified' }
SSTestCase >> pickAnAccessorOf: aVariable [
	^ (typeInfo types at: aVariable returnType) accessMessages
]

{ #category : #'as yet unclassified' }
SSTestCase >> pickAnObjectVariable [
	^ self factoryMessageVariables shuffle anyOne
]

{ #category : #'as yet unclassified' }
SSTestCase >> pickMessagesOf: aVariable [
	^ (typeInfo types at: aVariable returnType) messages
]

{ #category : #accessing }
SSTestCase >> statements [
	^ statements
]

{ #category : #accessing }
SSTestCase >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SSTestCase >> typeInfo: anObject [
	typeInfo := anObject
]
