Class {
	#name : #SSTestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'typeInfo',
		'nextId',
		'numMaxStatements'
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

{ #category : #comparing }
SSTestCase >> = other [
	^ self class = other class and: [ statements = other statements ]
]

{ #category : #actions }
SSTestCase >> addAssignment: anExpression [
	| assignment |
	assignment := self newAssignment: anExpression.
	self addStatement: assignment.
	^ assignment
]

{ #category : #actions }
SSTestCase >> addFactoryMessage [
	self addFactoryMessage: typeInfo randomNoneAbstractClass name
]

{ #category : #actions }
SSTestCase >> addFactoryMessage: aClassName [
	^ self
		addAssignment: (self newFactoryMessage: aClassName before: nil)
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
SSTestCase >> addFieldAccessMessage: aSelector from: aClass [
	| receiver anAccessor |
	anAccessor := (typeInfo classAt: aClass) methodOf: aSelector.
	anAccessor isQuick
		ifFalse: [ self error: 'the method must be an accessor message' ].
	receiver := self pickOrCreateObjectVariableOf: aClass.
	^ self addFieldAccessMessage: anAccessor withReceiver: receiver
]

{ #category : #actions }
SSTestCase >> addFieldAccessMessage: method withReceiver: receiver [
	^ self
		addAssignment: (SFieldAccessMessage newFromReceiver: receiver copy andMethod: method)
]

{ #category : #adding }
SSTestCase >> addLiteral [
	typeInfo scalars ifEmpty: [ self error: 'scalars are not defined' ].
	self addLiteral: typeInfo scalars keys shuffle anyOne.
	
]

{ #category : #adding }
SSTestCase >> addLiteral: aClassName [
	self addAssignment: (self newLiteral: aClassName)
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
	aMethod := (typeInfo classAt: aClassName) methodOf: aSelector.
	aMethod isQuick
		ifTrue: [ self error: 'the method must be a message, not accessor message' ].
	receiver := self pickOrCreateObjectVariableOf: aClassName.
	^ self addMessage: aMethod withReceiver: receiver
]

{ #category : #actions }
SSTestCase >> addMessage: method withReceiver: receiver [
	self buildArgs: method before: nil.
	^ self
		addAssignment:
			(SMessage
				newFromReceiver: receiver copy
				method: method
				andPreviousStatements: statements)
]

{ #category : #actions }
SSTestCase >> addStatement: anExpression [
	statements add: anExpression.
]

{ #category : #adding }
SSTestCase >> addStatement: newExpression before: aStatement [
	| anIndex |
	anIndex := statements indexOf: aStatement.
	anIndex = 0 ifTrue: [ statements add: newExpression  ] ifFalse: [  
	"anIndex > 0
		ifFalse: [ self error: 'the statement does not exist' ]."
	anIndex := (1 to: anIndex) atRandom.
	statements
		add: newExpression
		afterIndex:
			(anIndex > 1
				ifTrue: [ anIndex - 1 ]
				ifFalse: [ 0 ])]
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
SSTestCase >> buildArgs: aMethodTypeInfo before: aStatement [
	aMethodTypeInfo argTypes
		ifNotEmpty: [ | types typesToAdd |
			types := (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
				collect: #returnType.
			typesToAdd := (aMethodTypeInfo argTypes
				reject: [ :aType | types includes: aType ]) asSet.
			(typeInfo scalars keys includesAll: typesToAdd)
				ifFalse: [ ^ self error: 'error to create args' ].
			typesToAdd
				do: [ :type | self addStatement: (self newAssignment: (self newLiteral: type)) before: aStatement ] ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> changeStatement [
	statements ifEmpty: [ ^ #() ].
	^ self
		changeStatementOfVarName:
			(statements at: (1 to: self numberStatements) atRandom) variable
				varName
]

{ #category : #'as yet unclassified' }
SSTestCase >> changeStatementOfVarName: varName [
	| stmToChange varNamesToChange |
	stmToChange := self statementAt: varName.
	stmToChange
		ifNil: [ ^ self error: 'Dont exist a statement with this varName.' ].
	varNamesToChange := OrderedCollection new. "implementar repair:onChhanging:"
	statements copy
		do:
			[ :stm | varNamesToChange addAll: (stm repairOn: self changing: stmToChange) ].
	statements remove: stmToChange.
	varNamesToChange
		do: [ :aName | self changeStatementOfVarName: aName ].
	^ {varName} , varNamesToChange
]

{ #category : #copying }
SSTestCase >> copy [
	| copy |
	copy := SSTestCase with: typeInfo copy.
	statements do: [ :stm | copy addStatement: stm copy ].
	copy updateNextId.
	^ copy
]

{ #category : #'error handling' }
SSTestCase >> error: aString [
	^ SError signal: aString
]

{ #category : #querying }
SSTestCase >> factoryMessageVariables [
	^ statements
		select: [ :stm | stm value isFactoryMessage ]
		thenCollect: [ :stm | stm variable ]
]

{ #category : #querying }
SSTestCase >> factoryMessageVariablesBefore: aStatement [
	^ (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
		select: [ :stm | stm value isFactoryMessage ]
		thenCollect: [ :stm | stm variable ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> generateStatements [
	[ statements size < numMaxStatements ]
		whileTrue: [ self
				perform:
					#(#addFactoryMessage #addFieldAccessMessage #addMessage #addLiteral)
						shuffle anyOne ]
]

{ #category : #comparing }
SSTestCase >> hash [
	^ self statements hash
]

{ #category : #'as yet unclassified' }
SSTestCase >> includesStatementOfVarName: aString [
	^ (statements collect: [ :stm | stm reference printString ]) includes: aString
]

{ #category : #initialization }
SSTestCase >> initialize [
	statements := OrderedCollection new.
	nextId := 0
]

{ #category : #'as yet unclassified' }
SSTestCase >> insertRandomStatement [
	| insertedVarNames |
	#(#insertRandomMessageWith: #insertMethodMessageWith: #insertParameterWith:)
		shuffle
		detect: [ :selector | 
			insertedVarNames := self insertStatementOfSelector: selector.
			insertedVarNames isNotNil ]
		ifFound: [ ^ insertedVarNames ]
		ifNone: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> insertStatement [
	| l stop varNames alpha count random insertedVarNames |
	statements ifEmpty: [ ^ #() ].
	l := 1.
	count := 0.
	stop := self numberStatements.
	alpha := 0.5.
	insertedVarNames := OrderedCollection new.
	random := Random new seed: DateAndTime current nanoSecond / 100.
	[ l < stop and: [ random next <= (alpha raisedTo: count) ] ]
		whileTrue: [ varNames := self insertRandomStatement.
			varNames ifNotNil: [ insertedVarNames addAll: varNames ].
			l := l + 1.
			count := count + 1 ].
	^ insertedVarNames
]

{ #category : #'as yet unclassified' }
SSTestCase >> insertStatementOfSelector: selector [
	| varNames |
	^ statements copy shuffle
		detect: [ :stm | varNames := (stm perform: selector with: self).
			varNames isNotNil ] ifFound: [ varNames ] ifNone: [ nil ]
]

{ #category : #'instance creation' }
SSTestCase >> newAssignment: anExpression [
	^ SAssignment
		name:
			(SVariable new
				varName: '_var';
				id: self assignId;
				returnType: anExpression returnType;
				yourself)
		value: anExpression.
]

{ #category : #actions }
SSTestCase >> newFactoryMessage: aClassName before: aStatement [
	typeInfo types
		at: aClassName
		ifPresent: [ | methods |
			methods := typeInfo factoryMethods: aClassName.
			methods ifEmpty: [ ^ SFactoryMessage default: aClassName ].
			^ [ self newFactoryMessageUsing: methods and: aStatement ]
				on: SError
				do: [ :e | e ] ]
		ifAbsent: [ self error: 'error factoryMessage' ]
]

{ #category : #actions }
SSTestCase >> newFactoryMessageUsing: methods and: aStatement [
	methods shuffle
		do: [ :method | 
			[self buildArgs: method before: aStatement.
			^ SFactoryMessage
				method: method
				previousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement) ]
			on: SError
		do: [  ]].
	self error: 'error factoryMessage'
]

{ #category : #actions }
SSTestCase >> newFieldAccessMessageOfType: aType andReceiver: receiver [
	^ (self pickAccessorsOf: receiver)
		detect: [ :aMethod | aMethod returnType = aType ]
		ifFound:
			[ :aMethod | SFieldAccessMessage newFromReceiver: receiver copy andMethod: aMethod ]
		ifNone: [ self error: 'cant create field access of type: ' , aType asString ]
]

{ #category : #actions }
SSTestCase >> newFieldAccessMessageOfType: aType before: aStatement [
	(self factoryMessageVariablesBefore: aStatement)
		do: [ :receiver | 
			[ ^ self newFieldAccessMessageOfType: aType andReceiver: receiver ]
				on: SError
				do: [  ] ].
	self error: 'cant create field access of type: ' , aType asString
]

{ #category : #'instance creation' }
SSTestCase >> newLiteral: aClassName [
	| aObject |
	aObject := typeInfo scalars
		at: aClassName
		ifPresent: [ :values | values asArray shuffle anyOne ]
		ifAbsent: [ ^ self error: 'scalars dont contain: ' , aClassName asString ].
	^ SLiteral new
		returnType: aClassName;
		value: aObject
]

{ #category : #actions }
SSTestCase >> newMessageOfType: aType before: aStatement [
	(self factoryMessageVariablesBefore: aStatement)
		do: [ :receiver | 
			[ ^ self newMessageOfType: aType using: receiver before: aStatement ] on: SError do: [  ]
			 ].
	self error: 'cant create message of type: ' , aType asString
]

{ #category : #actions }
SSTestCase >> newMessageOfType: aType using: receiver before: aStatement [
	(self pickMessagesOf: receiver)
				detect: [ :aMethod | aMethod returnType = aType ]
				ifFound: [ :aMethod | 
					[self buildArgs: aMethod before: aStatement.
					^ SMessage
						newFromReceiver: receiver reference copy
						method: aMethod
						andPreviousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement) ] on: SError do: [  ]].
				^ self error: 'error to create message'
]

{ #category : #adding }
SSTestCase >> newStatementOfType: aType before: aStatement [
	#(#newFactoryMessage:before: #newLiteral: #newFieldAccessMessageOfType:before: #newMessageOfType:before:)
		shuffle
		do: [ :message | 
			[ ^ self
				perform: message
				withEnoughArguments:
					{aType.
					aStatement} ]
				on: SError
				do: [ "try with the next one" ] ].
	^ self
		error: 'Cant create expression with the returnType: ' , aType asString
]

{ #category : #accessing }
SSTestCase >> numMaxStatements: aInt [
	numMaxStatements := aInt
]

{ #category : #accessing }
SSTestCase >> numberStatements [
	^ statements size
]

{ #category : #querying }
SSTestCase >> pickAccessorsOf: aVariable [
	^ typeInfo types at: aVariable returnType ifPresent: [ :value | value accessMessages ] ifAbsent: [#()]
]

{ #category : #querying }
SSTestCase >> pickAnObjectVariable [
	self factoryMessageVariables ifEmpty: [ self addFactoryMessage ].
	^ self factoryMessageVariables shuffle anyOne
]

{ #category : #querying }
SSTestCase >> pickMessagesOf: aVariable [
	^ (typeInfo types at: aVariable returnType) messages
]

{ #category : #querying }
SSTestCase >> pickObjectVariableOf: aClassName [
	^ self factoryMessageVariables
		detect: [ :var | var returnType = aClassName ]
		ifFound: [ :var | var ] ifNone: [ self error: 'Dont exist a constructor of class', aClassName]
]

{ #category : #querying }
SSTestCase >> pickOrCreateObjectVariableOf: aClassName [
	^ [ self pickObjectVariableOf: aClassName ]
		on: SError
		do: [ (self addFactoryMessage: aClassName) variable ]
]

{ #category : #removing }
SSTestCase >> removeStatement [
	"If other statements refer the statement to remove, then this reference is replaced with another value out of the set which has the same type"

	statements ifEmpty: [ ^ #() ].
	self
		removeStatement: (statements at: (1 to: self numberStatements) atRandom)
]

{ #category : #removing }
SSTestCase >> removeStatement: aStatement [
	| stmToRemove |
	stmToRemove := self statementAt: aStatement.
	stmToRemove
		ifNil: [ ^ self error: 'Dont exist a statement with this varName.' ].
		statements remove: stmToRemove.
	statements copy
		do:
			[ :stm | self repairParameters: (stm pickUpReferences: stmToRemove) of: stm ].
]

{ #category : #removing }
SSTestCase >> removeStatementOfVarName: varName [
	^ self removeStatement: (self statementOfVarName: varName) copy
]

{ #category : #'as yet unclassified' }
SSTestCase >> repairExpression: anExpression before: aStatement [
	| aType replacement |
	aType := anExpression returnType.
	replacement := (self
		subStatementsFrom: 1
		toPrevIndexOf: aStatement) shuffle
		detect:
			[ :stm | stm reference ~= anExpression and: [ stm returnType = aType ] ]
		ifNone: [ self replacementOf: anExpression before: aStatement ].
	(self statementAt: aStatement)
		replaceExpression: anExpression
		by: replacement
]

{ #category : #'as yet unclassified' }
SSTestCase >> repairParameters: expressions of: aStatement [
	^ expressions
		do: [ :expr | self repairExpression: expr before: aStatement ]
]

{ #category : #adding }
SSTestCase >> replacementOf: anExpression before: aStatement [
	| newExpression |
	newExpression := self
		newAssignment: (self newStatementOfType: anExpression returnType before: aStatement).
	self addStatement: newExpression before: aStatement.
	^ newExpression
]

{ #category : #accessing }
SSTestCase >> statementAt: statement [
	^ statements
		detect: [ :stm | stm = statement ]
		"ifFound: [ :stm | stm ]"
		ifNone: [ nil ]
]

{ #category : #testing }
SSTestCase >> statementOfVarName: aString [
	^ statements detect: [ :stm | stm reference printString = aString ]
	ifNone: [ nil ]
]

{ #category : #accessing }
SSTestCase >> statements [
	^ statements
]

{ #category : #'as yet unclassified' }
SSTestCase >> subStatementsFrom: start toPrevIndexOf: aStatement [
	|stop|
	stop := statements indexOf: aStatement.
	stop = 0
		ifTrue: [ ^ statements ].
	( start <= stop )
		ifFalse: [ ^ self error: 'Data must be in range' ].
	^ statements copyFrom: start to: stop - 1.
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
