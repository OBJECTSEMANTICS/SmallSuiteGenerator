Class {
	#name : #SSTestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'typeInfo',
		'nextId',
		'numMaxStatements'
	],
	#category : #'SmallSuiteGenerator-Generator-Core'
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
	^ self addFactoryMessage: typeInfo randomNoneAbstractClass name
]

{ #category : #actions }
SSTestCase >> addFactoryMessage: aClassName [
	^ self
		addAssignment: (self newFactoryMessage: aClassName before: nil)
]

{ #category : #adding }
SSTestCase >> addFactoryMessage: aClassName ofSelector: aSelector [
	
	^ [self
		addAssignment:
			(self
				factoryMessageUsing: (self typeInfo typeOf: aSelector fromMetaClassName: aClassName)
				before: nil)] on: KeyNotFound 
			do: [ self addFactoryMessage: aClassName ]
]

{ #category : #adding }
SSTestCase >> addFactoryMessage: aClassName withMethod: aMethod [
	^ self addAssignment: (self factoryMessageUsing: aMethod before: nil)
]

{ #category : #actions }
SSTestCase >> addFieldAccessMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickAccessorsOf: receiver returnType.
	methods
		ifNotEmpty: [ ^ self
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
	^ self addLiteral: typeInfo scalars keys shuffle anyOne
]

{ #category : #adding }
SSTestCase >> addLiteral: aClassName [
	^ self addAssignment: (self newLiteral: aClassName)
]

{ #category : #actions }
SSTestCase >> addMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickMessagesOf: receiver returnType.
	methods
		ifNotEmpty: [ ^ self addMessage: methods shuffle anyOne withReceiver: receiver ]
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
	^ self
		addAssignment: (self messageUsing: method and: receiver before: nil)
]

{ #category : #actions }
SSTestCase >> addStatement: anExpression [
	statements add: anExpression.
]

{ #category : #adding }
SSTestCase >> addStatement: newExpression after: aStatement [
	| anIndex |
	anIndex := statements indexOf: aStatement.
	anIndex = 0
		ifTrue: [ self addStatement: newExpression  ]
		ifFalse: [ anIndex := (anIndex to: self numberStatements) atRandom.
			statements add: newExpression afterIndex: anIndex ].
	^ newExpression
]

{ #category : #adding }
SSTestCase >> addStatement: newExpression before: aStatement [

	statements
		add: newExpression
		afterIndex: (self randomIndexToAdd: newExpression before: aStatement)

]

{ #category : #'as yet unclassified' }
SSTestCase >> addStatementOfType: aType before: aExpression [
	| newExpression |
	newExpression := self
		newAssignment: (self newStatementOfType: aType before: aExpression).
	self addStatement: newExpression before: aExpression.
	^ newExpression
]

{ #category : #adding }
SSTestCase >> addStatements: collStatements [
	self
		assert: statements isEmpty
		description: 'statements must be empty'.
	statements addAll: collStatements
]

{ #category : #'as yet unclassified' }
SSTestCase >> allVarNames [
	^ statements collect: [ :stm | stm reference printString ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> alternativeFactoryMessage: aFactoryMessage before: aExpression [
	| returnType |
	returnType := aFactoryMessage returnType.
	^ (typeInfo factoryMethods: returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aFactoryMessage selector ] ]
		ifFound: [ :meth | self factoryMessageUsing: meth before: aExpression ]
		ifNone: [ SFactoryMessage default: returnType ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> alternativeFieldAccessMessage: aFieldAccessMessage before: aExpression [
	| returnType receiver |
	receiver := aFieldAccessMessage receiver.
	returnType := aFieldAccessMessage returnType.
	(self pickAccessorsOf: receiver returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aFieldAccessMessage selector ] ]
		ifFound:
			[ :meth | ^ SFieldAccessMessage newFromReceiver: receiver andMethod: meth ].
	self
		error:
			'not found alternative of fieldAccessMessage: '
				, aFieldAccessMessage printString
]

{ #category : #'as yet unclassified' }
SSTestCase >> alternativeMessage: aMessage before: aExpression [
	| returnType receiver |
	receiver := aMessage receiver.
	returnType := aMessage returnType.
	(self pickMessagesOf: receiver returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aMessage selector ] ]
		ifFound: [ :meth | 
			^ self messageUsing: meth and: receiver before: aExpression].
	self
		error: 'not found alternative of message: ' , aMessage printString
]

{ #category : #'as yet unclassified' }
SSTestCase >> alternativeOfVariable: aVariable before: aExpression [
	| returnType |
	self statementOfVarName: aVariable printString.
	returnType := aVariable returnType.
	(self statementsOfType: returnType before: aExpression)
		detect: [ :stm | stm reference ~= aVariable ]
		ifFound: [ :stm | ^ stm reference ].
	^ (self addStatementOfType: returnType before: aExpression) reference
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
SSTestCase >> buildArgs: argTypes before: aStatement [
	argTypes
		ifNotNil: [ | types typesToAdd |
			types := (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
				collect: #returnType.	
			typesToAdd := ((argTypes flatCollect: [ :arg | arg types ])
				reject: [ :aType | types includes: aType ]) asSet.
			(typeInfo scalars keys includesAll: typesToAdd)
				ifFalse: [ ^ self error: 'error to create args' ].
			typesToAdd
				do: [ :type | 
					self
						addStatement: (self newAssignment: (self newLiteral: type))
						before: aStatement ] ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> changeStatement [
	statements copy shuffle
		do: [ :stm | 
			[ ^ self changeStatement: stm ]
				on: SError
				do: [  ] ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> changeStatement: aStatement [
	|statementChanged|
	statementChanged := aStatement copy repairOn: self changing: aStatement.
	(self statementAt: aStatement)
		replaceBy: statementChanged.
		^ statementChanged
]

{ #category : #removing }
SSTestCase >> changeStatementOfVarName: varName [
	^ self changeStatement: (self statementOfVarName: varName)
]

{ #category : #copying }
SSTestCase >> copy [
	| copy |
	copy := SSTestCase with: typeInfo copy.
	statements do: [ :stm | copy addStatement: stm copy ].
	copy updateNextId.
	^ copy
]

{ #category : #'as yet unclassified' }
SSTestCase >> defaultNumberStatements [
	^ 54
]

{ #category : #'error handling' }
SSTestCase >> error: aString [
	^ SError signal: aString
]

{ #category : #'as yet unclassified' }
SSTestCase >> factoryMessageUsing: method before: aStatement [
	self buildArgs: method argTypes before: aStatement.
			^ SFactoryMessage
				method: method
				previousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
]

{ #category : #querying }
SSTestCase >> factoryMessageVariablesBefore: aStatement [
	^ (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
		select: [ :stm | stm value isFactoryMessage ]
		thenCollect: [ :stm | stm variable ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> generateStatements [
	[ self numberStatements < self numMaxStatements ]
		whileTrue: [ self
				perform:
					#(#addFactoryMessage #addFieldAccessMessage #addMessage #addLiteral)
						shuffle anyOne ]
]

{ #category : #comparing }
SSTestCase >> hash [
	^ self statements hash
]

{ #category : #initialization }
SSTestCase >> initialize [
	statements := OrderedCollection new.
	nextId := 0.
	numMaxStatements := 0
]

{ #category : #'as yet unclassified' }
SSTestCase >> insertAsParameter: aExpression after: aStatement [
	(statements
		copyFrom: (statements indexOf: aStatement) + 1
		to: self numberStatements) shuffle
		do: [ :stm | 
			[ ^ stm replaceArgBy: aExpression ]
				on: SError
				do: [  ] ].
	self error: 'cant insert as parameter'
]

{ #category : #actions }
SSTestCase >> insertExpression: aExpression after: aStatement [
	^ self
		addStatement: (self newAssignment: aExpression)
		after: aStatement
]

{ #category : #'as yet unclassified' }
SSTestCase >> insertRandomStatement [
	#(#insertRandomMessage:using: #insertMethodMessage:using: #insertAsParameter:using:)
		shuffle
		do: [ :selector | 
			[ ^ self insertStatementOfSelector: selector ]
				on: SError
				do: [  ] ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> insertStatement [
	| l stop alpha count random  |
	statements ifEmpty: [ ^ #() ].
	l := 1.
	count := 0.
	stop := self numberStatements.
	alpha := 0.5.
	random := Random new seed: DateAndTime current nanoSecond / 100.
	[ l < stop and: [ random next <= (alpha raisedTo: count) ] ]
		whileTrue: [ self insertRandomStatement.
			l := l + 1.
			count := count + 1 ].
]

{ #category : #'as yet unclassified' }
SSTestCase >> insertStatementOfSelector: selector [
	statements copy shuffle
		do: [ :stm | 
			[ ^ self perform: selector inStatement: stm ]
				on: SError
				do: [  ] ].
	self
		error: 'Cant insert statement of selector: ' , selector printString
]

{ #category : #'as yet unclassified' }
SSTestCase >> messageUsing: method and: receiver before: aStatement [
	self buildArgs: method argTypes before: aStatement.
	^ SMessage
				newFromReceiver: receiver copy
				method: method
				andPreviousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
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
	^ typeInfo types
		at: aClassName
		ifPresent: [ | methods |
			methods := typeInfo factoryMethods: aClassName.
			methods
				ifEmpty: [ SFactoryMessage default: aClassName ]
				ifNotEmpty: [ self newFactoryMessageUsing: methods and: aStatement ] ]
		ifAbsent: [ self error: 'error factoryMessage' ]
]

{ #category : #actions }
SSTestCase >> newFactoryMessageUsing: methods and: aStatement [
	methods shuffle
		do: [ :method | 
			[ ^ self factoryMessageUsing: method before: aStatement]
				on: SError
				do: [  ] ].
	self error: 'error factoryMessage'
]

{ #category : #actions }
SSTestCase >> newFieldAccessMessageOfType: aType andReceiver: receiver [
	^ (self pickAccessorsOf: receiver returnType)
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
	^self error: 'cant create field access of type: ' , aType asString
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
			[ ^ self newMessageOfType: aType using: receiver before: aStatement ]
				on: SError
				do: [  ] ].
	^self error: 'cant create message of type: ' , aType asString
]

{ #category : #actions }
SSTestCase >> newMessageOfType: aType using: receiver before: aStatement [
	(self pickMessagesOf: receiver returnType)
		detect: [ :aMethod | aMethod returnType = aType ]
		ifFound: [ :aMethod | 
			[ ^ self messageUsing: aMethod and: receiver before: aStatement ]
				on: SError
				do: [  ] ].
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
	^self
		error: 'Cant create expression with the returnType: ' , aType asString
]

{ #category : #accessing }
SSTestCase >> numMaxStatements [
	^ numMaxStatements < 1 ifFalse: [ numMaxStatements ] ifTrue: [ self defaultNumberStatements ]
]

{ #category : #accessing }
SSTestCase >> numMaxStatements: aInt [
	numMaxStatements := aInt
]

{ #category : #accessing }
SSTestCase >> numberStatements [
	^ statements size
]

{ #category : #'as yet unclassified' }
SSTestCase >> perform: selector inStatement: stm [
	^ stm perform: selector withArguments: {stm copy. self}
]

{ #category : #querying }
SSTestCase >> pickAccessorsOf: aType [
	^ typeInfo types
		at: aType
		ifPresent: [ :value | value accessMessages ]
		ifAbsent: [ #() ]
]

{ #category : #querying }
SSTestCase >> pickAnObjectVariable [
	
	(self factoryMessageVariablesBefore: nil)
		ifEmpty: [ self addFactoryMessage ].
	^ (self factoryMessageVariablesBefore: nil) shuffle anyOne
]

{ #category : #querying }
SSTestCase >> pickMessagesOf: aType [
	^ (typeInfo types at: aType) messages
]

{ #category : #querying }
SSTestCase >> pickObjectVariableOf: aClassName [
	^ (self factoryMessageVariablesBefore: nil)
		detect: [ :var | var returnType = aClassName ]
		ifNone: [ self error: 'Dont exist a constructor of class' , aClassName ]
]

{ #category : #querying }
SSTestCase >> pickOrCreateObjectVariableOf: aClassName [
	^ [ self pickObjectVariableOf: aClassName ]
		on: SError
		do: [ (self addFactoryMessage: aClassName) variable ]
]

{ #category : #adding }
SSTestCase >> randomIndexToAdd: aExpression before: aStatement [
	| refIndexes anIndex |
	anIndex := statements indexOf: aStatement.
	anIndex = 0
		ifTrue: [ ^ self numberStatements ].
	refIndexes := self referencesIndexes: aExpression.
	anIndex := anIndex - 1.
	refIndexes
		ifNotEmpty: [ | ini end maxIndex |
			maxIndex := refIndexes max.
			ini := anIndex min: maxIndex.
			end := anIndex max: maxIndex.
			^ (ini to: end) atRandom ].
	anIndex = 0
		ifTrue: [ ^ anIndex ].
	^ (1 to: anIndex) atRandom
]

{ #category : #actions }
SSTestCase >> randomStatement [
	^ statements at: (1 to: self numberStatements ) atRandom
	
]

{ #category : #'as yet unclassified' }
SSTestCase >> referencesIndexes: aExpression [
	^ ((aExpression variablesWithId ) allButFirst collect: [ :var | statements indexOf: (self statementOfVarName: var printString) ])
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
	| stmToRemove stmtsToRemove |
	stmToRemove := self statementAt: aStatement.
	statements remove: stmToRemove.
	stmtsToRemove := statements copy
		flatCollect:
			[ :stm | self repairParameters: (stm pickUpReferences: stmToRemove) of: stm ].
	stmtsToRemove do: [ :stm | self removeStatement: stm ]
]

{ #category : #removing }
SSTestCase >> removeStatementOfVarName: varName [
	^ self removeStatement: (self statementOfVarName: varName) copy
]

{ #category : #'as yet unclassified' }
SSTestCase >> repairExpression: anExpression before: aStatement [
	| aType replacement |
	aType := anExpression returnType.
	replacement := (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
		shuffle
		detect:
			[ :stm | stm reference ~= anExpression and: [ stm returnType = aType ] ]
		ifNone: [ self addStatementOfType: anExpression returnType before: aStatement ].
	(self statementAt: aStatement)
		replaceExpression: anExpression
		by: replacement
]

{ #category : #'as yet unclassified' }
SSTestCase >> repairParameters: expressions of: aStatement [
	|exprsToDelete|
	exprsToDelete := OrderedCollection new.
	expressions
		do: [ :expr | [self repairExpression: expr before: aStatement] on: SError do: [ exprsToDelete add: expr. ] ].
		^ exprsToDelete 
]

{ #category : #accessing }
SSTestCase >> statementAt: statement [
	^ statements
		detect: [ :stm | stm = statement ]
		ifNone: [ self error: 'statement not found' ]
]

{ #category : #testing }
SSTestCase >> statementOfVarName: aString [
	^ statements
		detect: [ :stm | stm reference printString = aString ]
		ifNone: [ self error: 'Not found statement of varName: ' , aString ]
]

{ #category : #accessing }
SSTestCase >> statements [
	^ statements
]

{ #category : #'as yet unclassified' }
SSTestCase >> statementsOfType: aType before: aExpression [
	(statements includes: aExpression)
		ifFalse: [ self error: 'not found statement' ].
	^ (self subStatementsFrom: 1 toPrevIndexOf: aExpression)
		select: [ :stm | stm returnType = aType ]
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

{ #category : #'as yet unclassified' }
SSTestCase >> validReferences [
	| references |
	references := Set new.
	^ statements
		detect: [ :stm | 
			|variables|
			variables := stm variablesWithId.
			references add: stm reference.
			(references includesAll: variables) ifFalse: [ self halt.true ] ifTrue: [ references addAll: variables. false ] 
				.
		 ] ifFound: [false] ifNone: [true].
]
