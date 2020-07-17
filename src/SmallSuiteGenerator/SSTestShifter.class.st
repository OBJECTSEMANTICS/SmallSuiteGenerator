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
		'previousOpenWindows',
		'statements',
		'assertions',
		'typeInfo',
		'nextId',
		'fitness',
		'targetClassesName',
		'maxNumberOfStatements',
		'fitnessByClass',
		'parents',
		'children',
		'lastMessage',
		'selectionStrategy'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeArgsFor: aMessageStatement [
	|copy successCounter newArgs|
	copy := aMessageStatement copy.
	newArgs := OrderedCollection new.
	successCounter := 0.
	copy args do:[ :arg|
		|alternatives|
		alternatives := self alternativeOfVariables: arg.
		alternatives isEmpty ifTrue:[
				newArgs add: arg.
			] ifFalse: [ 
				newArgs add: alternatives pickAny.
				successCounter := successCounter + 1] .
		].
	successCounter > 0 ifFalse:[ self error:'there is not alternatives for the arguments'].
	copy args: newArgs.
	self addAssignment: copy. 

]

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeFactoryMessage: aFactoryMessage [
	| returnType |
	returnType := aFactoryMessage returnType.
	^ (typeInfo factoryMessagesFrom: returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aFactoryMessage selector ] ]
		ifFound: [ :meth | self addFactoryMessage: returnType ofSelector: meth selector.
	self error:'there is not alternative factory method'].
]

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeFieldAccessMessage: aFieldAccessMessage [
	| returnType receiver |
	receiver := aFieldAccessMessage receiver.
	returnType := aFieldAccessMessage returnType.
	(self pickAccessorsOf: receiver returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aFieldAccessMessage selector ] ]
		ifFound:
			[ :meth | self addFieldAccessMessage: meth selector from: returnType ] .
	self
		error:
			'There is no alternative for fieldAccessMessage of selector: '
				, aFieldAccessMessage selector
]

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeReceiverFor: aMessageStatement [
	|alternatives copy|
	alternatives := self alternativeOfVariables: aMessageStatement receiver.
	alternatives ifEmpty: [ self error:'there is not alternatives for the receiver' ].
	copy := aMessageStatement copy.
	copy receiver: alternatives pickAny. 
	self addAssignment: copy.
]

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeSelectorFor: aMessageStatement [
	| returnType |
	returnType := aMessageStatement returnType.
	^ (typeInfo pickMessagesOf: returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aMessageStatement selector ] ]
		ifFound: [ :meth | self addMessage: meth selector from: returnType ]
		ifNone: [ self error: 'there is not alternative message'].
]

