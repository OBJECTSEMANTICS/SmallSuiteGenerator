Class {
	#name : #SSTestShifter,
	#superclass : #Object,
	#instVars : [
		'statements',
		'assertions',
		'typeInfo',
		'nextId',
		'fitness',
		'targetClassesNames',
		'validateTargetClasses',
		'maxNumberOfStatements'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #inserting }
SSTestShifter >> addAssignment: anExpression [
	^ self addStatement: ( self newAssignment: anExpression).

]

{ #category : #inserting }
SSTestShifter >> addFactoryMessage [
	|receiver variables|
	
	variables := self objectVariables.
	variables isEmpty ifTrue:[
		typeInfo noneAbstractClasses shuffle
		do: [ :aClass | [   ^ self addFactoryMessage: aClass name] on: SError do: [  ] ].
			self error: 'Not able to create a factoryMessage'
		] ifFalse:[
			receiver := variables atRandom.
			^ self addFactoryMessage: receiver returnType.
		].
]

{ #category : #inserting }
SSTestShifter >> addFactoryMessage: symbol [
	[ ^ self addAssignment: (self newFactoryMessage: symbol before: nil) ]
		on: SError
		do: [ :error | self error: error messageText ]
]

{ #category : #inserting }
SSTestShifter >> addFactoryMessage: aClassName ofSelector: aSelector [
	^ [ self
		addAssignment:
			(self
				factoryMessageUsing: (typeInfo type: aSelector fromMetaClassName: aClassName)
				before: nil) ]
		on: SError
		do: [ self addFactoryMessage: aClassName ]
]

{ #category : #inserting }
SSTestShifter >> addFactoryMessage: aClassName withMethod: aMethod [
	^ self addAssignment: (self factoryMessageUsing: aMethod before: nil)
]

{ #category : #inserting }
SSTestShifter >> addFieldAccessMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickAccessorsOf: receiver returnType.
	methods
		ifNotEmpty: [ ^ self
				addFieldAccessMessage: methods shuffle anyOne
				withReceiver: receiver ]
]

{ #category : #inserting }
SSTestShifter >> addFieldAccessMessage: aSelector from: aClassName [
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
	| receiver methods|
	receiver := self pickAnObjectVariable.
	methods := self pickMessagesOf: receiver returnType.
	methods
		ifNotEmpty: [ ^ self addMessage: methods shuffle anyOne withReceiver: receiver ].
	
]

{ #category : #inserting }
SSTestShifter >> addMessage: aSelector from: aClassName [
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
		ifTrue: [ self addStatement: newExpression  ]
		ifFalse: [ anIndex := (anIndex to: self numberStatements) atRandom.
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
SSTestShifter >> addStatementOfType: aType before: aExpression [
	| newExpression |
	newExpression := self
		newAssignment: (self newStatementOfType: aType before: aExpression).
	self addStatement: newExpression before: aExpression.
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
SSTestShifter >> alternativeFieldAccessMessage: aFieldAccessMessage before: aExpression [
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

{ #category : #repairing }
SSTestShifter >> alternativeMessage: aMessage before: aExpression [
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
		ifNotNil: [ 
			|prevTypes scalarsKeys|
			prevTypes := (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
				collect: #returnType
				thenSelect: [ :aType | aType isNotNil ].
			scalarsKeys := typeInfo scalars keys.
			argTypes do:[:arg|
				|res|
				res :=arg types anySatisfy:[:type|  prevTypes includes:type].
				res ifFalse:[
						arg types asOrderedCollection shuffle detect:[ :missType |
							
							[(scalarsKeys includes: missType) ifTrue: [ 
								self addLiteral: missType.
							] ifFalse:[
								self addAssignment: (self newFactoryMessage: missType before: aStatement).
							].true] on: SError do:[false]
						] ifNone:[   ^ self error: 'it is not possible to meet the arguments of this method call'].	
				] ifTrue:[].
		].
	].

]

{ #category : #modifying }
SSTestShifter >> changeMessageNotUnderstood: aSelector from: aClassName [
	^ false
]

{ #category : #modifying }
SSTestShifter >> changeStatement [
	statements copy shuffle
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

{ #category : #actions }
SSTestShifter >> generateAssertions [
	^ self generateAssertions: {SComparisonAssertion . SInspectorAssertion . SPrimitiveAssertion . SStringAssertion}.
]

{ #category : #actions }
SSTestShifter >> generateAssertions: classAssertions [
	"
	it analyze each kind of assertion an generate a set of assertion based on the test case -- double dispatch
	"
	|executionContext|
	executionContext := self analyze.
	assertions := classAssertions flatCollect:[ :assertion | assertion for: executionContext.].
]

{ #category : #actions }
SSTestShifter >> generateStatements [
	self assert: typeInfo types isNotEmpty 
			description: 'TypeInfo does not contain info at all.'.
	[ self numberStatements < self maxNumberOfStatements]
		whileTrue: [ 
			[
			  self addMessage.
			] on: Error do:[:e| Transcript show: e printString;cr.].
			].
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
	nextId := 0.
	maxNumberOfStatements := 10.
	targetClassesNames := Set new.
	validateTargetClasses := false
]

{ #category : #inserting }
SSTestShifter >> insertAsParameter: aExpression after: aStatement [
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
SSTestShifter >> insertExpression: aExpression after: aStatement [
	^ self
		addStatement: (self newAssignment: aExpression)
		after: aStatement
]

{ #category : #inserting }
SSTestShifter >> insertExpressionRandomly [
		#(#insertRandomMessage:using: #insertMethodMessage:using: #insertAsParameter:using:)
		shuffle
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
	random := Random new seed: DateAndTime current nanoSecond / 100.
	[ l < stop and: [ random next <= (alpha raisedTo: count) ] ]
		whileTrue: [ self insertExpressionRandomly.
			l := l + 1.
			count := count + 1 ]
]

{ #category : #inserting }
SSTestShifter >> insertStatementOfSelector: selector [

	statements copy shuffle
		do: [ :stm | 
			[ ^ self perform: selector inStatement: stm ]
				on: SError
				do: [  ] ].
	self
		error: 'Cant insert statement of selector: ' , selector printString
]

{ #category : #repairing }
SSTestShifter >> invariant [
	self typeInfo ifNil: [ self error: 'Set the testCase with the correct typeInfo' ]
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
	[^ SAssignment
		name:
			(SVariable new
				varName: '_var';
				id: self assignId;
				returnType: anExpression returnType;
				yourself)
		value: anExpression copy] on: MessageNotUnderstood do: [ :error | self error: 'Error: ', anExpression printString , 'is not an expression.' ]
]

{ #category : #'instance creation' }
SSTestShifter >> newFactoryMessage: aClassName before: aStatement [
	typeInfo types
		at: aClassName
		ifPresent: [ | methods |
			self validTargetClassName: aClassName.
			methods := typeInfo factoryMessagesFrom: aClassName.
			^ methods
				ifEmpty: [ SFactoryMessage default: aClassName ]
				ifNotEmpty: [ self newFactoryMessageUsing: aClassName and: aStatement ] ].
		self error: 'Error to create factoryMessage of: ', aClassName, ' because it is not found in typeInfo.'
]

{ #category : #'instance creation' }
SSTestShifter >> newFactoryMessageUsing: aClassName and: aStatement [
	|methods|
	methods := typeInfo factoryMessagesFrom: aClassName.
	methods shuffle
		do: [ :method | 
			[ 
			self buildArgs: method argTypes before: aStatement.
			^ SFactoryMessage
		method: method
		class: aClassName
		previousStatements: (self subStatementsFrom: 1 toPrevIndexOf: aStatement)
			]
				on: SError
				do: [  ] ].
	self error: 'error factoryMessage'
]

{ #category : #'instance creation' }
SSTestShifter >> newFieldAccessMessageOfType: aType andReceiver: receiver [
	^ (self pickAccessorsOf: receiver returnType)
		detect: [ :aMethod | aMethod returnType = aType ]
		ifFound:
			[ :aMethod | SFieldAccessMessage newFromReceiver: receiver copy andMethod: aMethod ]
		ifNone: [ self error: 'cant create field access of type: ' , aType asString ]
]

{ #category : #'instance creation' }
SSTestShifter >> newFieldAccessMessageOfType: aType before: aStatement [
	(self factoryMessageVariablesBefore: aStatement)
		do: [ :receiver | 
			[ ^ self newFieldAccessMessageOfType: aType andReceiver: receiver ]
				on: SError
				do: [  ] ].
	^self error: 'cant create field access of type: ' , aType asString
]

{ #category : #'instance creation' }
SSTestShifter >> newLiteral: aClassName [
	typeInfo scalars
		at: aClassName
		ifPresent: [ :values | 
				^ SLiteral new
					returnType: aClassName;
					value: values asOrderedCollection shuffle first ].
	self error: 'scalars dont contain: ' , aClassName asString.

]

{ #category : #'instance creation' }
SSTestShifter >> newMessageOfType: aType before: aStatement [
	(self factoryMessageVariablesBefore: aStatement)
		do: [ :receiver | 
			[ ^ self newMessageOfType: aType using: receiver before: aStatement ]
				on: SError
				do: [  ] ].
	^self error: 'cant create message of type: ' , aType asString
]

{ #category : #'instance creation' }
SSTestShifter >> newMessageOfType: aType using: receiver before: aStatement [
	(self pickMessagesOf: receiver returnType)
		detect: [ :aMethod | aMethod returnType = aType ]
		ifFound: [ :aMethod | 
			[ ^ self messageUsing: aMethod and: receiver before: aStatement ]
				on: SError
				do: [  ] ].
	^ self error: 'error to create message'
]

{ #category : #repairing }
SSTestShifter >> newStatementOfType: aType before: aStatement [
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
	self
		error: 'Cant create expression with the returnType: ' , aType asString
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
			res isNotNil] thenCollect:[:stm| stm variable].
]

{ #category : #parsing }
SSTestShifter >> parseTree [
	
	^ self parseTreeWith: self statements.
]

{ #category : #parsing }
SSTestShifter >> parseTreeWith: statementCollection [
	| node temporaries |
	node := RBParser parseExpression: '[]'.
	temporaries := self allVarNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	statementCollection do: [ :stm | node body addNode: (RBParser parseExpression: stm printString) ].
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
	|variables|
	variables := self objectVariables.
	variables isEmpty ifTrue:[ self addFactoryMessage. variables := self objectVariables].
	variables ifEmpty:[ self error:'it is not possible to create an object'].
	^ variables atRandom.
]

{ #category : #querying }
SSTestShifter >> pickMessagesOf: aType [
	^ typeInfo messagesFrom: aType
]

{ #category : #querying }
SSTestShifter >> pickObjectVariableOf: aClassName [
	(self subStatementsFrom: 1 toPrevIndexOf: nil) copy shuffle
		detect: [ :stm | stm returnType = aClassName ]
		ifFound: [ :stm | 
			^ stm reference ]
		ifNone: [  ].
	self error: 'Dont exist a statement of class: ' , aClassName
]

{ #category : #querying }
SSTestShifter >> pickOrCreateObjectVariableOf: aClassName [
	^ [ self pickObjectVariableOf: aClassName ]
		on: SError
		do: [ (self addFactoryMessage: aClassName) variable ]
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
			^ (ini to: end) atRandom ].
	anIndex = 0
		ifTrue: [ ^ anIndex ].
	^ (1 to: anIndex) atRandom
]

{ #category : #inserting }
SSTestShifter >> randomLiteralClassName [
	^ typeInfo scalars keys atRandom.
]

{ #category : #inserting }
SSTestShifter >> randomStatement [
	^ statements at: (1 to: self numberStatements ) atRandom
	
]

{ #category : #repairing }
SSTestShifter >> referencesIndexes: aExpression [
	^ ((aExpression variablesWithId ) allButFirst collect: [ :var | statements indexOf: (self statementOfVarName: var printString) ])
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
[statements remove: expression] on: NotFound do: [ self error: 'expression not found' ]
]

{ #category : #removing }
SSTestShifter >> removeStatement [
	"If other statements refer the statement to remove, then this reference is replaced with another value out of the set which has the same type"

	statements ifEmpty: [ ^ #() ].
	self
		removeStatement: (statements at: (1 to: self numberStatements) atRandom)
]

{ #category : #removing }
SSTestShifter >> removeStatement: anExpression [
	self removeExpression: (self statementAt: anExpression)
]

{ #category : #removing }
SSTestShifter >> removeStatementNoRepairing: aStatement [
	"remove all statements that reference to statement because this cant be fixed"
	self removeExpressionWithoutRepairing: (self statementAt: aStatement)
	"statements remove: stmToRemove.
	(statements copy
		flatCollect: [ :stm | 
			(stm pickUpReferences: stmToRemove)
				ifEmpty: [ #() ]
				ifNotEmpty: [ Array with: stm ] ])
		do: [ :stm | self removeStatementNoRepairing: stm ]"
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
	self error: 'expression must not exist in the testCase'
]

{ #category : #inserting }
SSTestShifter >> repair: exprToReplace of: expression [
	| aType replacement |
	aType := exprToReplace returnType.
	replacement := (self
		subStatementsFrom: 1
		toPrevIndexOf: expression) shuffle
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
	scalarsKeys := typeInfo scalars keys.
	scalarTypes := OrderedCollection new.
	nonScalarTypes := OrderedCollection new.
	types do: [ :aType | (scalarsKeys includes: aType) ifTrue: [ scalarTypes add: aType ] ifFalse: [ nonScalarTypes add: aType ]  ].
	nonScalarTypes
		do: [ :aType | self addStatementOfType: aType before: aStatement ].
	^ scalarTypes
]

{ #category : #accessing }
SSTestShifter >> statementAt: statement [
	^ statements
		detect: [ :stm | stm = statement ]
		ifNone: [ self error: 'statement not found' ]
]

{ #category : #accessing }
SSTestShifter >> statementOfVarName: aString [
	^ statements
		detect: [ :stm | stm reference printString = aString ]
		ifNone: [ self error: 'Not found statement of varName: ' , aString ]
]

{ #category : #accessing }
SSTestShifter >> statements [
	^ statements
]

{ #category : #repairing }
SSTestShifter >> statementsOfType: aType before: aExpression [
	(statements includes: aExpression)
		ifFalse: [ self error: 'not found statement' ].
	^ (self subStatementsFrom: 1 toPrevIndexOf: aExpression)
		select: [ :stm | stm returnType = aType ]
]

{ #category : #repairing }
SSTestShifter >> subStatementsFrom: start toPrevIndexOf: aStatement [
	|stop|
	stop := statements indexOf: aStatement.
	stop = 0
		ifTrue: [ ^ statements ].
	( start <= stop )
		ifFalse: [ ^ self error: 'Data must be in range' ].
	^ statements copyFrom: start to: stop - 1.
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

{ #category : #accessing }
SSTestShifter >> validTargetClassName: aClassName [
	(validateTargetClasses and: [ (targetClassesNames includes: aClassName) not ]) ifTrue: [ self error: 'Class: ', aClassName, ' is not able to be used.' ]
]

{ #category : #accessing }
SSTestShifter >> validateTargetClasses: boolean [
	validateTargetClasses := boolean
]
