Class {
	#name : #SSTestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'assertions',
		'typeInfo',
		'nextId',
		'numMaxStatements',
		'fitness'
	],
	#category : #'SmallSuiteGenerator-Core'
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

{ #category : #inserting }
SSTestCase >> addAssignment: anExpression [
	| assignment |
	assignment := self newAssignment: anExpression.
	self addStatement: assignment.
	^ assignment
]

{ #category : #inserting }
SSTestCase >> addFactoryMessage [
	^ self addFactoryMessage: typeInfo randomNoneAbstractClass name
]

{ #category : #inserting }
SSTestCase >> addFactoryMessage: aClassName [
	^ self
		addAssignment: (self newFactoryMessage: aClassName before: nil)
]

{ #category : #inserting }
SSTestCase >> addFactoryMessage: aClassName ofSelector: aSelector [
	^ [ self
		addAssignment:
			(self
				factoryMessageUsing: (typeInfo type: aSelector fromMetaClassName: aClassName)
				before: nil) ]
		on: SError
		do: [ self addFactoryMessage: aClassName ]
]

{ #category : #inserting }
SSTestCase >> addFactoryMessage: aClassName withMethod: aMethod [
	^ self addAssignment: (self factoryMessageUsing: aMethod before: nil)
]

{ #category : #inserting }
SSTestCase >> addFieldAccessMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickAccessorsOf: receiver returnType.
	methods
		ifNotEmpty: [ ^ self
				addFieldAccessMessage: methods shuffle anyOne
				withReceiver: receiver ]
]

{ #category : #inserting }
SSTestCase >> addFieldAccessMessage: aSelector from: aClassName [
	| receiver anAccessor |
	anAccessor := (self pickAccessorsOf: aClassName)
		detect: [ :accessor | accessor selector = aSelector ]
		ifNone: [ self
				error:
					'the receiver of: ' , aSelector , ' does not match with: '
						, aClassName ].
	receiver := self pickOrCreateObjectVariableOf: aClassName.
	^ self addFieldAccessMessage: anAccessor withReceiver: receiver
]

{ #category : #inserting }
SSTestCase >> addFieldAccessMessage: method withReceiver: receiver [
	^ self
		addAssignment: (SFieldAccessMessage newFromReceiver: receiver copy andMethod: method)
]

{ #category : #inserting }
SSTestCase >> addLiteral [

	typeInfo scalars
		ifNotEmpty: [typeInfo scalars keys shuffle do: [ :aClassName | 
				[^ self addLiteral: aClassName] on: SError do: [  ]
				 ] ]
]

{ #category : #inserting }
SSTestCase >> addLiteral: aClassName [
	| literal |
	literal := self literal: aClassName.
	literal value
		ifNil: [ self error: 'error to create literal' ]
		ifNotNil: [ ^ self addAssignment: literal ]
]

{ #category : #inserting }
SSTestCase >> addMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickMessagesOf: receiver returnType.
	methods
		ifNotEmpty: [ ^ self addMessage: methods shuffle anyOne withReceiver: receiver ]
]

{ #category : #inserting }
SSTestCase >> addMessage: aSelector from: aClassName [
	| receiver aMethod |
	aMethod := (self pickMessagesOf: aClassName)
		, (typeInfo factoryMessagesFrom: aClassName)
		detect: [ :aMessage | aMessage selector = aSelector ]
		ifNone: [ self
				error:
					'the receiver of: ' , aSelector , ' does not match with: '
						, aClassName ].
	aMethod isQuick
		ifTrue: [ self error: 'the method must be a message, not accessor message' ].
	receiver := self pickOrCreateObjectVariableOf: aClassName.
	^ self addMessage: aMethod withReceiver: receiver
]

{ #category : #inserting }
SSTestCase >> addMessage: method withReceiver: receiver [
	^ self addAssignment: (self messageUsing: method and: receiver before: nil)
]

{ #category : #inserting }
SSTestCase >> addStatement: anExpression [
	statements add: anExpression.
]

{ #category : #inserting }
SSTestCase >> addStatement: newExpression after: aStatement [
	| anIndex |
	anIndex := statements indexOf: aStatement.
	anIndex = 0
		ifTrue: [ self addStatement: newExpression  ]
		ifFalse: [ anIndex := (anIndex to: self numberStatements) atRandom.
			statements add: newExpression afterIndex: anIndex ].
	^ newExpression
]

{ #category : #inserting }
SSTestCase >> addStatement: newExpression before: aStatement [
	"I add a newExpression before aStatement"
	statements
		add: newExpression
		afterIndex: (self randomIndexToAdd: newExpression before: aStatement)
]

{ #category : #inserting }
SSTestCase >> addStatementOfType: aType before: aExpression [
	| newExpression |
	newExpression := self
		newAssignment: (self newStatementOfType: aType before: aExpression).
	self addStatement: newExpression before: aExpression.
	^ newExpression
]

{ #category : #inserting }
SSTestCase >> addStatements: collStatements [
	self
		assert: statements isEmpty
		description: 'statements must be empty'.
	statements addAll: collStatements
]

{ #category : #accessing }
SSTestCase >> allVarNames [
	^ statements collect: [ :stm | stm reference printString ]
]

{ #category : #transformations }
SSTestCase >> alternativeFactoryMessage: aFactoryMessage before: aExpression [
	| returnType |
	returnType := aFactoryMessage returnType.
	^ (typeInfo factoryMessagesFrom: returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aFactoryMessage selector ] ]
		ifFound: [ :meth | self factoryMessageUsing: meth before: aExpression ]
		ifNone: [ SFactoryMessage default: returnType ]
]

{ #category : #transformations }
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

{ #category : #transformations }
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

{ #category : #transformations }
SSTestCase >> alternativeOfVariable: aVariable before: aExpression [
	| returnType |
	
	self statementOfVarName: aVariable printString.
	returnType := aVariable returnType.
	(self statementsOfType: returnType before: aExpression)
		detect: [ :stm | stm reference ~= aVariable ]
		ifFound: [ :stm | ^ stm reference ].
	^ (self addStatementOfType: returnType before: aExpression) reference
]

{ #category : #running }
SSTestCase >> analyze [
	" we delegate the responsibility to a test runner, in the future we would like to add new ways to run the tests "

	^ SSTestRunner new evaluate: self
]

{ #category : #accessing }
SSTestCase >> assertions [
	^ assertions
]

{ #category : #accessing }
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

{ #category : #transformations }
SSTestCase >> buildArgs: argTypes before: aStatement [
	argTypes
		ifNotNil: [ | types typesToAdd |
			types := (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
				collect: #returnType
				thenSelect: [ :aType | aType isNotNil ].
			typesToAdd := ((argTypes flatCollect: [ :arg | arg types ])
				reject: [ :aType | types includes: aType ]) asSet.
			typesToAdd := self satisfyTypes: typesToAdd before: aStatement.
			typesToAdd
				do: [ :type | 
					self
						addStatement: (self newAssignment: ( self literal: type))
						before: aStatement ] ]
]

{ #category : #mutation }
SSTestCase >> changeMessageNotUnderstood: aSelector from: aClassName [
	^ false
]

{ #category : #mutation }
SSTestCase >> changeStatement [
	statements copy shuffle
		do: [ :stm | 
			[ ^ self changeStatement: stm ]
				on: SError
				do: [  ] ]
]

{ #category : #mutation }
SSTestCase >> changeStatement: aStatement [
	| statementChanged |
	statementChanged := aStatement copy
		repairOn: self
		changing: aStatement.
	(self statementAt: aStatement) replaceBy: statementChanged.
	^ statementChanged
]

{ #category : #mutation }
SSTestCase >> changeStatementOfClassName: aClassName [
	| varExpressions changed |
	
	varExpressions := self messagesVariablesFrom: aClassName.
	changed := false.
	"if the expression can't be replaced by another, then it will be removed"
	varExpressions
		do: [ :var | 
			| changedStm origStm |
			origStm := self statementOfVarName: var printString.
			changedStm := self changeStatement: origStm.
			changedStm = origStm
				ifTrue: [ self removeStatementNoRepairing: origStm ]
				ifFalse: [ changed := true ] ].
	^ changed
]

{ #category : #removing }
SSTestCase >> changeStatementOfVarName: varName [
	^ self changeStatement: (self statementOfVarName: varName)
]

{ #category : #running }
SSTestCase >> computeFitness: fitnessClass [

	| valueFitness |
	valueFitness := fitnessClass computeFitness: self.
	[ fitness addAll: valueFitness ]
		on: MessageNotUnderstood
		do: [ fitness add: valueFitness ]
]

{ #category : #copying }
SSTestCase >> copy [
	| copy |
	copy := SSTestCase with: typeInfo copy.
	statements do: [ :stm | copy addStatement: stm copy ].
	copy updateNextId.
	^ copy
]

{ #category : #accessing }
SSTestCase >> defaultNumberStatements [
	^ 54
]

{ #category : #'error handling' }
SSTestCase >> error: aString [
	^ SError signal: aString
]

{ #category : #transformations }
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

{ #category : #accessing }
SSTestCase >> fitness [ 	
	^ fitness
]

{ #category : #running }
SSTestCase >> generateAssertions [
	^ self generateAssertions: {SComparisonAssertion . SInspectorAssertion . SPrimitiveAssertion . SStringAssertion}.
]

{ #category : #running }
SSTestCase >> generateAssertions: classAssertions [
	"
	it analyze each kind of assertion an generate a set of assertion based on the test case -- double dispatch
	"
	|executionContext|
	executionContext := self analyze.
	assertions := classAssertions flatCollect:[ :assertion | assertion for: executionContext.].
]

{ #category : #running }
SSTestCase >> generateStatements [

	self assert: typeInfo types isNotEmpty 
			description: 'TypeInfo does not contain info at all.'.
	
	[ self numberStatements < self numMaxStatements ]
		whileTrue: [ [self
				perform:
					#(#addFactoryMessage #addFieldAccessMessage #addMessage #addLiteral)
						shuffle anyOne] on: SError do: [  ] ]
]

{ #category : #comparing }
SSTestCase >> hash [
	^ self statements hash
]

{ #category : #initialization }
SSTestCase >> initialize [
	statements := OrderedCollection new.
	assertions := OrderedCollection new.
	nextId := 0.
	numMaxStatements := 0.
	fitness := Dictionary new
]

{ #category : #inserting }
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

{ #category : #inserting }
SSTestCase >> insertExpression: aExpression after: aStatement [
	^ self
		addStatement: (self newAssignment: aExpression)
		after: aStatement
]

{ #category : #inserting }
SSTestCase >> insertRandomStatement [
	#(#insertRandomMessage:using: #insertMethodMessage:using: #insertAsParameter:using:)
		shuffle
		do: [ :selector | 
			[ ^ self insertStatementOfSelector: selector ]
				on: SError
				do: [  ] ]
]

{ #category : #inserting }
SSTestCase >> insertStatement [
	| l stop alpha count random |
	statements ifEmpty: [ ^ #() ].
	l := 1.
	count := 0.
	stop := self numberStatements.
	alpha := 0.5.
	random := Random new seed: DateAndTime current nanoSecond / 100.
	[ l < stop and: [ random next <= (alpha raisedTo: count) ] ]
		whileTrue: [ self insertRandomStatement.
			l := l + 1.
			count := count + 1 ]
]

{ #category : #inserting }
SSTestCase >> insertStatementOfSelector: selector [

	statements copy shuffle
		do: [ :stm | 
			[ ^ self perform: selector inStatement: stm ]
				on: SError
				do: [  ] ].
	self
		error: 'Cant insert statement of selector: ' , selector printString
]

{ #category : #transformations }
SSTestCase >> literal: aClassName [
	| literal |
	literal := self newLiteral: aClassName.
	literal value
		ifNil: [ self error: 'error to create literal' ]
		ifNotNil: [ ^ literal ]
]

{ #category : #transformations }
SSTestCase >> messageUsing: method and: receiver before: aStatement [
	self buildArgs: method argTypes before: aStatement.
	^ SMessage
		newFromReceiver: receiver copy
		method: method
		andPreviousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
]

{ #category : #transformations }
SSTestCase >> messagesVariablesFrom: aClassName [
	|varExpressions|
	varExpressions := self
		messagesVariablesWhichContain: aClassName
		before: nil.
	varExpressions ifEmpty: [ 
		typeInfo classes at: aClassName ifPresent: [ (typeInfo classes at: aClassName) subclasses detect: [ :aClass | 
			varExpressions := self messagesVariablesWhichContain: aClass name before: nil.
			varExpressions isNotEmpty ] ] ifAbsent: [ 
		typeInfo scalars at: aClassName ifPresent: [ 
				varExpressions := self messagesVariablesWhichContain: aClassName before: nil.
			varExpressions isNotEmpty ] ].
		 ].
	^ varExpressions
]

{ #category : #querying }
SSTestCase >> messagesVariablesWhichContain: aClassName before: aStatement [
	^ (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
		select: [ :stm | stm referenceTo: aClassName ]
		thenCollect: [ :stm | stm variable ]
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
		value: anExpression copy
]

{ #category : #'instance creation' }
SSTestCase >> newFactoryMessage: aClassName before: aStatement [
	^ typeInfo types
		at: aClassName
		ifPresent: [ | methods |
			methods := typeInfo factoryMessagesFrom: aClassName.
			methods
				ifEmpty: [ SFactoryMessage default: aClassName ]
				ifNotEmpty: [ self newFactoryMessageUsing: methods and: aStatement ] ]
		ifAbsent: [ self error: 'error factoryMessage' ]
]

{ #category : #'instance creation' }
SSTestCase >> newFactoryMessageUsing: methods and: aStatement [
	methods shuffle
		do: [ :method | 
			[ ^ self factoryMessageUsing: method before: aStatement]
				on: SError
				do: [  ] ].
	self error: 'error factoryMessage'
]

{ #category : #'instance creation' }
SSTestCase >> newFieldAccessMessageOfType: aType andReceiver: receiver [
	^ (self pickAccessorsOf: receiver returnType)
		detect: [ :aMethod | aMethod returnType = aType ]
		ifFound:
			[ :aMethod | SFieldAccessMessage newFromReceiver: receiver copy andMethod: aMethod ]
		ifNone: [ self error: 'cant create field access of type: ' , aType asString ]
]

{ #category : #'instance creation' }
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
		ifAbsent: [ self error: 'scalars dont contain: ' , aClassName asString ].
	^ SLiteral new
		returnType: aClassName;
		value: aObject
]

{ #category : #'instance creation' }
SSTestCase >> newMessageOfType: aType before: aStatement [
	(self factoryMessageVariablesBefore: aStatement)
		do: [ :receiver | 
			[ ^ self newMessageOfType: aType using: receiver before: aStatement ]
				on: SError
				do: [  ] ].
	^self error: 'cant create message of type: ' , aType asString
]

{ #category : #'instance creation' }
SSTestCase >> newMessageOfType: aType using: receiver before: aStatement [
	(self pickMessagesOf: receiver returnType)
		detect: [ :aMethod | aMethod returnType = aType ]
		ifFound: [ :aMethod | 
			[ ^ self messageUsing: aMethod and: receiver before: aStatement ]
				on: SError
				do: [  ] ].
	^ self error: 'error to create message'
]

{ #category : #transformations }
SSTestCase >> newStatementOfType: aType before: aStatement [
	#(#newFactoryMessage:before: #newLiteral: #newFieldAccessMessageOfType:before: #newMessageOfType:before:)
		shuffle
		do: [ :message | 
			[ ^ self
				perform: message
				withEnoughArguments:
					(Array with: aType with:
					aStatement) ]
				on: SError
				do: [ "try with the next one" ] ].
	^ self
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

{ #category : #testing }
SSTestCase >> parseTree [
	
	^ self parseTreeWith: self statements.
]

{ #category : #testing }
SSTestCase >> parseTreeWith: statementCollection [
	| node temporaries |
	node := RBParser parseExpression: '[]'.
	temporaries := self allVarNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	statementCollection do: [ :stm | node body addNode: (RBParser parseExpression: stm printString) ].
	^ node
]

{ #category : #testing }
SSTestCase >> parseTreeWithAssertions [
	
	^ self parseTreeWith: self statements, self assertions.
]

{ #category : #transformations }
SSTestCase >> perform: selector inStatement: stm [
	^ stm
		perform: selector
		withArguments:
			(Array with: stm copy with:
			self)
]

{ #category : #querying }
SSTestCase >> pickAccessorsOf: aType [
^ typeInfo accessMessagesFrom: aType.
]

{ #category : #querying }
SSTestCase >> pickAnObjectVariable [
	
	(self factoryMessageVariablesBefore: nil)
		ifEmpty: [ self addFactoryMessage ].
	^ (self factoryMessageVariablesBefore: nil) shuffle anyOne
]

{ #category : #querying }
SSTestCase >> pickMessagesOf: aType [
	^ typeInfo messagesFrom: aType
]

{ #category : #querying }
SSTestCase >> pickObjectVariableOf: aClassName [
	(self subStatementsFrom: 1 toPrevIndexOf: nil) copy shuffle
		detect: [ :stm | stm returnType = aClassName ]
		ifFound: [ :stm | 
			^ stm reference ]
		ifNone: [  ].
	self error: 'Dont exist a statement of class: ' , aClassName
]

{ #category : #querying }
SSTestCase >> pickOrCreateObjectVariableOf: aClassName [
	^ [ self pickObjectVariableOf: aClassName ]
		on: SError
		do: [ (self addFactoryMessage: aClassName) variable ]
]

{ #category : #transformations }
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

{ #category : #inserting }
SSTestCase >> randomStatement [
	^ statements at: (1 to: self numberStatements ) atRandom
	
]

{ #category : #transformations }
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
SSTestCase >> removeStatementNoRepairing: aStatement [
	"remove all statements that reference to statement because this cant be fixed"

	| stmToRemove |
	stmToRemove := self statementAt: aStatement.
	statements remove: stmToRemove.
	(statements copy
		flatCollect: [ :stm | (stm pickUpReferences: stmToRemove) ifEmpty: [ #() ] ifNotEmpty: [ Array with: stm ] ])
		do: [ :stm | self removeStatementNoRepairing: stm ]
]

{ #category : #removing }
SSTestCase >> removeStatementOfVarName: varName [
	^ self removeStatement: (self statementOfVarName: varName) copy
]

{ #category : #repairing }
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

{ #category : #repairing }
SSTestCase >> repairParameters: expressions of: aStatement [
	|exprsToDelete|
	exprsToDelete := OrderedCollection new.
	expressions
		do: [ :expr | [self repairExpression: expr before: aStatement] on: SError do: [ exprsToDelete add: expr. ] ].
		^ exprsToDelete 
]

{ #category : #running }
SSTestCase >> run [
	" we delegate the responsibility to a test runner, in the future we would like to add new ways to run the tests "
	^ SSTestRunner new run: self.
]

{ #category : #transformations }
SSTestCase >> satisfyTypes: types before: aStatement [
	| scalarsKeys scalarTypes nonScalarTypes |
	scalarsKeys := typeInfo scalars keys.
	scalarTypes := OrderedCollection new.
	nonScalarTypes := OrderedCollection new.
	types do: [ :aType | (scalarsKeys includes: aType) ifTrue: [ scalarTypes add: aType ] ifFalse: [ nonScalarTypes add: aType ]  ].
	nonScalarTypes
		do: [ :aType | self addStatementOfType: aType before: aStatement ].
	^ scalarTypes
]

{ #category : #running }
SSTestCase >> setUp [
]

{ #category : #accessing }
SSTestCase >> statementAt: statement [
	^ statements
		detect: [ :stm | stm = statement ]
		ifNone: [ self error: 'statement not found' ]
]

{ #category : #accessing }
SSTestCase >> statementOfVarName: aString [
	^ statements
		detect: [ :stm | stm reference printString = aString ]
		ifNone: [ self error: 'Not found statement of varName: ' , aString ]
]

{ #category : #accessing }
SSTestCase >> statements [
	^ statements
]

{ #category : #transformations }
SSTestCase >> statementsOfType: aType before: aExpression [
	(statements includes: aExpression)
		ifFalse: [ self error: 'not found statement' ].
	^ (self subStatementsFrom: 1 toPrevIndexOf: aExpression)
		select: [ :stm | stm returnType = aType ]
]

{ #category : #transformations }
SSTestCase >> subStatementsFrom: start toPrevIndexOf: aStatement [
	|stop|
	stop := statements indexOf: aStatement.
	stop = 0
		ifTrue: [ ^ statements ].
	( start <= stop )
		ifFalse: [ ^ self error: 'Data must be in range' ].
	^ statements copyFrom: start to: stop - 1.
]

{ #category : #running }
SSTestCase >> tearDown [ 
]

{ #category : #accessing }
SSTestCase >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SSTestCase >> typeInfo: anObject [
	typeInfo := anObject
]

{ #category : #transformations }
SSTestCase >> updateNextId [ 
	nextId = 0 ifTrue: [ nextId := statements size ]
]

{ #category : #accessing }
SSTestCase >> validReferences [
	| references |
	references := Set new.
	^ statements
		detect: [ :stm | 
			| variables |
			variables := stm variablesWithId.
			references add: stm reference.
			(references includesAll: variables)
				ifFalse: [ 
					true ]
				ifTrue: [ references addAll: variables.
					false ] ]
		ifFound: [ false ]
		ifNone: [ true ]
]