{ #category : #'mutation-change' }
SSTestShifter >> addArgument: arg before: aStatement considering: prevTypes and: scalarNames [
	| res addArgBlock |
	res := arg types anySatisfy: [ :type | prevTypes includes: type ].
	addArgBlock := [ (self random collectAtRandom: arg types)
				detect: [ :missType | 
					[ (scalarNames includes: missType)
						ifTrue: [
							self
								addStatement: (self newAssignment: (self newLiteral: missType))
								before: aStatement ]
						ifFalse: [ self
								addAssignment: "(self newStatementOfType: missType before: aStatement)"
								(self newFactoryMessage: missType before: aStatement) ].
					true ]
						on: SError
						do: [ false ] ]
				ifNone: [ self
						error: 'It is not possible to meet the arguments of this method call' ] ].
	(res not or: [ self next > 0.5 ]) ifTrue: addArgBlock 
]

{ #category : #'building-actions' }
SSTestShifter >> addAssignment: anExpression [
	|assignment|
	assignment := self newAssignment: anExpression.
	self addStatement: assignment.
	^ assignment
]

{ #category : #accessing }
SSTestShifter >> addChild: aTestCase [
	children add: aTestCase
]

{ #category : #'building-actions' }
SSTestShifter >> addFactoryMessage [
	| variables |
	variables := self objectVariables.
	variables ifNotEmpty: [ ^ self addFactoryMessage: (variables pickAny returnType) ].
	^ typeInfo noneAbstractClasses 
		safelyPick:[ :class | self addFactoryMessage: class name fullClassNameSymbol.]
		ifNone:[ self error: 'Cannot create a factoryMessage.' ].
	
	
]

{ #category : #'building-actions' }
SSTestShifter >> addFactoryMessage: symbol [
	^ self addAssignment: (self newFactoryMessage: symbol before: nil)
]

{ #category : #'cross-over' }
SSTestShifter >> addFactoryMessage: aClassName ofSelector: aSelector [
	^ [ self
		addAssignment:
			(self factoryMessageUsing: (typeInfo classMethodType: aSelector from: aClassName) before: nil) ]
		on: SError
		do: [ self addFactoryMessage: aClassName ]
]

{ #category : #'cross-over' }
SSTestShifter >> addFactoryMessage: aClassName otherSelector: aSelector [
	^ [ self
		addAssignment:
			(self factoryMessageUsing: (typeInfo classMethodType: aSelector from: aClassName) before: nil) ]
		on: SError
		do: [ self addFactoryMessage: aClassName ]
]

{ #category : #'building-actions' }
SSTestShifter >> addFieldAccessMessage [
	| receiver method |
	receiver := self pickAnObjectVariable.
	method := self pickAccessorsOf: receiver returnType.
	method ifEmpty: [ self error: 'Cannot create a field access message.' ].
	^ self addFieldAccessMessage: (self selectMethod: method) withReceiver: receiver.
	
]

{ #category : #'cross-over' }
SSTestShifter >> addFieldAccessMessage: selector from: returnType [
	| receiver accessors accessor|
	accessors := self pickAccessorsOf: returnType.
	accessor := accessors
		detect: [ :acc | acc selector = selector ]
		ifNone: [ self error: ('None field access message of selector: {1} matches with: {2}' format:{ selector . returnType})].
	receiver := self pickOrCreateObjectVariableOf: returnType.
	^ self addFieldAccessMessage: accessor withReceiver: receiver
]

{ #category : #'building-actions' }
SSTestShifter >> addFieldAccessMessage: method withReceiver: receiver [
	|result|
	result := self addAssignment: (SFieldAccessMessage newFromReceiver: receiver copy andMethod: method).
	self typeCheck.
	^  result
	
]

{ #category : #'building-actions' }
SSTestShifter >> addLiteral [
	^ self addLiteral: self randomLiteralClassName
]

{ #category : #'building-actions' }
SSTestShifter >> addLiteral: aClassName [
	
	^ self addAssignment: (self newLiteral: aClassName)
]

{ #category : #'building-actions' }
SSTestShifter >> addMessage [
	| receiver methods |
	receiver := self pickAnObjectVariable.
	methods := self pickMessagesOf: receiver returnType.
	methods ifEmpty: [ self error: 'There are no method typeInfos for: ' , receiver returnType , '.' ].
	^ self addMessage: (self selectMethod: methods) withReceiver: receiver.
]

{ #category : #'cross-over' }
SSTestShifter >> addMessage: selector from: returnType [
	| receiver method methods|
	methods := (self pickMessagesOf: returnType) , (typeInfo factoryMessagesFrom: returnType).
	method := methods 
		detect: [ :aMessage | aMessage selector = selector ]
		ifNone: [ self error: ('None message of selector: {1} matches with: {2}' format:{ selector . returnType}) ].
	receiver := self pickOrCreateObjectVariableOf: returnType.
	^ self addMessage: method withReceiver: receiver.
]

{ #category : #'building-actions' }
SSTestShifter >> addMessage: method withReceiver: receiver [
	|result|
	result := self addAssignment: (self messageUsing: method and: receiver before: nil).
	self typeCheck.
	^ result
]

{ #category : #accessing }
SSTestShifter >> addParent: aTestCase [
   parents add: aTestCase.
	aTestCase addChild: self.
]

{ #category : #accessing }
SSTestShifter >> addParents: aCollection [
   aCollection do: [ :e | self addParent: e ]
]

{ #category : #'building-actions' }
SSTestShifter >> addStatement: anExpression [
	self canAddStatement ifTrue: [ 
		statements add: anExpression.
	]
]

{ #category : #'building-actions' }
SSTestShifter >> addStatement: newExpression after: aStatement [
	| anIndex |
	self canAddStatement ifFalse: [ ^ self ].
	anIndex := statements indexOf: aStatement.
	anIndex = 0
		ifTrue: [ self addStatement: newExpression ]
		ifFalse: [ 
			anIndex := self random nextIntBetween: anIndex and: self length.
			statements add: newExpression afterIndex: anIndex ].
	^ newExpression
]

{ #category : #'building-actions' }
SSTestShifter >> addStatement: newExpression before: aStatement [
	"I add a newExpression before aStatement"
	self canAddStatement ifFalse: [ ^ self ].
	statements
		add: newExpression
		afterIndex: (self randomIndexToAdd: newExpression before: aStatement)
]

{ #category : #'building-actions' }
SSTestShifter >> addStatementOfType: aType before: expression [
	| newExpression |
	newExpression := self newStatementOfType: aType before: expression.
	newExpression mutated: true.
	newExpression := self
		newAssignment: newExpression.
	self addStatement: newExpression before: expression.
	^ newExpression
]

{ #category : #'building-actions' }
SSTestShifter >> addStatements: collStatements [
	self
		assert: statements isEmpty
		description: 'statements must be empty'.
	collStatements do: [ :stm | self addStatement: stm ]"
	statements addAll: collStatements"
]

{ #category : #hierarchy }
SSTestShifter >> allChildren [
	^ (Set newFrom: children)
	addAll: (children flatCollect: [ :tC | tC allChildren ]); yourself
]

{ #category : #hierarchy }
SSTestShifter >> allParents [
	|  list |
	list := OrderedCollection new.
	self allParents: self on: list using: Set new.
	^ list
]

{ #category : #accessing }
SSTestShifter >> allParents: testCase on: collection using: associationSet [
	testCase parents 
		reject: [ :tC | (associationSet includes: tC generationNumber -> tC idPopulation) ] 
		thenDo:  [ :tC | 
			associationSet add: tC generationNumber -> tC idPopulation.
			collection add: tC.
			self allParents: tC on: collection using: associationSet	
		]
]

{ #category : #accessing }
SSTestShifter >> allVarNames [
	^ statements collect: [ :stm | stm reference printString ]
]

{ #category : #repairing }
SSTestShifter >> alternativeFactoryMessage: aFactoryMessage [
	| returnType |
	returnType := aFactoryMessage returnType.
	^ (typeInfo factoryMessagesFrom: returnType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aFactoryMessage selector ] ]
		ifFound: [ :meth | self addFactoryMessage: returnType ofSelector: meth selector ]
		ifNone: [ self addFactoryMessage: returnType ofSelector:  aFactoryMessage selector].
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

{ #category : #'mutation-change' }
SSTestShifter >> alternativeOfVariables: aVariable [

	^ self statements select:[ :stm|
		((stm returnType = aVariable returnType) and: [ (stm variable containsVariable: aVariable) not ])
	] thenCollect:[ :stm | stm variable].
	
	
]

{ #category : #actions }
SSTestShifter >> analyze [
  " we use a meta interpreter to use smalltalk and interpret our AST"
  | context |
  self setUp.
  context := SSExecutionContext new.
  context at: 'self' put: TestCase new.
  self interpret: self statements , self assertions with: context.
  context removeKey:'self'.
  self tearDown.
  ^ context.
]

{ #category : #accessing }
SSTestShifter >> assertions [
	^ assertions
]

{ #category : #accessing }
SSTestShifter >> assignId [
	| idToAssign assignedIds |
	"assignedIds := self assignedIds.
	[ assignedIds includes: nextId ] whileTrue: [ nextId := nextId + 1 ]."
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
				select: [ :stm | stm returnType isNil not]
				thenCollect: #returnType.
			scalarsKeys := typeInfo scalars keys asOrderedCollection .
			argTypes
				do: [ :arg | 
					self
						addArgument: arg
						before: aStatement
						considering: prevTypes
						and: scalarsKeys ] ]
]

{ #category : #'building-actions' }
SSTestShifter >> canAddStatement [
	SPlatform asDict 
		ifFalse: [
			^ ((self length + 3) < CompiledMethod fullFrameSize)
		] ifTrue: [ ^ true ]
]

{ #category : #modifying }
SSTestShifter >> changeMessageNotUnderstood: aSelector from: aClassName [
	^ false
]

{ #category : #'mutation-change' }
SSTestShifter >> changeStatement [

	^ (1 to: self length) asOrderedCollection randomShuffle safelyPickAny: [ :index|
			self changeStatementAt: index.
		] ifNone:[ 
			self error:'There is not an statement that could be created with the current arguments'].
]

{ #category : #modifying }
SSTestShifter >> changeStatement: aStatement [
	| statementChanged newStm |
	statementChanged := aStatement copy
		repairOn: self
		changing: aStatement.
	(self statementAt: aStatement ) replaceBy: statementChanged.
	newStm := self statementAt: statementChanged.
	^ statementChanged
]

{ #category : #'mutation-change' }
SSTestShifter >> changeStatementAt: index [
	|copy |
	copy := SSTestCase new with: self typeInfo.
	1 to: (index-1) do: [:i |
		|stm|
		stm := self statements at: i.
		copy addStatement: stm copy.
		self assignId.].
	
	(self statements at: index) changeOn: copy.
		
	(index+1) to: self length do: [:i |
		|stm|
		stm := self statements at: i.
		copy addStatement: stm copy.
		self assignId.].
	
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

{ #category : #'mutation-remove' }
SSTestShifter >> changeStatementOfVarName: varName [
	^ self changeStatement: (self statementOfVarName: varName)
]

{ #category : #accessing }
SSTestShifter >> children [ 
	^ children
]

{ #category : #repairing }
SSTestShifter >> clean [
	|literals unused|
	literals := self statements select: [ :e | (e value isKindOf: SLiteral) or: [ e value isKindOf: SFactoryMessage ] ].
	unused := literals difference: (literals select: 
		[ :e | (self statements collect: 
			[:stm | stm pickUpReferences: e]) anySatisfy: [ :x | x isNotEmpty  ]]).
	unused do: [ :stm | self removeStatement: stm ]
]

{ #category : #'mutation-remove' }
SSTestShifter >> containsVariable: aVariable [
	^ self statements anySatisfy: [ :stm | stm variable = aVariable].
]

{ #category : #'mutation-remove' }
SSTestShifter >> containsVariableWithReturnType: aClassName [
	^ self statements anySatisfy: [ :stm | stm returnType = aClassName].
]

{ #category : #'mutation-insert' }
SSTestShifter >> copyWithANewMethodCallToAnArgumentOfTheTargetClass [
	|copy indexs pair insertionIndex argumentFactoryIndex messageIndex receiver methods|
	copy := SSTestCase with: self typeInfo.
	indexs := self targetClassIndexs.
	indexs ifEmpty: [ ^ self]. "we can not do it"
	pair :=  indexs pickAny.
	argumentFactoryIndex := pair first.
	messageIndex := pair second.
	"we can insert the call any index after the target class object was created"
	insertionIndex := self random nextIntBetween: argumentFactoryIndex and: messageIndex.
	
	"copy the first statements"
	1 to: insertionIndex do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.].
	
	"assigning ids that do not exists in previous test, then there will be no collitions when at the last part of the statements"
	copy nextId: self nextId.
	"add the new method call"
	receiver := (self statements at: argumentFactoryIndex) variable copy.
	methods := self pickMessagesOf: receiver returnType.
	methods ifEmpty: [ self error: 'There are no method typeInfos for: ' , receiver returnType , '.' ].
	"adding the rest of statements"
	(insertionIndex +1) to: self length do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.
		self assignId.].
	"no we got un ordered ids... because we put bigger ides in the middel to avoid collision, so we will fix the ides"
	self repairIds.
	
]

{ #category : #'mutation-insert' }
SSTestShifter >> copyWithANewMethodCallToAnyValue [
	|copy indexs insertionIndex factoryIndex receiver methods|
	copy := SSTestCase with: self typeInfo.
	indexs := self noTargetClassIndexs.
	indexs ifEmpty: [ ^ self]. "we can not do it"
	factoryIndex :=  indexs pickAny.
	"we can insert the call any index after the target class object was created"
	insertionIndex := self random nextIntBetween: factoryIndex and: self length.
	
	"copy the first statements"
	1 to: insertionIndex do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.].
	
	"assigning ids that do not exists in previous test, then there will be no collitions when at the last part of the statements"
	copy nextId: self nextId.
	"add the new method call"
	receiver := (self statements at: factoryIndex) variable copy.
	methods := self pickMessagesOf: receiver returnType.
	methods ifEmpty: [ self error: 'There are no method typeInfos for: ' , receiver returnType , '.' ].
	"adding the rest of statements"
	(insertionIndex +1) to: self length do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.
		self assignId.].
	"no we got un ordered ids... because we put bigger ides in the middel to avoid collision, so we will fix the ides"
	self repairIds.
	
]

{ #category : #'mutation-insert' }
SSTestShifter >> copyWithANewMethodCallToTargetClass [
	|copy indexs insertionIndex factoryIndex receiver methods|
	copy := SSTestCase with: self typeInfo.
	indexs := self targetClassIndexs.
	indexs ifEmpty: [ ^ self]. "we can not do it"
	factoryIndex :=  indexs pickAny.
	"we can insert the call any index after the target class object was created"
	insertionIndex := self random nextIntBetween: factoryIndex and: self length.
	
	"copy the first statements"
	1 to: insertionIndex do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.].
	
	"assigning ids that do not exists in previous test, then there will be no collitions when at the last part of the statements"
	copy nextId: self nextId.
	"add the new method call"
	receiver := (self statements at: factoryIndex) variable copy.
	methods := self pickMessagesOf: receiver returnType.
	methods ifEmpty: [ self error: 'There are no method typeInfos for: ' , receiver returnType , '.' ].
	"adding the rest of statements"
	(insertionIndex +1) to: self length do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.
		self assignId.].
	"no we got un ordered ids... because we put bigger ides in the middel to avoid collision, so we will fix the ides"
	self repairIds.
	
]

{ #category : #'mutation-insert' }
SSTestShifter >> copyWithARandomStatement [

	^ #(#copyWithANewMethodCallToTargetClass #copyWithANewMethodCallToAnyValue #copyWithANewMethodCallToAnArgumentOfTheTargetClass)
		safelyPickAny: [ :selector | 
			self perform: selector.
		] ifNone: [  ^ self error:'We could not insert any statement'].
]

{ #category : #'mutation-remove' }
SSTestShifter >> copyWithoutStatementAt: index [
	|deletedVariables copy|
	copy := SSTestCase new.
	deletedVariables := OrderedCollection new.
	
	"to give different names to variables"
	copy nextId: self nextId.

	"lo borramos"
	deletedVariables add: (self statements at: index) variable.
	"copy the first half"
	1 to: (index-1) do:[ :i|
		|stm|
		stm := self statements at: i.
		copy addStatement: stm copy.
		].
	"carrefully copy the other half"
	(index+1) to: self length do:[ :i |
		|stm|
		stm := self statements at: i.
		(deletedVariables anySatisfy:[:delVar| stm containsVariable: delVar]) ifTrue:[
			(deletedVariables allSatisfy: [:delVar| stm isThereEnoughArgumentsToBuild: copy]) ifTrue:[
				stm insertOn: copy.
			] ifFalse:[
				deletedVariables add: stm variable.
			].						
		] ifFalse:[
			copy addStatement: stm copy.		
		]
	].
	"ahora borramos los statements que dependen de el statement borrado"

	
	
	
	
	
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
SSTestShifter >> fixAssertions [
	SPlatform asDict ifTrue: [ 
		assertions do: [ :ass | 
			ass args do: [ :arg |
				arg fix
			 ] ] ]
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
		flatCollect: [ :assertion | assertion for: executionContext ].
	self fixAssertions 
]

{ #category : #actions }
SSTestShifter >> generateStatements [
  | flag counter |
  flag := true.
  counter := 0.
  self assert: typeInfo types isNotEmpty description: 'TypeInfo does not contain info at all.'.
  [ flag and: [ self length < self maxNumberOfStatements ] ] 
		whileTrue: [ | array |
        array := #(#addMessage #addFieldAccessMessage) randomShuffle.
        array detect: [:selector |  [ (self perform: selector) isNotNil ] on: SError do: [ false ] ] ifFound: [:selector |  | lastStm |
              lastStm := statements last ] ifNone: [ counter := counter + 1.
              counter > self maxNumberOfStatements ifTrue: [ flag := false.
                    self error: 'Not able to generate statements' ] ] ]
]

{ #category : #actions }
SSTestShifter >> generateStatements: anInteger [
	self maxNumberOfStatements: anInteger.
	self generateStatements.
	
]

{ #category : #parsing }
SSTestShifter >> getStringOf: stm [
	stm isString ifTrue: [ ^ stm ].
	^ stm printString 
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
  targetClassesName := nil.
  parents := OrderedCollection new.
  children := OrderedCollection new.
  selectionStrategy := SGARouletteSelection new.
]

{ #category : #'building-actions' }
SSTestShifter >> insertAsParameter: expression after: aStatement [
	(self random collectAtRandom: (statements
		copyFrom: (statements indexOf: aStatement) + 1
		to: self length))
		do: [ :stm | [ | mutatedStm |
			mutatedStm := stm replaceArgBy: expression.
			(mutatedStm pickUpReferences: expression) ifNotEmpty: 
				[ mutatedStm value mutated: true.].
			 ^ mutatedStm ]
				on: SError
				do: [ :e | ] ].
	self
		error: 'Cannot insert any parameter by: ' , expression printString
]

{ #category : #'building-actions' }
SSTestShifter >> insertExpression: expression after: aStatement [
	^ self
		addStatement: (self newAssignment: expression)
		after: aStatement
]

{ #category : #'mutation-insert' }
SSTestShifter >> insertStatement [
	|alpha count testCase|
	testCase := self.
	count := 1.
	alpha := 0.5.
	[ self length < self maxNumberOfStatements and: [ self next <= (alpha raisedTo: count) ] ]
		whileTrue: [ 
			testCase := testCase copyWithARandomStatement.
			count := count + 1 ].
	^ testCase.
]

{ #category : #'building-actions' }
SSTestShifter >> insertStatementOfSelector: selector [
	(self random collectAtRandom: statements copy)
		do: [ :stm | 
			[ ^ self perform: selector inStatement: stm ]
				on: SError
				do: [  ] ].
	self
		error: 'Cannot insert statement of selector: ' , selector printString
]

{ #category : #actions }
SSTestShifter >> interpret: aStatementCollection with: aExecutionContext [
  | objects |
  objects := aStatementCollection collect: [:stm |  stm interpret: aExecutionContext ].
  ^objects last
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

{ #category : #accessing }
SSTestShifter >> lastMessage [
	^ lastMessage 
]

{ #category : #accessing }
SSTestShifter >> lastMessage: anObject [ 	
	lastMessage := anObject 
]

{ #category : #accessing }
SSTestShifter >> length [
  ^ statements size
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
	methods := typeInfo factoryMessagesFrom: aClassName.
	^ methods
		ifEmpty: [ SFactoryMessage default: aClassName ]
		ifNotEmpty: [  self newFactoryMessageUsing: aClassName and: aStatement ]
]

{ #category : #'instance creation' }
SSTestShifter >> newFactoryMessageUsing: aClassName and: aStatement [
	| methods |
	methods := typeInfo factoryMessagesFrom: aClassName.
	(self random collectAtRandom: methods)
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
		detect: [ :aMethod | aMethod returnType hasOnlyOneType and: [ aMethod returnType includes: aType ]]
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
			^ SLiteral new
				returnType: aClassName;
				value: (self random selectAtRandom: values asOrderedCollection) ].
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
		detect: [ :aMethod | aMethod returnType hasOnlyOneType and: [ aMethod returnType includes: aType ] ]
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
	(self random collectAtRandom: #(#newFactoryMessage:before: #newLiteral: #newFieldAccessMessageOfType:before: #newMessageOfType:before:))
		do: [ :message | 
			[ ^ self
				perform: message
				withEnoughArguments: (Array with: aType with: aStatement) ]
				on: SError
				do: [ "try with the next one" ] ].
	self error: 'Cannot create expression of returnType: ' , aType
]

{ #category : #accessing }
SSTestShifter >> nextId [
	^ nextId
]

{ #category : #accessing }
SSTestShifter >> nextId: newId [
	nextId := newId.
]

{ #category : #'mutation-insert' }
SSTestShifter >> noTargetClassIndexs [
	|indexs|
	indexs := OrderedCollection new.
	self statements doWithIndex:[ :stm :index|
		(stm isFactoryMessage and:[stm returnType ~= self targetClassesName]) ifTrue:[ indexs add: index.].
	].
	^ indexs.
	
]

{ #category : #accessing }
SSTestShifter >> notEmpty [
  ^ self length > 0
]

{ #category : #accessing }
SSTestShifter >> numMaxStatements [
	^ maxNumberOfStatements
]

{ #category : #accessing }
SSTestShifter >> numMaxStatements: anObject [
	maxNumberOfStatements := anObject
]

{ #category : #querying }
SSTestShifter >> objectVariables [
	
	^ statements select:[:stm| 
				(self typeInfo classAt: stm returnType ifNone:[nil]) isNil not] 
		thenCollect:[:stm| stm variable].
]

{ #category : #accessing }
SSTestShifter >> parents [
	^ parents
]

{ #category : #parsing }
SSTestShifter >> parseTree [
	| stmList |
	stmList := self statements, (lastMessage ifNil: [#()] ifNotNil: [Array with: lastMessage]).
	SPlatform asDict 
		ifTrue: [ ^ self parseTreeAsDictWith: stmList ]
		ifFalse: [ ^ self parseTreeWith: stmList]
]

{ #category : #parsing }
SSTestShifter >> parseTreeAsDictWith: statementCollection [
	| node temporaries rbParserClass |
	statementCollection ifEmpty: [ self error: 'testCase does not have statements' ].
	rbParserClass := SPlatform rbParserClass.
	node := rbParserClass parseExpression: '[]'.
	temporaries := Array with: (self aVariableNodeClass named: 'var').
	node body temporaries: temporaries.
	node body addNode: (rbParserClass parseExpression: 'var := Dictionary new.').
	statementCollection
		do: [ :stm | 
			| aNode |
			[ aNode := rbParserClass parseExpression: (self getStringOf: stm).
			node body addNode: aNode ]
				on: Error
				do: [  ] ].
	^ node
]

{ #category : #parsing }
SSTestShifter >> parseTreeWith: statementCollection [
	| node temporaries rbParserClass |
	statementCollection ifEmpty: [ self error: 'testCase does not have statements' ].
	rbParserClass := SPlatform rbParserClass.
	node := rbParserClass parseExpression: '[]'.
	temporaries := (self allVarNames
		collect: [ :varName | rbParserClass parseExpression: varName ]) 
		select: [:e | e isKindOf: self aVariableNodeClass ].
	node body temporaries: temporaries.
	statementCollection
		do: [ :stm | 
			| aNode |
			[ aNode := rbParserClass parseExpression: (self getStringOf: stm).
			node body addNode: aNode ]
				on: Error
				do: [  ] ].
	^ node
]

{ #category : #parsing }
SSTestShifter >> parseTreeWithAssertions [
	| stmList |
	stmList := self statements, (lastMessage ifNil: [#()] ifNotNil: [Array with: lastMessage]), self assertions.
	SPlatform asDict 
		ifTrue: [ ^ self parseTreeAsDictWith: stmList ]
		ifFalse: [ ^ self parseTreeWith: stmList]
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
	variables ifEmpty: [ 
		self addFactoryMessage.
		variables := self objectVariables ].
	^ variables pickAny.
]

{ #category : #querying }
SSTestShifter >> pickMessagesOf: aType [
	^ typeInfo messagesFrom: aType
]

{ #category : #querying }
SSTestShifter >> pickObjectVariableOf: aClassName [
	(self random collectAtRandom: (self subStatementsFrom: 1 toPrevIndexOf: nil))
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

{ #category : #repairing }
SSTestShifter >> randomIndexToAdd: aExpression before: aStatement [
	| refIndexes anIndex |
	anIndex := statements indexOf: aStatement.
	anIndex = 0
		ifTrue: [ ^ self length ].
	refIndexes := self referencesIndexes: aExpression.
	anIndex := anIndex - 1.
	refIndexes
		ifNotEmpty: [ | ini end maxIndex |
			maxIndex := refIndexes max.
			ini := anIndex min: maxIndex.
			end := anIndex max: maxIndex.
			^ self random selectAtRandom: (ini to: end) ].
	anIndex = 0
		ifTrue: [ ^ anIndex ].
	^ self random selectAtRandom: (1 to: anIndex)
]

{ #category : #'building-actions' }
SSTestShifter >> randomLiteralClassName [
	|scalars|
	scalars := typeInfo scalars keys.
	scalars ifEmpty: [ self error: 'TypeInfo does not have scalars. Set scalars on typeInfo.' ].
	^ scalars pickAny.
]

{ #category : #repairing }
SSTestShifter >> referencesIndexes: expression [
	^ ((expression variablesWithId ) allButFirst collect: [ :var | statements indexOf: (self statementOfVarName: var printString) ])
]

{ #category : #'mutation-remove' }
SSTestShifter >> removeChild: testCase [
	| index |
	index := 0.
	children detect: [:tC | index := index + 1.
		(tC generationNumber == testCase generationNumber) and: [ tC idPopulation == testCase idPopulation ] ]
		ifFound: [ :tC | children removeAt: index ]
]

{ #category : #'mutation-remove' }
SSTestShifter >> removeExpression: expression [
	self removeFromStatements: expression.
	statements copy do: [ :stm | (stm pickUpReferences: expression) ifNotEmpty: [ self repairReferenceTo: expression of: stm ] ].
]

{ #category : #'mutation-remove' }
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

{ #category : #'mutation-remove' }
SSTestShifter >> removeFromStatements: expression [
	[ statements remove: expression ]
		on: Error
		do: [ self error: expression printString , ' is not found.' ]
]

{ #category : #'mutation-remove' }
SSTestShifter >> removeStatement [
	|deletedVariables copy index|
	copy := SSTestCase with: self typeInfo.
	deletedVariables := OrderedCollection new.
	index := self random nextInt: self length.
	"to give different names to variables"
	copy nextId: self nextId.

	"lo borramos"
	deletedVariables add: (self statements at: index) variable.
	"copy the first half"
	1 to: (index-1) do:[ :i|
		|stm|
		stm := self statements at: i.
		copy addStatement: stm copy.
		].
	"carrefully copy the other half"
	(index+1) to: self length do:[ :i |
		|stm|
		stm := self statements at: i.
		(deletedVariables anySatisfy:[:delVar| stm containsVariable: delVar]) ifTrue:[
			(deletedVariables allSatisfy: [:delVar| stm isThereEnoughArgumentsToBuild: copy]) ifTrue:[
				stm insertOn: copy.
			] ifFalse:[
				deletedVariables add: stm variable.
			].						
		] ifFalse:[
			copy addStatement: stm copy.		
		]
	].
	"ahora borramos los statements que dependen de el statement borrado"
	copy repairIds.
	^ copy.
	
	
	
	
	
]

{ #category : #'mutation-remove' }
SSTestShifter >> removeStatement: anExpression [
	self removeExpression: (self statementAt: anExpression)
]

{ #category : #'mutation-remove' }
SSTestShifter >> removeStatementNoRepairing: aStatement [
	"remove all statements that reference to statement because this cant be fixed"

	self removeExpressionWithoutRepairing: (self statementAt: aStatement)
]

{ #category : #'mutation-remove' }
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

{ #category : #'building-actions' }
SSTestShifter >> repair: exprToReplace of: expression [
	| aType replacement |
	aType := exprToReplace returnType.
	replacement := (self random collectAtRandom:(self subStatementsFrom: 1 toPrevIndexOf: expression))
		detect:
			[ :stm | stm reference ~= exprToReplace and: [ stm returnType = aType ] ]
		ifNone: [ self addStatementOfType: aType before: expression ].
	self replace: exprToReplace by: replacement on: expression
]

{ #category : #'mutation-insert' }
SSTestShifter >> repairIds [
	|map|
	statements do:[ :stm | stm negateId].
	map := Dictionary new.
	statements doWithIndex:[ :stm :index |
		map at: (stm variable id) put: index.].
	statements do:[ :stm | stm rename: map].
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

{ #category : #actions }
SSTestShifter >> run [
  " we use a meta interpreter to use smalltalk and interpret our AST"
  |result context|
  self setUp.
  context := SSExecutionContext new.
  context at: 'self' put: TestCase new.
  result := self interpret: (self statements, self assertions) with: context.
  self tearDown.
  ^ result.
]

{ #category : #actions }
SSTestShifter >> runWithoutAssertions [
  " we use a meta interpreter to use smalltalk and interpret our AST"
  | result context |
  self setUp.
  context := SSExecutionContext new.
  context at: 'self' put: TestCase new.
  result := self interpret: self statements with: context.
  self tearDown.
  ^result
]

{ #category : #'building-actions' }
SSTestShifter >> selectMethod: aCollection [ 
	selectionStrategy ifNil: [  ^ aCollection  pickAny].
	^ selectionStrategy selectJustOneOf: aCollection with: (aCollection collect: #executions).
	
]

{ #category : #accessing }
SSTestShifter >> selectionStrategy: selectStrategy [
	selectionStrategy := selectStrategy 
]

{ #category : #actions }
SSTestShifter >> setUp [
	previousOpenWindows := SystemWindow allInstances.
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
SSTestShifter >> subStatementsAfterIndexOf: aStatement [
	| start |
	start := statements indexOf: aStatement.
	start < self length
		ifFalse: [ ^ Array new ].
	^ statements copyFrom: start + 1 to: self length
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

{ #category : #'mutation-insert' }
SSTestShifter >> targetClassArgumentIndexs [
	|indexs|
	indexs := OrderedCollection new.
	self statements doWithIndex:[ :stm :index|
		(stm isMessage and:[stm value receiver returnType = self targetClassesName]) ifTrue:[ 
			1 to: (index-1) do:[ :i|
				|stmAnt|
				stmAnt := (self statements at: i).
					(stmAnt isFactoryMessage and:[ stm value containsVariable: stmAnt variable]) ifTrue:[
						indexs add: { i . index}.
					]	
				].
			].
		].
	^ indexs.
	
]

{ #category : #'mutation-insert' }
SSTestShifter >> targetClassIndexs [
	|indexs|
	indexs := OrderedCollection new.
	self statements doWithIndex:[ :stm :index|
		(stm isFactoryMessage and:[stm returnType = self targetClassesName]) ifTrue:[ indexs add: index.].
		].
	^ indexs.
	
]

{ #category : #actions }
SSTestShifter >> targetClassName: aSymbol [
	typeInfo types at: aSymbol 
		ifAbsent: [ self error: 'Class name: ', aSymbol, ' is not found in typeInfo' ].
	targetClassesName := aSymbol.
]

{ #category : #accessing }
SSTestShifter >> targetClassesName [
	^ targetClassesName
]

{ #category : #actions }
SSTestShifter >> tearDown [ 
	|windowsToDelete|
	windowsToDelete := SystemWindow allInstances asOrderedCollection removeAll: previousOpenWindows.
	windowsToDelete do:[:w| w close].
]

{ #category : #actions }
SSTestShifter >> typeCheck [
  | context |
  context := self analyze.
  self statements do: [:assig |  | realValue |
realValue := context at: assig variable fullName.    
assig variable returnType = realValue class name
ifFalse: [ assig variable returnType: realValue class name ].
assig value returnType = realValue class name
ifFalse: [ assig value returnType: realValue class name ].

].
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
				ifFalse: [self halt. true ]
				ifTrue: [ references addAll: variables.
					false ] ]
		ifFound: [ false ]
		ifNone: [ true ]
]

{ #category : #'mutation-remove' }
SSTestShifter >> variablesWithReturnType: aReturnType [
	^ self statements select:[ :stm| stm returnType = aReturnType].
]
