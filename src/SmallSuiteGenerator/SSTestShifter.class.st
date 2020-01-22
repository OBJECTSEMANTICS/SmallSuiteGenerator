"
SSTestShifter is responsible for creating, mutating and validating statements. It is responsible to for creating different kind of statements: primitive, factory messages, messages, accessor messages.

Genetic algorithm's evolution depends this class' increasing fitness. For this reason it is one of the main classes and essential for the project.

Instance Variables
	assertions:						<OrderedCollection>
	fitness:							<Dictionary>
	fitnessByClass:					<Dictionary>
	maxNumberOfStatements:		<SmallInteger>
	nextId:							<SmallInteger>
	randomGenerator:				<SRandomGenerator>
	statements:						<OrderedCollection>
	targetClassesNames:			<Set>
	typeInfo:							<STypeInfo>
	validatedTargetClassName:	<Boolean>
"
Class {
	#name : #SSTestShifter,
	#superclass : #SObject,
	#instVars : [
		'statements',
		'assertions',
		'typeInfo',
		'nextId',
		'fitness',
		'targetClassesNames',
		'maxNumberOfStatements',
		'validatedTargetClassName',
		'randomGenerator',
		'fitnessByClass'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #adding }
SSTestShifter >> addArgument: arg before: aStatement considering: prevTypes and: scalarNames [
	| res |
	res := arg types anySatisfy: [ :type | prevTypes includes: type ].
	res
		ifFalse: [ (randomGenerator collectAtRandom: arg types)
				detect: [ :missType | 
					[ (scalarNames includes: missType)
						ifTrue: [ self
								addStatement: (self newAssignment: (self newLiteral: missType))
								before: aStatement ]
						ifFalse: [ self
								addAssignment: (self newFactoryMessage: missType before: aStatement) ].
					true ]
						on: SError
						do: [ false ] ]
				ifNone: [ self
						error: 'It is not possible to meet the arguments of this method call' ] ]
]

{ #category : #inserting }
SSTestShifter >> addAssignment: anExpression [
	|assignment|
	assignment := self newAssignment: anExpression.
	self addStatement: assignment.
	^ assignment
]

{ #category : #inserting }
SSTestShifter >> addFactoryMessage [
	| variables |
	variables := self objectVariables.
	variables
		ifEmpty: [ (randomGenerator collectAtRandom: typeInfo noneAbstractClasses)
				do: [ :aClass | 
					[ ^ self addFactoryMessage: aClass name ]
						on: SError
						do: [  ] ].
			self error: 'Cannot create a factoryMessage.' ]
		ifNotEmpty: [ ^ self addFactoryMessage: (randomGenerator selectAtRandom: variables) returnType ]
]

{ #category : #inserting }
SSTestShifter >> addFactoryMessage: symbol [
	^ self addAssignment: (self newFactoryMessage: symbol before: nil)
]

{ #category : #inserting }
SSTestShifter >> addFactoryMessage: aClassName ofSelector: aSelector [
	^ [ self
		addAssignment:
			(self
				factoryMessageUsing: (typeInfo classMethodType: aSelector from: aClassName)
				before: nil) ]
		on: SError
		do: [ self addFactoryMessage: aClassName ]
]

{ #category : #inserting }
SSTestShifter >> addFieldAccessMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickAccessorsOf: receiver returnType.
	methods
		ifNotEmpty: [ ^ self
				addFieldAccessMessage: (randomGenerator selectAtRandom: methods)
				withReceiver: receiver ].
	self error: 'Cannot create a field access message.'
]

{ #category : #inserting }
SSTestShifter >> addFieldAccessMessage: aSelector from: aClassName [
	| receiver anAccessor |
	anAccessor := (self pickAccessorsOf: aClassName)
		detect: [ :accessor | accessor selector = aSelector ]
		ifNone: [ nil ].
	anAccessor
		ifNil: [ self
				error:
					'None field access message of selector: ' , aSelector
						, ' matches with: ' , aClassName ].
	receiver := self pickOrCreateObjectVariableOf: aClassName.
	^ self addFieldAccessMessage: anAccessor withReceiver: receiver
]

{ #category : #inserting }
SSTestShifter >> addFieldAccessMessage: method withReceiver: receiver [
	^ self
		addAssignment: (SFieldAccessMessage newFromReceiver: receiver copy andMethod: method)
]

{ #category : #inserting }
SSTestShifter >> addLiteral [
	^ self addLiteral: self randomLiteralClassName
]

{ #category : #inserting }
SSTestShifter >> addLiteral: aClassName [
	
	^ self addAssignment: (self newLiteral: aClassName)
]

{ #category : #inserting }
SSTestShifter >> addMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickMessagesOf: receiver returnType.
	methods
		ifEmpty: [ self
				error: 'There are no method typeInfos for: ' , receiver returnType , '.' ]
		ifNotEmpty: [ ^ self addMessage: (randomGenerator selectAtRandom: methods) withReceiver: receiver ]
]

{ #category : #inserting }
SSTestShifter >> addMessage: aSelector from: aClassName [
	| receiver aMethod |
	aMethod := (self pickMessagesOf: aClassName)
		, (typeInfo factoryMessagesFrom: aClassName)
		detect: [ :aMessage | aMessage selector = aSelector ]
		ifNone: [ nil ].
	aMethod
		ifNil: [ self
				error:
					'None message of selector: ' , aSelector
						, ' matches with: ' , aClassName ].
	receiver := self pickOrCreateObjectVariableOf: aClassName.
	^ self addMessage: aMethod withReceiver: receiver
]

{ #category : #inserting }
SSTestShifter >> addMessage: method withReceiver: receiver [
	^ self addAssignment: (self messageUsing: method and: receiver before: nil)
]

{ #category : #inserting }
SSTestShifter >> addStatement: anExpression [
	statements add: anExpression.
]

{ #category : #inserting }
SSTestShifter >> addStatement: newExpression after: aStatement [
	| anIndex |
	anIndex := statements indexOf: aStatement.
	anIndex = 0
		ifTrue: [ self addStatement: newExpression ]
		ifFalse: [ anIndex := randomGenerator selectAtRandom: (anIndex to: self numberStatements).
			statements add: newExpression afterIndex: anIndex ].
	^ newExpression
]

{ #category : #inserting }
SSTestShifter >> addStatement: newExpression before: aStatement [
	"I add a newExpression before aStatement"
	statements
		add: newExpression
		afterIndex: (self randomIndexToAdd: newExpression before: aStatement)
]

{ #category : #inserting }
SSTestShifter >> addStatementOfType: aType before: expression [
	| newExpression |
	newExpression := self
		newAssignment: (self newStatementOfType: aType before: expression).
	self addStatement: newExpression before: expression.
	^ newExpression
]

{ #category : #inserting }
SSTestShifter >> addStatements: collStatements [
	self
		assert: statements isEmpty
		description: 'statements must be empty'.
	statements addAll: collStatements
]

{ #category : #adding }
SSTestShifter >> addTargetClassName: aSymbol [
	typeInfo types at: aSymbol ifAbsent: [ self error: 'Class name: ', aSymbol, ' is not found in typeInfo' ].
	targetClassesNames add: aSymbol
]

{ #category : #adding }
SSTestShifter >> addTargetClassNames: symbols [
	symbols do: [ :symbol | self addTargetClassName: symbol ]
]

{ #category : #accessing }
SSTestShifter >> allVarNames [
	^ statements collect: [ :stm | stm reference printString ]
]

{ #category : #repairing }
SSTestShifter >> alternativeFactoryMessage: aFactoryMessage before: aExpression [
	| returnType |
	returnType := aFactoryMessage returnType.
	^ (typeInfo factoryMessagesFrom: returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aFactoryMessage selector ] ]
		ifFound: [ :meth | self factoryMessageUsing: meth before: aExpression ]
		ifNone: [ SFactoryMessage default: returnType ]
]

{ #category : #repairing }
SSTestShifter >> alternativeFieldAccessMessage: aFieldAccessMessage [
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
			'There is no alternative for fieldAccessMessage of selector: '
				, aFieldAccessMessage selector
]

{ #category : #repairing }
SSTestShifter >> alternativeMessage: aMessage before: expression [
	| returnType receiver |
	receiver := aMessage receiver.
	returnType := aMessage returnType.
	(self pickMessagesOf: receiver returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aMessage selector ] ]
		ifFound:
			[ :meth | ^ self messageUsing: meth and: receiver before: expression ].
	self
		error:
			'There is no alternative for message of selector: '
				, aMessage selector
]

{ #category : #repairing }
SSTestShifter >> alternativeOfVariable: aVariable before: aExpression [
	| returnType |
	
	self statementOfVarName: aVariable printString.
	returnType := aVariable returnType.
	(self statementsOfType: returnType before: aExpression)
		detect: [ :stm | stm reference ~= aVariable ]
		ifFound: [ :stm | ^ stm reference ].
	^ (self addStatementOfType: returnType before: aExpression) reference
]

{ #category : #accessing }
SSTestShifter >> assertions [
	^ assertions
]

{ #category : #accessing }
SSTestShifter >> assignId [
	| idToAssign assignedIds |
	assignedIds := self assignedIds.
	[ assignedIds includes: nextId ] whileTrue: [ nextId := nextId + 1 ].
	idToAssign := nextId.
	nextId := nextId + 1.
	^ idToAssign
]

{ #category : #accessing }
SSTestShifter >> assignedIds [
	^ statements collect: #id
]

{ #category : #repairing }
SSTestShifter >> buildArgs: argTypes before: aStatement [
	argTypes
		ifNotNil: [ | prevTypes scalarsKeys |
			prevTypes := (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
				collect: #returnType
				thenSelect: [ :aType | aType isNil not ].
			scalarsKeys := typeInfo scalars keys asOrderedCollection .
			argTypes
				do: [ :arg | 
					self
						addArgument: arg
						before: aStatement
						considering: prevTypes
						and: scalarsKeys ] ]
]

{ #category : #modifying }
SSTestShifter >> changeMessageNotUnderstood: aSelector from: aClassName [
	^ false
]

{ #category : #modifying }
SSTestShifter >> changeStatement [
	(randomGenerator collectAtRandom: statements)
		do: [ :stm | 
			[ ^ self changeStatement: stm ]
				on: SError
				do: [  ] ]
]

{ #category : #modifying }
SSTestShifter >> changeStatement: aStatement [
	| statementChanged |
	statementChanged := aStatement copy
		repairOn: self
		changing: aStatement.
	(self statementAt: aStatement) replaceBy: statementChanged.
	^ statementChanged
]

{ #category : #modifying }
SSTestShifter >> changeStatementOfClassName: aClassName [
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
SSTestShifter >> changeStatementOfVarName: varName [
	^ self changeStatement: (self statementOfVarName: varName)
]

{ #category : #accessing }
SSTestShifter >> defaultNumberStatements [
	^ 54
]

{ #category : #repairing }
SSTestShifter >> error: string [
	
	^ SError signal: string 
]

{ #category : #repairing }
SSTestShifter >> factoryMessageUsing: method before: aStatement [
	self buildArgs: method argTypes before: aStatement.
	^ SFactoryMessage
		method: method
		previousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
]

{ #category : #querying }
SSTestShifter >> factoryMessageVariablesBefore: aStatement [
	^ (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
		select: [ :stm | stm value isFactoryMessage ]
		thenCollect: [ :stm | stm variable ]
]

{ #category : #accessing }
SSTestShifter >> fitness [ 	
	^ fitness
]

{ #category : #accessing }
SSTestShifter >> fitnessByClass [
	^ fitnessByClass 
]

{ #category : #actions }
SSTestShifter >> generateAssertions [
	^ self
		generateAssertions:
			(Array with: SComparisonAssertion
			with: SInspectorAssertion
			with: SPrimitiveAssertion
			with: SStringAssertion)
]

{ #category : #actions }
SSTestShifter >> generateAssertions: classAssertions [
	"
	it analyze each kind of assertion an generate a set of assertion based on the test case -- double dispatch
	"

	| executionContext |
	executionContext := self analyze.
	assertions := classAssertions
		flatCollect: [ :assertion | assertion for: executionContext ]
]

{ #category : #actions }
SSTestShifter >> generateStatements [
	self
		assert: typeInfo types isNotEmpty
		description: 'TypeInfo does not contain info at all.'.
	[ self numberStatements < self maxNumberOfStatements ]
		whileTrue: [ "self addMessage" [ self addMessage ]
				on: SError
				do: [  ] ]
]

{ #category : #actions }
SSTestShifter >> generateStatements: anInteger [
	self maxNumberOfStatements: anInteger.
	self generateStatements.
	
]

{ #category : #initalize }
SSTestShifter >> initialize [
	super initialize.
	statements := OrderedCollection new.
	assertions := OrderedCollection new.
	fitness := Dictionary new.
	fitnessByClass := Dictionary new.
	nextId := 0.
	maxNumberOfStatements := 10.
	targetClassesNames := Set new.
	validatedTargetClassName := false.
	randomGenerator := SConfiguration newRandomGenerator
]

{ #category : #inserting }
SSTestShifter >> insertAsParameter: expression after: aStatement [
	(randomGenerator collectAtRandom: (statements
		copyFrom: (statements indexOf: aStatement) + 1
		to: self numberStatements))
		do: [ :stm | 
			[ ^ stm replaceArgBy: expression ]
				on: SError
				do: [  ] ].
	self
		error: 'Cannot insert any parameter by: ' , expression printString
]

{ #category : #inserting }
SSTestShifter >> insertExpression: expression after: aStatement [
	^ self
		addStatement: (self newAssignment: expression)
		after: aStatement
]

{ #category : #inserting }
SSTestShifter >> insertExpressionRandomly [
	(randomGenerator collectAtRandom: #(#insertRandomMessage:using: #insertMethodMessage:using: #insertAsParameter:using:))
		do: [ :selector | 
			[ ^ self insertStatementOfSelector: selector ]
				on: SError
				do: [  ] ]
]

{ #category : #inserting }
SSTestShifter >> insertStatement [
	| l stop alpha count random |
	l := 1.
	count := 0.
	stop := self numberStatements.
	alpha := 0.5.
	random := SConfiguration randomGenerator.
	[ l < stop and: [ random next <= (alpha raisedTo: count) ] ]
		whileTrue: [ self insertExpressionRandomly.
			l := l + 1.
			count := count + 1 ]
]

{ #category : #inserting }
SSTestShifter >> insertStatementOfSelector: selector [
	(randomGenerator collectAtRandom: statements copy)
		do: [ :stm | 
			[ ^ self perform: selector inStatement: stm ]
				on: SError
				do: [  ] ].
	self
		error: 'Cannot insert statement of selector: ' , selector printString
]

{ #category : #repairing }
SSTestShifter >> invariant [
	self typeInfo
		ifNil: [ self
				error: 'TypeInfo is nil. Set the testCase with a typeInfo' ]
]

{ #category : #querying }
SSTestShifter >> involvedClasses [
	
	^ (self objectVariables collect:[:var| var returnType]) asSet.
]

{ #category : #repairing }
SSTestShifter >> literal: aClassName [
	^  self newLiteral: aClassName.
	
]

{ #category : #accessing }
SSTestShifter >> maxNumberOfStatements [
	^ maxNumberOfStatements
]

{ #category : #accessing }
SSTestShifter >> maxNumberOfStatements: anObject [
	maxNumberOfStatements := anObject
]

{ #category : #repairing }
SSTestShifter >> messageUsing: method and: receiver before: aStatement [
	self buildArgs: method argTypes before: aStatement.
	^ SMessage
		newFromReceiver: receiver copy
		method: method
		andPreviousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
]

{ #category : #repairing }
SSTestShifter >> messagesVariablesFrom: aClassName [
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
SSTestShifter >> messagesVariablesWhichContain: aClassName before: aStatement [
	^ (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
		select: [ :stm | stm referenceTo: aClassName ]
		thenCollect: [ :stm | stm variable ]
]

{ #category : #'instance creation' }
SSTestShifter >> newAssignment: anExpression [
	[ ^ SAssignment
		name:
			(SVariable new
				varName: '_var';
				id: self assignId;
				returnType: anExpression returnType;
				yourself)
		value: anExpression copy ]
		on: MessageNotUnderstood
		do: [ :error | 
			self
				error: anExpression printString , ' is not an expression.' ]
]

{ #category : #'instance creation' }
SSTestShifter >> newFactoryMessage: aClassName before: aStatement [
	| methods |
	typeInfo
		classAt: aClassName
		ifNone: [ self
				error:
					'Error to create factoryMessage of: ' , aClassName
						, ' because it is not found in typeInfo.' ].
	self validTargetClassName: aClassName.
	methods := typeInfo factoryMessagesFrom: aClassName.
	^ methods
		ifEmpty: [ SFactoryMessage default: aClassName ]
		ifNotEmpty: [  self newFactoryMessageUsing: aClassName and: aStatement ]
]

{ #category : #'instance creation' }
SSTestShifter >> newFactoryMessageUsing: aClassName and: aStatement [
	| methods |
	methods := typeInfo factoryMessagesFrom: aClassName.
	(randomGenerator collectAtRandom: methods)
		do: [ :method | 
			[ self buildArgs: method argTypes before: aStatement.
			^ SFactoryMessage
				method: method
				class: aClassName
				previousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement) ]
				on: SError
				do: [  ] ].
	self error: 'Error to create a factoryMessage of: ' , aClassName
]

{ #category : #'instance creation' }
SSTestShifter >> newFieldAccessMessageOfType: aType andReceiver: receiver [
	(self pickAccessorsOf: receiver returnType)
		detect: [ :aMethod | aMethod returnType includes: aType ]
		ifFound: [ :aMethod | 
			^ SFieldAccessMessage
				newFromReceiver: receiver copy
				andMethod: aMethod ]
		ifNone:
			[ self error: 'Cannot create a field access message of type: ' , aType, ' and receiver of type: ', receiver returnType ]
]

{ #category : #'instance creation' }
SSTestShifter >> newFieldAccessMessageOfType: aType before: aStatement [
	(self factoryMessageVariablesBefore: aStatement)
		do: [ :receiver | 
			[ ^ self newFieldAccessMessageOfType: aType andReceiver: receiver ]
				on: SError
				do: [  ] ].
	self error: 'Cannot create a field access message of type: ' , aType
]

{ #category : #'instance creation' }
SSTestShifter >> newLiteral: aClassName [
	typeInfo scalars
		at: aClassName
		ifPresent: [ :values | 
			values
				ifEmpty: [ self error: 'Scalar of type: ' , aClassName , ' is empty.' ].
			(aClassName includesAll: 'BlockClosure') ifTrue: [ self error: 'Can not create a literal of BlockClosure' ].
			^ SLiteral new
				returnType: aClassName;
				value: (randomGenerator selectAtRandom: values asOrderedCollection) ].
	self error: 'Scalars dont include: ' , aClassName
]

{ #category : #'instance creation' }
SSTestShifter >> newMessageOfType: aType before: aStatement [
	(self factoryMessageVariablesBefore: aStatement)
		do: [ :receiver | 
			[ ^ self newMessageOfType: aType using: receiver before: aStatement ]
				on: SError
				do: [  ] ].
	self
		error:
			'Cannot create a message of type: ' , aType printString
				,
					'. A possible reason is because there is none factoryMessage which has a message of this return type.'
]

{ #category : #'instance creation' }
SSTestShifter >> newMessageOfType: aType using: receiver before: aStatement [
	(self pickMessagesOf: receiver returnType)
		detect: [ :aMethod | aMethod returnType includes: aType ]
		ifFound: [ :aMethod | 
			[ ^ self messageUsing: aMethod and: receiver before: aStatement ]
				on: SError
				do: [  ] ].
	^ self
		error:
			'Error to create a message of type: ' , aType
				, ' with receiver of type: ' , receiver returnType
]

{ #category : #repairing }
SSTestShifter >> newStatementOfType: aType before: aStatement [
	(randomGenerator collectAtRandom: #(#newFactoryMessage:before: #newLiteral: #newFieldAccessMessageOfType:before: #newMessageOfType:before:))
		do: [ :message | 
			[ ^ self
				perform: message
				withEnoughArguments: (Array with: aType with: aStatement) ]
				on: SError
				do: [ "try with the next one" ] ].
	self error: 'Cannot create expression of returnType: ' , aType
]

{ #category : #accessing }
SSTestShifter >> numMaxStatements [
	^ maxNumberOfStatements
]

{ #category : #accessing }
SSTestShifter >> numMaxStatements: anObject [
	maxNumberOfStatements := anObject
]

{ #category : #accessing }
SSTestShifter >> numberStatements [
	^ statements size
]

{ #category : #querying }
SSTestShifter >> objectVariables [
	
	^ statements select:[:stm| 
			|res|
			res := self typeInfo classAt: stm returnType ifNone:[nil].
			res isNil not] thenCollect:[:stm| stm variable].
]

{ #category : #parsing }
SSTestShifter >> parseTree [
	
	^ self parseTreeWith: self statements.
]

{ #category : #parsing }
SSTestShifter >> parseTreeWith: statementCollection [
	| node temporaries rbParserClass |
	statementCollection ifEmpty: [ self error: 'testCase does not have statements' ].
	rbParserClass := SConfiguration rbParserClass.
	node := rbParserClass parseExpression: '[]'.
	temporaries := self allVarNames
		collect: [ :varName | rbParserClass parseExpression: varName ].
	node body temporaries: temporaries.
	statementCollection
		do: [ :stm | 
			| aNode |
			[ aNode := rbParserClass parseExpression: stm printString.
			node body addNode: aNode ]
				on: Error
				do: [  ] ].
	^ node
]

{ #category : #parsing }
SSTestShifter >> parseTreeWithAssertions [
	
	^ self parseTreeWith: self statements, self assertions.
]

{ #category : #repairing }
SSTestShifter >> perform: selector inStatement: stm [
	^ stm
		perform: selector
		withArguments:
			(Array with: stm copy with:
			self)
]

{ #category : #querying }
SSTestShifter >> pickAccessorsOf: aType [
	^ typeInfo accessMessagesFrom: aType
]

{ #category : #querying }
SSTestShifter >> pickAnObjectVariable [
	| variables |
	variables := self objectVariables.
	variables
		ifEmpty: [ self addFactoryMessage.
			variables := self objectVariables ].
	^ randomGenerator selectAtRandom: variables
]

{ #category : #querying }
SSTestShifter >> pickMessagesOf: aType [
	^ typeInfo messagesFrom: aType
]

{ #category : #querying }
SSTestShifter >> pickObjectVariableOf: aClassName [
	(randomGenerator collectAtRandom: (self subStatementsFrom: 1 toPrevIndexOf: nil))
		detect: [ :stm | stm returnType = aClassName ]
		ifFound: [ :stm | ^ stm reference ]
		ifNone: [  ].
	self error: 'Does not exist a statement of type: ' , aClassName
]

{ #category : #querying }
SSTestShifter >> pickOrCreateObjectVariableOf: aClassName [
	^ [ self pickObjectVariableOf: aClassName ]
		on: SError
		do: [ (self addFactoryMessage: aClassName) variable ]
]

{ #category : #printing }
SSTestShifter >> printDescriptiveComment [
	^ self printSummaryFitness , (String with: Character cr)
		, self printSummaryFitnessByClass
]

{ #category : #printing }
SSTestShifter >> printFunctionByClassName: dict on: stream [
	(dict associations select: [ :assoc | assoc value > 0 ])
		do: [ :assoc | 
			stream
				nextPutAll: assoc key;
				nextPut: $:;
				nextPutAll: assoc value printString;
				nextPut: $%;
				nextPutAll: (String with: Character cr) ]
]

{ #category : #printing }
SSTestShifter >> printStatements [
	^ statements collect: #printString
]

{ #category : #printing }
SSTestShifter >> printSummaryFitness [
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: '"Fitness: ';
				nextPut: Character cr.
			fitness
				associationsDo: [ :assoc | 
					stream
						nextPutAll: assoc key;
						nextPutAll: ': ';
						nextPutAll: assoc value printString;
						nextPut: Character cr ].
			stream
				nextPutAll: '"' ]
]

{ #category : #printing }
SSTestShifter >> printSummaryFitnessByClass [
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: '"This test covers: ';
				nextPut: Character cr.
			fitnessByClass
				associationsDo: [ :assoc | 
					stream
						nextPutAll: assoc key;
						nextPutAll: (String with: Character cr).
					self printFunctionByClassName: assoc value on: stream ].
			stream
				nextPutAll: '"';
				nextPutAll: (String with: Character cr) ]
]

{ #category : #accessing }
SSTestShifter >> randomGenerator: anObject [
	randomGenerator := anObject
]

{ #category : #repairing }
SSTestShifter >> randomIndexToAdd: aExpression before: aStatement [
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
			^ randomGenerator selectAtRandom: (ini to: end) ].
	anIndex = 0
		ifTrue: [ ^ anIndex ].
	^ randomGenerator selectAtRandom: (1 to: anIndex)
]

{ #category : #inserting }
SSTestShifter >> randomLiteralClassName [
	^ [ randomGenerator selectAtRandom: typeInfo scalars keys asOrderedCollection  ]
		on: Error
		do: [ self
				error: 'TypeInfo does not have scalars. Set scalars on typeInfo.' ]
]

{ #category : #repairing }
SSTestShifter >> referencesIndexes: expression [
	^ ((expression variablesWithId ) allButFirst collect: [ :var | statements indexOf: (self statementOfVarName: var printString) ])
]

{ #category : #removing }
SSTestShifter >> removeExpression: expression [
	| exprsToRemove |
	self removeFromStatements: expression.
	exprsToRemove := self repair: expression.
	exprsToRemove do: [ :expr | self removeExpression: expr ]
]

{ #category : #removing }
SSTestShifter >> removeExpressionWithoutRepairing: expression [
	self removeFromStatements: expression.
	[ self statementAt: expression ]
		on: SError
		do: [ (self statements copy
				flatCollect: [ :stm | 
					(stm pickUpReferences: expression)
						ifNotEmpty: [ Array with: stm ] ])
				do: [ :stm | self removeExpressionWithoutRepairing: stm ] ]
]

{ #category : #removing }
SSTestShifter >> removeFromStatements: expression [
	[ statements remove: expression ]
		on: Error
		do: [ self error: expression printString , ' is not found.' ]
]

{ #category : #removing }
SSTestShifter >> removeStatement [
	"If other statements refer the statement to remove, then this reference is replaced with another value out of the set which has the same type"

	statements ifEmpty: [ ^ #() ].
	self
		removeStatement:
			(statements
				at: (randomGenerator selectAtRandom: (1 to: self numberStatements) asArray))
]

{ #category : #removing }
SSTestShifter >> removeStatement: anExpression [
	self removeExpression: (self statementAt: anExpression)
]

{ #category : #removing }
SSTestShifter >> removeStatementNoRepairing: aStatement [
	"remove all statements that reference to statement because this cant be fixed"

	self removeExpressionWithoutRepairing: (self statementAt: aStatement)
]

{ #category : #removing }
SSTestShifter >> removeStatementOfVarName: varName [
	^ self removeStatement: (self statementOfVarName: varName) copy
]

{ #category : #repairing }
SSTestShifter >> repair: expression [
	[ self statementAt: expression ]
		on: SError
		do: [ ^ self statements copy
				flatCollect: [ :stm | self repairReferenceTo: expression of: stm ] ].
	self
		error: expression printString , ' does not exist.'
]

{ #category : #inserting }
SSTestShifter >> repair: exprToReplace of: expression [
	| aType replacement |
	aType := exprToReplace returnType.
	replacement := (randomGenerator collectAtRandom:(self subStatementsFrom: 1 toPrevIndexOf: expression))
		detect:
			[ :stm | stm reference ~= exprToReplace and: [ stm returnType = aType ] ]
		ifNone: [ self addStatementOfType: aType before: expression ].
	self replace: exprToReplace by: replacement on: expression
]

{ #category : #repairing }
SSTestShifter >> repairReferenceTo: removedExpression of: expression [
	| references exprsToDelete |
	references := expression pickUpReferences: removedExpression.
	exprsToDelete := OrderedCollection new.
	references
		do: [ :reference | 
			[ self repair: reference of: expression ]
				on: SError
				do: [ exprsToDelete add: reference ] ].
	^ exprsToDelete
]

{ #category : #repairing }
SSTestShifter >> replace: exprToReplace by: otherExpression on: expression [
	(self statementAt: expression)
		replaceExpression: exprToReplace 
		by: otherExpression 
]

{ #category : #repairing }
SSTestShifter >> satisfyTypes: types before: aStatement [
	| scalarsKeys scalarTypes nonScalarTypes |
	scalarsKeys := typeInfo scalars keys asOrderedCollection .
	scalarTypes := OrderedCollection new.
	nonScalarTypes := OrderedCollection new.
	types
		do: [ :aType | 
			(scalarsKeys includes: aType)
				ifTrue: [ scalarTypes add: aType ]
				ifFalse: [ nonScalarTypes add: aType ] ].
	nonScalarTypes
		do: [ :aType | self addStatementOfType: aType before: aStatement ].
	^ scalarTypes
]

{ #category : #accessing }
SSTestShifter >> statementAt: statement [
	statements
		detect: [ :stm | stm = statement ]
		ifFound: [ :stm | ^ stm ].
	self
		error: 'Statement: ' , statement printString , ' is not found in testCase.'
]

{ #category : #accessing }
SSTestShifter >> statementOfVarName: aString [
	statements
		detect: [ :stm | stm reference printString = aString ]
		ifFound: [ :stm | ^ stm ].
	self error: 'Statement of varName: ' , aString, 'is not found.'
]

{ #category : #accessing }
SSTestShifter >> statements [
	^ statements
]

{ #category : #repairing }
SSTestShifter >> statementsOfType: aType before: expression [
	(statements includes: expression)
		ifFalse: [ self error: 'Statement: ', expression printString , 'is not found in testCase.' ].
	^ (self subStatementsFrom: 1 toPrevIndexOf: expression)
		select: [ :stm | stm returnType = aType ]
]

{ #category : #repairing }
SSTestShifter >> subStatementsFrom: start toPrevIndexOf: aStatement [
	| stop |
	stop := statements indexOf: aStatement.
	stop = 0
		ifTrue: [ ^ statements ].
	start <= stop
		ifFalse: [ ^ self error: start printString, ' (indexIni) is greater than ', stop printString, ' (indexPos).' ].
	^ statements copyFrom: start to: stop - 1
]

{ #category : #accessing }
SSTestShifter >> targetClassesNames [
	^ targetClassesNames 
]

{ #category : #accessing }
SSTestShifter >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
SSTestShifter >> typeInfo: anObject [
	typeInfo := anObject
]

{ #category : #repairing }
SSTestShifter >> updateNextId [ 
	nextId = 0 ifTrue: [ nextId := statements size ]
]

{ #category : #accessing }
SSTestShifter >> validReferences [
	| references |
	references := Set new.
	^ statements
		detect: [ :stm | 
			| variables |
			variables := stm variablesWithId asSet.
			references add: stm reference.
			(references includesAll: variables)
				ifFalse: [ true ]
				ifTrue: [ references addAll: variables.
					false ] ]
		ifFound: [ false ]
		ifNone: [ true ]
]

{ #category : #accessing }
SSTestShifter >> validTargetClassName: aClassName [
	(validatedTargetClassName
		and: [ (targetClassesNames includes: aClassName) not
				and: [ |classInfo|
					classInfo := typeInfo classAt: aClassName ifNone: [].
					classInfo isNil not and: [ classInfo allMethods isNotEmpty ] ] ])
		ifTrue: [ self addTargetClassName: aClassName ].
	((targetClassesNames includes: aClassName) not
		or: [ typeInfo isAbstractClass: aClassName ])
		ifTrue: [ self error: 'Class: ' , aClassName , ' is not able to be used.' ]
		ifFalse: [ validatedTargetClassName := true ]
]
