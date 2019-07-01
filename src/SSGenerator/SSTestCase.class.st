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
	self addFieldAccessOrMessageWith: [:receiver :method | (SFieldAccessMessage
								receiver: receiver
								selector: method) ] filteringBy: true.
]

{ #category : #actions }
SSTestCase >> addFieldAccessOrMessageWith: aBlock filteringBy: aBoolean [
	| receivers |
	receivers := statements select: #isFactoryMessage.
	receivers shuffle
		do: [ :receiver | 
			| methods |
			methods := typeInfo methodsFrom: receiver toSelect: aBoolean.
			methods
				ifNotEmpty: [ self
						addAssignment:
							(aBlock
								valueWithPossibleArgs:
									{receiver.
									methods shuffle anyOne}).
					^ self ] ]
]

{ #category : #actions }
SSTestCase >> addMessage [
	self
		addFieldAccessOrMessageWith: [ :receiver :method | 
			SMessage
				receiver: receiver
				selector: method
				previousStatements: statements ]
		filteringBy: false
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

{ #category : #initialization }
SSTestCase >> initialize [
	statements := OrderedCollection new.
	nextId := 0
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
