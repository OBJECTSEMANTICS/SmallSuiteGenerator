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
		ifNotEmpty: [ | method |
			method := methods shuffle anyOne.
			self satisfyArgs: method.
			SFactoryMessage method: method previousStatements: statements ].
	self addAssignment: factory
]

{ #category : #actions }
SSTestCase >> addFieldAccessMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickAccessorsOf: receiver.
	methods
		ifNotEmpty: [ self
				addFieldAccessMessage: methods shuffle anyOne
				withReceiver: receiver ]
]

{ #category : #actions }
SSTestCase >> addFieldAccessMessage: aSelector from: aClassName [
	| receiver |
	((typeInfo classAt: aClassName) methodOf: aSelector) isQuick
		ifFalse: [ self error: 'the method must be an accessor message' ].
	receiver := self
		pickObjectVariableOf:aClassName.
	receiver
		ifNotNil: [ self addFieldAccessMessage: aSelector withReceiver: receiver ]
]

{ #category : #actions }
SSTestCase >> addFieldAccessMessage: method withReceiver: receiver [
	self
		addAssignment: (SFieldAccessMessage newFromReceiver: receiver andMethod: method)
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
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickMessagesOf: receiver.
	methods ifNotEmpty: [ 
	self addMessage: methods shuffle anyOne withReceiver: receiver]
]

{ #category : #actions }
SSTestCase >> addMessage: aSelector from: aClassName [
	| receiver aMethod |
	((typeInfo classAt: aClassName) methodOf: aSelector) isQuick
		ifTrue: [ ^ self error: 'the method must be a message, not accessor message' ].
	aMethod := (typeInfo classAt: aClassName) methodOf: aSelector.
	receiver := self pickObjectVariableOf: aClassName.
	receiver
		ifNotNil: [ self addMessage: aMethod withReceiver: receiver ]
]

{ #category : #actions }
SSTestCase >> addMessage: method withReceiver: receiver [
	self satisfyArgs: method.
	self
		addAssignment:
			(SMessage
				newFromReceiver: receiver
				method: method
				andPreviousStatements: statements)
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

{ #category : #copying }
SSTestCase >> copy [
	| copy |
	copy := super copy.
	copy typeInfo: typeInfo copy.
	copy statements: statements copy.
	copy updateNextId.
	^ copy
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
				perform:
					#(#addFactoryMessage #addFieldAccessMessage #addMessage #addLiteral)
						shuffle anyOne ].
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
	self factoryMessageVariables ifEmpty: [ self addFactoryMessage ].
	^ self factoryMessageVariables shuffle anyOne
]

{ #category : #'as yet unclassified' }
SSTestCase >> pickMessagesOf: aVariable [
	^ (typeInfo types at: aVariable returnType) messages
]

{ #category : #'as yet unclassified' }
SSTestCase >> pickObjectVariableOf: aClassName [
	^ self factoryMessageVariables
		detect: [ :var | var returnType = aClassName ]
		ifFound: [ :var | var ] ifNone: [ self error: 'Dont exist a constructor of class', aClassName]
]

{ #category : #'as yet unclassified' }
SSTestCase >> satisfyArgs: aMethodTypeInfo [
	| types typesToAdd |
	types := statements collect: #returnType.
	typesToAdd := (aMethodTypeInfo argTypes reject: [ :aType | 
		types includes: aType
		 ]) asSet.
	typesToAdd do: [ :type | self addLiteral: type ]
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

{ #category : #'as yet unclassified' }
SSTestCase >> updateNextId [ 
	nextId = 0 ifTrue: [ nextId := statements size ]
]
