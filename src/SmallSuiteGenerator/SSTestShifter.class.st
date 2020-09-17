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
		'maxNumberOfStatements',
		'lastMessage',
		'hasErrors',
		'targetClassName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #settings }
SSTestShifter class >> defaultInterpreterClass [
	^ SSMetaInterpreter
]

{ #category : #settings }
SSTestShifter class >> defaultMethodsClass [
	^ SSNullMethods
]

{ #category : #settings }
SSTestShifter class >> defaultPrinterClass [
	^ SSStandardPrinter
]

{ #category : #settings }
SSTestShifter class >> limitToWait [
	^ 1000
]

{ #category : #settings }
SSTestShifter class >> resetToDefaults [

	{ #defaultInterpreterClass -> SSMetaInterpreter . 
	#defaultMethodsClass -> SSNullMethods . 
	#defaultPrinterClass -> SSStandardPrinter .
	#limitToWait -> 1000 } do: [ :val |
		self class compile: val key asString, String cr, '	^ ', val value printString ]
]

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeArgsFor: aMessageStatement [
	|copy newArgs|
	
	copy := aMessageStatement copy.
	newArgs := OrderedCollection new.
	copy args do:[ :arg|
		|alternatives|
		alternatives := self alternativeOfVariables: arg.
		alternatives isEmpty ifTrue:[
				newArgs add: arg.
			] ifFalse: [ 
				newArgs add: alternatives pickAny.
		].
	].
	copy args: newArgs.
	self addAssignment: copy.
]

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeFactoryMessage: aFactoryMessage [
	| returnType receiverType|
	
	returnType := aFactoryMessage returnType.
	receiverType := aFactoryMessage receiver returnType.
	^ (typeInfo factoryMessagesFrom: receiverType)
		detect: [ :meth | 
			meth returnType = returnType
				and: [ meth selector ~= aFactoryMessage selector ] ]
		ifFound: [ :meth | self addFactoryMessage: receiverType usingSelector: meth selector.] 
		ifNone:[ self serror:'there is not alternative factory method'].
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
			[ :meth | self addFieldAccessMessage: meth selector from: receiver returnType ] 
		ifNone:[	self	serror:
				'There is no alternative for fieldAccessMessage of selector: ', aFieldAccessMessage selector ].
]

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeReceiverFor: aMessageStatement [
	|alternatives copy|
	
	alternatives := self alternativeOfVariables: aMessageStatement receiver.
	alternatives ifEmpty: [ self serror:'there is not alternatives for the receiver' ].
	copy := aMessageStatement copy.
	copy receiver: alternatives pickAny. 
	self addAssignment: copy.
]

{ #category : #'mutation-change' }
SSTestShifter >> addAlternativeSelectorFor: aMessageStatement [
	| returnType receiverType|
	
	receiverType := aMessageStatement receiver returnType.
	returnType := aMessageStatement returnType.
	^ (self pickMessagesOf: receiverType)
		detect: [ :meth | 
			(meth returnType types includes:returnType)
				and: [ meth selector ~= aMessageStatement selector ] ]
		ifFound: [ :meth | self addMessage: meth selector from: receiverType ]
		ifNone: [ self serror: 'there is not alternative message'].
]

{ #category : #'building-actions' }
SSTestShifter >> addAssignment: anExpression [
	|assignment|
	
	assignment := self newAssignment: anExpression.
	self addStatement: assignment.
	^ assignment
]

{ #category : #'building-actions' }
SSTestShifter >> addFactoryMessage [
	| variables |
	
	variables := self objectVariables.
	variables ifNotEmpty: [ ^ self addFactoryMessage: (variables pickAny returnType) ].
	^ typeInfo noneAbstractClasses
		safelyPickAny:[ :class | self addFactoryMessage: class name fullClassNameSymbol.]
		ifNone:[ self serror: 'Cannot create a factoryMessage.' ].
	
	
]

{ #category : #'building-actions' }
SSTestShifter >> addFactoryMessage: symbol [

	^ self addAssignment: (self newFactoryMessage: symbol).
]

{ #category : #'building-actions' }
SSTestShifter >> addFactoryMessage: aClassName usingSelector: aSelector [
	|method|
	
	method :=  typeInfo classMethodType: aSelector from: aClassName.
	^ [ self addAssignment: (self newFactoryMessage: method from: aClassName) ]
		on: SError
		do: [ self addFactoryMessage: aClassName ]
]

{ #category : #'building-actions' }
SSTestShifter >> addFieldAccessMessage [
	| receiver method |
	
	receiver := self pickAnObjectVariable.
	method := self pickAccessorsOf: receiver returnType.
	method ifEmpty: [ self serror: 'Cannot create a field access message.' ].
	^ self addFieldAccessMessage: (self selectMethod: method) withReceiver: receiver.
	
]

{ #category : #'building-actions' }
SSTestShifter >> addFieldAccessMessage: selector from: returnType [
	| receiver accessors accessor|
	
	accessors := self pickAccessorsOf: returnType.
	accessor := accessors
		detect: [ :acc | acc selector = selector ]
		ifNone: [ self serror: 'None field access message of selector: ',
			selector asString,
			' matches with: ',
			returnType asString ].
	receiver := self pickOrCreateObjectVariableOf: returnType.
	^ self addFieldAccessMessage: accessor withReceiver: receiver
]

{ #category : #'building-actions' }
SSTestShifter >> addFieldAccessMessage: method withReceiver: receiver [
	|result|
	
	result := self addAssignment: (SFieldAccessMessage newFromReceiver: receiver copy andMethod: method).
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
	methods ifEmpty: [ self serror: 'There are no method typeInfos for: ' , receiver returnType , '.' ].
	^ self addMessage: (self selectMethod: methods) withReceiver: receiver.
]

{ #category : #'building-actions' }
SSTestShifter >> addMessage: selector from: receiverType [
	| receiver method methods |
	
	methods := (self pickMessagesOf: receiverType)
		, (typeInfo factoryMessagesFrom: receiverType).
	method := methods
		detect: [ :aMessage | aMessage selector = selector ]
		ifNone: [ self
				serror:
					'None message of selector: ', 
					selector asString,
					' matches with: ', 
					receiverType asString ].
	receiver := self pickOrCreateObjectVariableOf: receiverType.
	^ self addMessage: method withReceiver: receiver
]

{ #category : #'building-actions' }
SSTestShifter >> addMessage: method withReceiver: receiver [
	|result|
	
	result := self addAssignment: (self newMessage: method on: receiver).
	^ result
]

{ #category : #'building-actions' }
SSTestShifter >> addStatement: anExpression [

	self canAddStatement ifFalse: [ ^ self ]. 
	statements add: anExpression.
	self runWithoutAssertionsAndLastStatement.
	
]

{ #category : #'building-actions' }
SSTestShifter >> addStatementWithReturnType: aMultiTypeInfo [
	
	[ (self typeInfo isScalar: aMultiTypeInfo) 
			ifTrue:[ self addLiteral: aMultiTypeInfo.] 
			ifFalse:[ self addFactoryMessage: aMultiTypeInfo.]. ]
	on: SError 
	do: [ :e | self serror:'we could not build the argument needed']
]

{ #category : #'building-actions' }
SSTestShifter >> addStatements: collStatements [

	self
		assert: statements isEmpty
		description: 'statements must be empty'.
	collStatements do: [ :stm | self addStatement: stm ]
]

{ #category : #querying }
SSTestShifter >> allVarNames [

	^ statements collect: [ :stm | stm reference printString ]
]

{ #category : #querying }
SSTestShifter >> alternativeOfVariables: aVariable [

	^ self statements select:[ :stm|
		((stm returnType = aVariable returnType) and: [ (stm variable containsVariable: aVariable) not ])
	] thenCollect:[ :stm | stm variable].
	
	
]

{ #category : #action }
SSTestShifter >> analyze [
   " we use a meta interpreter to use smalltalk and interpret our AST"

   |context|

   context := self runWithoutAssertions.
   self hasErrors ifTrue: [ self serror: 'Execution error' ].
	^ context
]

{ #category : #accessing }
SSTestShifter >> assertions [

	^ assertions
]

{ #category : #action }
SSTestShifter >> assignId [
	| idToAssign|
	
	idToAssign := nextId.
	nextId := nextId + 1.
	^ idToAssign
]

{ #category : #querying }
SSTestShifter >> assignedIds [

	^ statements collect: #id
]

{ #category : #'building-actions' }
SSTestShifter >> buildArgs: argTypes [

	^ argTypes collect:[ :type|
		|arg vars validArgs|
		validArgs := type cleanTypesIn: self typeInfo.
		validArgs ifEmpty: [self serror: 'Types required not exist in typeInfo'].
		arg := validArgs pickAny.
		vars := self variablesWithReturnType: arg .
		(vars isEmpty or: [self next < 0.3]) ifTrue: [ 
			self addStatementWithReturnType: arg.
			vars := self variablesWithReturnType: arg].
		vars pickAny]. 
	
	

]

{ #category : #querying }
SSTestShifter >> canAddStatement [

	self printerClass hasLimit 
		ifTrue: [
			^ ((self length + 3) < CompiledMethod fullFrameSize)].
	^ true
]

{ #category : #'mutation-change' }
SSTestShifter >> changeStatement [

	^ (1 to: self length) asOrderedCollection safelyPickAny: [ :index|
			self changeStatementAt: index.
		] ifNone:[ 
			self serror:'There is not an statement that could be created with the current arguments'].
]

{ #category : #'mutation-change' }
SSTestShifter >> changeStatementAt: index [
	"only for testing"
	
	|copy chgStm|
	
	copy := self emptyCopy.
	1 to: (index-1) do: [:i |
		|stm|
		stm := self statements at: i.
		copy addStatement: stm copy.
		copy assignId.].
	"if I add args i make sure they have unique names"
	copy nextId: self nextId + 1.
	chgStm := (self statements at: index).
	chgStm  changeOn: copy.
	"make sure that the last statement has the same id than the changed statement, i suppose to have the same type result, or trigger an error"
	copy statements last variable id: chgStm variable id.
	
	(index+1) to: self length do: [:i |
		|stm|
		stm := self statements at: i.
		copy addStatement: stm copy.
		copy assignId.].
	copy repairIds.
	^ copy.
	
]

{ #category : #action }
SSTestShifter >> clean [
	"|literals unused|
	literals := self statements select: [ :e | (e value isKindOf: SLiteral) or: [ e value isKindOf: SFactoryMessage ] ].
	unused := literals difference: (literals select: 
		[ :e | (self statements collect: 
			[:stm | stm pickUpReferences: e]) anySatisfy: [ :x | x isNotEmpty  ]]).
	unused do: [ :stm | self removeStatement: stm ]"
]

{ #category : #querying }
SSTestShifter >> containsVariable: aVariable [

	^ self statements anySatisfy: [ :stm | stm variable = aVariable].
]

{ #category : #querying }
SSTestShifter >> containsVariableWithReturnType: aClassName [

	^ self statements anySatisfy: [ :stm | stm returnType = aClassName].
]

{ #category : #'mutation-insert' }
SSTestShifter >> copyWithANewMethodCallToAnArgumentOfTheTargetClass [

	|copy indexs pair insertionIndex argumentFactoryIndex messageIndex receiver methods|
	
	copy := self emptyCopy.
	indexs := self targetClassArgumentIndexs.
	indexs ifEmpty: [ self serror:'there is object arguments']. "we can not do it"
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
	methods ifEmpty: [ self serror: 'There are no method typeInfos for: ' , receiver returnType , '.' ].
	copy addMessage: methods pickAny withReceiver: receiver.
	"adding the rest of statements"
	(insertionIndex +1) to: self length do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.
		copy assignId.].
	"no we got un ordered ids... because we put bigger ides in the middel to avoid collision, so we will fix the ides"
	^ copy.
	
]

{ #category : #'mutation-insert' }
SSTestShifter >> copyWithANewMethodCallToAnyValue [

	|copy indexs insertionIndex factoryIndex receiver methods|

	copy := self emptyCopy.
	indexs := self noTargetClassIndexs.
	indexs ifEmpty: [ self serror:'there is not object besides target class']. "we can not do it"
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
	methods ifEmpty: [ self serror: 'There are no method typeInfos for: ' , receiver returnType , '.' ].
	copy addMessage: methods pickAny withReceiver: receiver.
	"adding the rest of statements"
	(insertionIndex +1) to: self length do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.
		copy assignId.].
	^ copy.
	
]

{ #category : #'mutation-insert' }
SSTestShifter >> copyWithANewMethodCallToTargetClass [

	|copy indexs insertionIndex factoryIndex receiver methods|
	
	copy := self emptyCopy.
	indexs := self targetClassIndexs.
	indexs ifEmpty: [ self serror:'No target class object has found']. "we can not do it"
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
	methods ifEmpty: [ self serror: 'There are no method typeInfos for: ' , receiver returnType , '.' ].
	copy addMessage: methods pickAny withReceiver: receiver.
	"adding the rest of statements"
	(insertionIndex+1) to: self length do:[ :i|
		|statement|
		statement := self statements at: i.
		copy addStatement: statement copy.
		copy assignId.].
	^ copy.
]

{ #category : #'mutation-insert' }
SSTestShifter >> copyWithARandomStatement [

	|val|

	val := self random next.
	(val <= 0.3) ifTrue:[ ^ self copyWithANewMethodCallToTargetClass.].
	(val <= 0.6) ifTrue:[ ^ self copyWithANewMethodCallToAnyValue.].
	(val <= 1) ifTrue:[ ^ self copyWithANewMethodCallToAnArgumentOfTheTargetClass.].
	^ self serror:'We could not insert any statement'.
]

{ #category : #copying }
SSTestShifter >> emptyCopy [
	| copy |
	
	copy := self class with: typeInfo copy.
	copy targetClassName: targetClassName.
	^ copy
]

{ #category : #action }
SSTestShifter >> execute: aBlock [

	^ self methodsClass 
		on: self 
		execute: aBlock
]

{ #category : #'building-actions' }
SSTestShifter >> generateAssertions [

	^ self
		generateAssertions:
			(Array with: SComparisonAssertion
			with: SInspectorAssertion
			with: SPrimitiveAssertion
			with: SStringAssertion)
]

{ #category : #'building-actions' }
SSTestShifter >> generateAssertions: classAssertions [
	"
	it analyze each kind of assertion an generate a set of assertion based on the test case -- double dispatch
	"

	| executionContext |
	
	executionContext := self execute: [:testCase | testCase analyze].
	assertions := classAssertions
		flatCollect: [ :assertion | assertion for: executionContext ]. 
]

{ #category : #'building-actions' }
SSTestShifter >> generateStatements [
	| flag counter |
	
	flag := true.
	counter := 0.
	self assert: typeInfo types isNotEmpty description: 'TypeInfo does not contain info at all.'.
	[ flag and: [ self length < self maxNumberOfStatements ] ] 
		whileTrue: [ | array |
			array :=  (OrderedCollection 
						with: #addMessage 
						with:  #addFieldAccessMessage) randomShuffle.
     	   array
				detect: [:selector |  
					[ (self perform: selector) isNotNil ] on: SError do: [:e | false ] ] 
				ifNone: [ 
					counter := counter + 1.
               counter > self maxNumberOfStatements 
						ifTrue: [ 
							flag := false.
       	            self serror: 'Not able to generate statements' ] 
				] 
		]
]

{ #category : #'building-actions' }
SSTestShifter >> generateStatements: anInteger [

	self maxNumberOfStatements: anInteger.
	self generateStatements.
	
]

{ #category : #accessing }
SSTestShifter >> hasErrors [

	^ hasErrors
]

{ #category : #action }
SSTestShifter >> hasErrors: aBoolean [

	hasErrors := aBoolean 
]

{ #category : #initalize }
SSTestShifter >> initialize [

  super initialize.
  statements := OrderedCollection new.
  assertions := OrderedCollection new.
  nextId := 0.
  maxNumberOfStatements := 10.
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

{ #category : #accessing }
SSTestShifter >> interpreterClass [
	"return the default interpreter"

	^ self class defaultInterpreterClass.
]

{ #category : #util }
SSTestShifter >> invariant [

	self typeInfo
		ifNil: [ self
				error: 'TypeInfo is nil. Set the testCase with a typeInfo' ]
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
SSTestShifter >> lastStatements [

	lastMessage ifNil: [ ^ #() ].
	^ lastMessage isSequence
		ifTrue: [ lastMessage messages ]
		ifFalse: [ Array with: lastMessage  ]
]

{ #category : #accessing }
SSTestShifter >> lastTemporaries [

	^ lastMessage isSequence
		ifTrue: [ lastMessage temporaries ]
		ifFalse: [ #() ]
]

{ #category : #accessing }
SSTestShifter >> length [

	^ statements size
]

{ #category : #accessing }
SSTestShifter >> maxNumberOfStatements [

	^ maxNumberOfStatements
]

{ #category : #accessing }
SSTestShifter >> maxNumberOfStatements: anObject [

	maxNumberOfStatements := anObject
]

{ #category : #accessing }
SSTestShifter >> methodsClass [

	^ self class defaultMethodsClass
]

{ #category : #'instance creation' }
SSTestShifter >> newAssignment: anExpression [

	^ SAssignment
		name:
			(SVariable new
				varName: '_var';
				id: self assignId;
				returnType: anExpression returnType;
				yourself)
		value: anExpression copy.
]

{ #category : #'instance creation' }
SSTestShifter >> newFactoryMessage: aClassName [
	| methods|
	
	(typeInfo
		classAt: aClassName
		ifNone: [ self serror: 'Error to create factoryMessage of: ' , aClassName , ' because it is not found in typeInfo.' ]) 
		isAbstract ifTrue: [ self serror: 'Error to create factoryMessage of: ' , aClassName , ' because it is abstract.'].
	methods := typeInfo factoryMessagesFrom: aClassName.
	methods ifNotEmpty: [ [ ^ self newFactoryMessage: methods pickAny from: aClassName ]
		on: SError
		do: [:e | nil ]].
	^ SFactoryMessage default: aClassName
]

{ #category : #'instance creation' }
SSTestShifter >> newFactoryMessage: method from: aClassName [

	^ SFactoryMessage new
			receiver: (SVariable new
				varName: aClassName;
				returnType: aClassName;
				yourself);
			selector: method selector;
			args: (self buildArgs: method argTypes);
			returnType: aClassName;
			yourself.
				
	
]

{ #category : #'instance creation' }
SSTestShifter >> newLiteral: aClassName [

	typeInfo scalars
		at: aClassName
		ifPresent: [ :values | 
			values
				ifEmpty: [ self serror: 'Scalar of type: ' , aClassName , ' is empty.' ].
			^ SLiteral new
				returnType: aClassName;
				value: (self random selectAtRandom: values asOrderedCollection) copy].
	self serror: 'Scalars dont include: ' , aClassName
]

{ #category : #'instance creation' }
SSTestShifter >> newMessage: method on: receiver [

	^ SMessage new
			receiver: receiver;
			selector: method selector;
			args: (self buildArgs: method argTypes);
			returnType: method returnType types first.
				
]

{ #category : #accessing }
SSTestShifter >> nextId [

	^ nextId
]

{ #category : #accessing }
SSTestShifter >> nextId: newId [

	nextId := newId.
]

{ #category : #querying }
SSTestShifter >> noTargetClassIndexs [
	|indexs|
	
	indexs := OrderedCollection new.
	self statements doWithIndex:[ :stm :index|
		(stm value isFactoryMessage and:[stm returnType ~= self targetClassesName]) ifTrue:[ indexs add: index.].
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
SSTestShifter >> pickOrCreateObjectVariableOf: aClassName [
	|variables|
	
	variables := self objectVariables select:[ :var| var returnType = aClassName].
	variables ifEmpty: [
		self addFactoryMessage: aClassName.
		variables := self objectVariables select:[ :var| var returnType = aClassName].].
	^ variables pickAny.
	
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
SSTestShifter >> printerClass [

	^ self class defaultPrinterClass.
]

{ #category : #querying }
SSTestShifter >> randomLiteralClassName [
	|scalars|
	
	scalars := typeInfo scalars keys.
	scalars ifEmpty: [ self serror: 'TypeInfo does not have scalars. Set scalars on typeInfo.' ].
	^ scalars asArray pickAny.
]

{ #category : #'mutation-remove' }
SSTestShifter >> removeStatement [

	^ self removeStatementAt: (self random nextInt: self length).
]

{ #category : #'mutation-remove' }
SSTestShifter >> removeStatementAt: index [
	|deletedVariables copy|
	
	self length = 0 ifTrue:[self serror:'there is not statements to delete'].
	copy := self emptyCopy.
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
			(stm isThereEnoughArgumentsToBuild: copy) ifTrue:[
				"if this insert new argument then the argumetns and the same statement will have different names"
				stm insertOn: copy.
				"make sure that the last statement has the same id, because the rest of statement may depende of him"
				copy statements last variable id: stm variable id.
			]ifFalse:[deletedVariables add: stm variable. ]
		] ifFalse:[
			copy addStatement: stm copy.		
		]
	].
	^ copy.
	
]

{ #category : #action }
SSTestShifter >> repairIds [

	SSVariableNameSwapper repairNamesOf: self.
]

{ #category : #action }
SSTestShifter >> run [

	^ self execute: [ :testCase |
			testCase runStatements: testCase statements", testCase assertions." ]
]

{ #category : #action }
SSTestShifter >> runStatements: aStatementCollection [
  " we use a meta interpreter to use smalltalk and interpret our AST"

 	|interpreter semaphore timeOut process result|
	
	interpreter := self interpreterClass new.
	hasErrors := true.
	semaphore := Semaphore new.
  
	process := [
		[
			interpreter visitStatements: aStatementCollection; clean.
			hasErrors := false.
			result := interpreter context.
			semaphore signal.
		] on: Error 
		do: [ :e|
			result := Dictionary new.
			semaphore signal. ] ] fork.
	timeOut := semaphore waitTimeoutMSecs: 1000.
	timeOut ifTrue:[
		process terminate.
		result := Dictionary new.
		self halt.].
	^ result.
	
	
]

{ #category : #action }
SSTestShifter >> runWithoutAssertions [

	^ self execute: [ :testCase |
			testCase runStatements: testCase statements, testCase lastStatements. ]
]

{ #category : #action }
SSTestShifter >> runWithoutAssertionsAndLastStatement [

	^ self execute: [ :testCase |
			testCase runStatements: testCase statements. ]
]

{ #category : #accessing }
SSTestShifter >> statementAt: statement [

	statements
		detect: [ :stm | stm = statement ]
		ifFound: [ :stm | ^ stm ].
	self
		serror: 'Statement: ' , statement printString , ' is not found in testCase.'
]

{ #category : #accessing }
SSTestShifter >> statementOfVarName: aString [

	statements
		detect: [ :stm | stm reference printString = aString ]
		ifFound: [ :stm | ^ stm ].
	self serror: 'Statement of varName: ' , aString, 'is not found.'
]

{ #category : #accessing }
SSTestShifter >> statements [

	^ statements
]

{ #category : #querying }
SSTestShifter >> targetClassArgumentIndexs [
	|indexs|
	
	indexs := OrderedCollection new.
	self statements doWithIndex:[ :stm :index|
		(stm value isMessage and:[stm value receiver returnType = self targetClassesName]) ifTrue:[ 
			1 to: (index-1) do:[ :i|
				|stmAnt|
				stmAnt := (self statements at: i).
					( (self typeInfo isScalar: stmAnt returnType) not and:[ stm value containsVariable: stmAnt variable]) ifTrue:[
						indexs add: { i . index}.
					]	
				].
			].
		].
	^ indexs.
	
]

{ #category : #querying }
SSTestShifter >> targetClassIndexs [
	|indexs|
	
	indexs := OrderedCollection new.
	self statements doWithIndex:[ :stm :index|
		(stm value isFactoryMessage and:[stm returnType = self targetClassesName]) 
			ifTrue:[ indexs add: index.].
	].
	^ indexs.
	
]

{ #category : #accessing }
SSTestShifter >> targetClassName: aSymbol [

	typeInfo types at: aSymbol 
		ifAbsent: [ self serror: 'Class name: ', aSymbol, ' is not found in typeInfo' ].
	targetClassName := aSymbol.
]

{ #category : #accessing }
SSTestShifter >> targetClassesName [

	^ targetClassName
]

{ #category : #accessing }
SSTestShifter >> typeInfo [

	^ typeInfo
]

{ #category : #accessing }
SSTestShifter >> typeInfo: anObject [

	typeInfo := anObject
]

{ #category : #util }
SSTestShifter >> updateNextId [ 

	nextId = 0 ifTrue: [ nextId := statements size ]
]

{ #category : #util }
SSTestShifter >> validReferences [
	| references |
	
	references := Set new.
	^ statements
		detect: [ :stm | 
			| variables |
			variables := (SSVariablesWithIdCollector new visit: stm) variablesWithId asSet.
			references add: stm reference.
			(references includesAll: variables)
				ifFalse: [self halt. true ]
				ifTrue: [ references addAll: variables.
					false ] ]
		ifFound: [ false ]
		ifNone: [ true ]
]

{ #category : #querying }
SSTestShifter >> variablesWithReturnType: type [

	^ self statements 
		select: [:stm | stm returnType = type ] 
		thenCollect: [:stm |  stm variable ]
]
