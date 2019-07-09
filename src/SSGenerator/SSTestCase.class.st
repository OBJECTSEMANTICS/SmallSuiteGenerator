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

{ #category : #'as yet unclassified' }
SSTestCase class >> withNumStatements: aNumber [
	aNumber > 0
		ifFalse: [ ^ self error: 'The number of statements must be greater than 0' ].
	^ self new numMaxStatements: aNumber
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
	^ self addAssignment: factory.
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
		addAssignment: (SFieldAccessMessage newFromReceiver: receiver andMethod: method)
]

{ #category : #adding }
SSTestCase >> addLiteral [
	typeInfo scalars ifEmpty: [ self error: 'scalars are not defined' ].
	self addLiteral: typeInfo scalars keys shuffle anyOne.
	
]

{ #category : #adding }
SSTestCase >> addLiteral: aClassName [
	| newLiteral |
	newLiteral := self newLiteral: aClassName.
	 self
				addAssignment:
					newLiteral 
]

{ #category : #adding }
SSTestCase >> addLiteral: aType at: aIndex [
	| newStatement |
	newStatement := self newAssignment: (self newLiteral: aType).
	newStatement ifNil: [ ^ nil ].
	statements
		add: newStatement
		afterIndex:
			(aIndex > 1
				ifTrue: [ aIndex - 1 ]
				ifFalse: [ 0 ]).
	^ newStatement
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
SSTestCase >> addMessage: aSelector from: aClass [
	| receiver aMethod |
	aMethod := (typeInfo classAt: aClass) methodOf: aSelector.
	aMethod isQuick
		ifTrue: [ ^ self error: 'the method must be a message, not accessor message' ].
	receiver := self pickOrCreateObjectVariableOf: aClass.
	^ self addMessage: aMethod withReceiver: receiver
]

{ #category : #actions }
SSTestCase >> addMessage: method withReceiver: receiver [
	self satisfyArgs: method.
	^ self
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
	^ SError new signal: aString 
]

{ #category : #querying }
SSTestCase >> factoryMessageVariables [
	^ statements
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

{ #category : #'instance creation' }
SSTestCase >> newLiteral: aClassName [
	|aObject|
	aObject := (typeInfo scalars at: aClassName) asArray shuffle anyOne.
	^ 
					(SLiteral new
						returnType: aClassName;
						value: aObject) 
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
	^ (typeInfo types at: aVariable returnType) accessMessages
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
SSTestCase >> pickOrCreateObjectVariableOf: aClass [
	^ [ self pickObjectVariableOf: aClass name ]
		on: SError
		do: [ (self addFactoryMessage: aClass) variable ]
]

{ #category : #removing }
SSTestCase >> removeStatement [
	"If other statements refer the statement to remove, then this reference is replaced with another value out of the set which has the same type"

	statements ifEmpty: [ ^ #() ].
	^ self
		removeStatement:
			(statements at: (1 to: self numberStatements) atRandom)
]

{ #category : #removing }
SSTestCase >> removeStatement: aStatement [
	| stmToRemove varNamesToRemove |
	stmToRemove := self statementAt: aStatement.
	stmToRemove
		ifNil: [ ^ self error: 'Dont exist a statement with this varName.' ].
	varNamesToRemove := statements copy
		flatCollect: [ :stm | 
			| references |
			references := stm references: stmToRemove. 
			stm repairHaving: (self updateReferences: references of: stm).
			].
	statements remove: stmToRemove.
	varNamesToRemove do: [ :aName | self removeStatement: aName ].
	^ {aStatement} , varNamesToRemove
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
SSTestCase >> statementAt: statement [
	^ statements
		detect: [ :stm | stm = statement ]
		ifFound: [ :stm | stm ]
		ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
SSTestCase >> statementOfType: aType before: anIndex [
	| candidates |
	candidates := (statements copyFrom: 1 to: anIndex - 1 ) select: [ :stm | stm returnType = aType ].
	^ candidates ifNotEmpty: [ candidates shuffle anyOne ] 
	ifEmpty: [ | position  |
		
		position := (1 to: anIndex -1 ) atRandom.
		^ self addLiteral: aType at: position.
		 ]
]

{ #category : #accessing }
SSTestCase >> statements [
	^ statements
]

{ #category : #'as yet unclassified' }
SSTestCase >> substituteArg: argToSubstitute of: aExpression [
	| statement indexStatement newArg |
	indexStatement := statements indexOf: aExpression.
	indexStatement <= 0
		ifTrue: [ ^ self error: 'Statements dont contain the expression' ].
	statement := statements at: indexStatement.
	newArg := self
		statementOfType: argToSubstitute returnType
		before: indexStatement.
	newArg ifNil: [ ^ false ].
	"statement updateArg: argToSubstitute by: newArg."
	^ true
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
SSTestCase >> updateReferences: references of: anExpression [
	| statement newReferences |
	statement := self statementAt: anExpression.
	newReferences := references.	"buscar nuevas referencias de la expression"
		"| candidates |
	candidates := (statements copyFrom: 1 to: anIndex - 1)
		select: [ :stm | stm returnType = aType ].
	^ candidates
		ifNotEmpty: [ candidates shuffle anyOne ]
		ifEmpty: [ | position |
			position := (1 to: anIndex - 1) atRandom.
			^ self addLiteral: aType at: position ]"
	"	newArg := self
		addStatementOfType: exprToSubstitute returnType
		before: indexExpr.
	newArg ifNil: [ ^ false ].
	statement updateArg: exprToSubstitute by: newArg."
	statement replace: references by: newReferences
]
