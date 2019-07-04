Class {
	#name : #SSTestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'typeInfo',
		'nextId',
		'numberStatements'
	],
	#category : #'SSGenerator-Core'
}

{ #category : #'as yet unclassified' }
SSTestCase class >> with: aTypeInfo [
	|testCase|
	testCase := self new.
	testCase typeInfo: aTypeInfo.
	^ testCase.
]

{ #category : #'as yet unclassified' }
SSTestCase class >> withNumStatements: aNumber [
	aNumber >0 ifFalse: [ ^ self error: 'The number of statements must be greater than 0' ].
	^ self new numberStatements: aNumber
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
	| receiver selectors |
	receiver := self pickAnObjectVariable.
	selectors := self pickAccessorsOf: receiver.
	selectors
		ifNotEmpty: [ self
				addFieldAccessMessage: selectors shuffle anyOne
				withReceiver: receiver ]
]

{ #category : #actions }
SSTestCase >> addFieldAccessMessage: aSelector [
	| receiver |
	receiver := self pickObjectVariableOf: aSelector ofAccess: true.
	receiver
		ifNotNil: [ self addFieldAccessMessage: aSelector withReceiver: receiver ]
]

{ #category : #actions }
SSTestCase >> addFieldAccessMessage: method withReceiver: receiver [
	self
		addAssignment: (SFieldAccessMessage receiver: receiver selector: method)
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
	aObject ifNotNil:[ self
				addAssignment:
					(SLiteral new
						returnType: aClassName;
						value: aObject) ]
]

{ #category : #actions }
SSTestCase >> addMessage [
	| receiver selectors |
	receiver := self pickAnObjectVariable.
	selectors := self pickMessagesOf: receiver.
	selectors ifNotEmpty: [ 
	self addMessage: selectors shuffle anyOne withReceiver: receiver]
]

{ #category : #actions }
SSTestCase >> addMessage: aSelector [
	| receiver |
	receiver := self pickObjectVariableOf: aSelector ofAccess: false.
	receiver
		ifNotNil: [ self addMessage: aSelector withReceiver: receiver ]
]

{ #category : #actions }
SSTestCase >> addMessage: method withReceiver: receiver [
self
				addAssignment:
					(SMessage
						receiver: receiver
						selector: method
						previousStatements: statements)
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

{ #category : #'as yet unclassified' }
SSTestCase >> generateStatements [
	[ self statements size < numberStatements ]
		whileTrue: [ self
				perform: #(#addFactoryMessage #addFieldAccessMessage #addMessage #addLiteral) shuffle anyOne ]
]

{ #category : #initialization }
SSTestCase >> initialize [
	statements := OrderedCollection new.
	nextId := 0
]

{ #category : #accessing }
SSTestCase >> numberStatements [
	^ numberStatements
]

{ #category : #accessing }
SSTestCase >> numberStatements: anObject [
	numberStatements := anObject
]

{ #category : #'as yet unclassified' }
SSTestCase >> pickAccessorsOf: aVariable [
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

{ #category : #'as yet unclassified' }
SSTestCase >> pickObjectVariableOf: aSelector ofAccess: aBoolean [
	^ self factoryMessageVariables
		detect: [ :factMessage | 
			(typeInfo classAt: factMessage selector)
				includesSelector: aSelector
				ofAccess: aBoolean ]
		ifFound: [ :factMessage | factMessage variable ]
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
