Class {
	#name : #STestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'profile',
		'generatorInvariant',
		'dictSubclasses',
		'fitness',
		'nextId',
		'allowNullParameters',
		'refactorizer'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
STestCase class >> seed: aGeneratorProfile [
	| ins |
	ins := self new.
	ins profile: aGeneratorProfile.
	^ ins
]

{ #category : #generation }
STestCase >> addConstructor [
	^ self profile allClasses shuffle
		detect: [ :classSpy | self addConstructor: classSpy ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #generation }
STestCase >> addConstructor: classSpy [
	(classSpy methods select: #isAbstract)
		ifEmpty: [ ^ self addFactoryOrDefaultConstructor: classSpy ]
		ifNotEmpty: [ classSpy subclasses
				ifEmpty: [ ^ false ]
				ifNotEmpty: [ dictSubclasses
						at: classSpy className
						ifAbsentPut: (classSpy subclasses collect: [ :subc | subc className ]) asSet.
					^ self addConstructor: classSpy subclasses shuffle anyOne ] ]
]

{ #category : #accessing }
STestCase >> addConstructor: aStatement before: varName forField: toField [
	| list newStatement |
	toField
		ifTrue: [ list := self methodsOrAccessors: aStatement toSelect: true.
			list ifEmpty: [ ^ nil ] ]
		ifFalse: [ | classSpy |
			classSpy := profile classAt: aStatement theClassName.
			list := classSpy factoryMethods.
			list
				ifEmpty: [ | constructor |
					constructor := SAuxiliar defaultConstructor: classSpy.
					(self addStatement: constructor at: (self indexOf: varName))
						ifTrue: [ ^ constructor ].
					^ nil ] ].
	newStatement := self
		newConstructorStatement: aStatement theClassName
		of: list
		before: varName.
	(newStatement isNotNil
		and: [ self addStatement: newStatement at: (self indexOf: varName) ])
		ifTrue: [ ^ newStatement ].
	^ nil
]

{ #category : #generation }
STestCase >> addDefaultConstructor: classSpy [
	| statement |
	statement := SAuxiliar defaultConstructor: classSpy.
	self addStatement: statement.
	^ statement
]

{ #category : #adding }
STestCase >> addFactoryOrDefaultConstructor: classSpy [
| methods newStatement |
			methods := classSpy factoryMethods.
			methods
				ifEmpty: [ ^ (self addDefaultConstructor: classSpy) isNotNil ].
			newStatement := self
				newConstructorStatement: classSpy
				of: methods
				before: nil.
			newStatement ifNil: [ ^ false ].
			^ self addStatement: newStatement
]

{ #category : #generation }
STestCase >> addField [
	^ self
		addFieldOrMethodUsing: [ :accessor :stm | 
			^ self
				addStatement:
					(SFieldStatement new
						returnTypeName: accessor returnType name;
						receiverVarName: stm varName;
						fieldName: accessor selector;
						yourself) ]
		blockAnd: true
]

{ #category : #generation }
STestCase >> addFieldOrMethodUsing: aBlock blockAnd: aBoolean [
	| constructStatements |
	constructStatements := statements select: #isConstructor.
	constructStatements ifEmpty: [ ^ false ].
	constructStatements shuffle
		do: [ :stm | 
			| methodsOrAccessors |
			methodsOrAccessors := self methodsOrAccessors: stm toSelect: aBoolean.
			methodsOrAccessors
				ifNotEmpty: [ | selected |
					selected := methodsOrAccessors shuffle anyOne.
					aBlock
						valueWithArguments:
							{selected.
							stm} ] ].
	^ false
]

{ #category : #adding }
STestCase >> addFromParents: collStatements [
	self assert: statements isEmpty description: 'Statements must be empty'.
	statements addAll: collStatements.
]

{ #category : #generation }
STestCase >> addMethod [
	^ self
		addFieldOrMethodUsing: [ :method :stm | 
			| args |
			args := method argTypes
				collect: [ :class | self createArg: class name ].
			allowNullParameters
				ifFalse: [ (args anySatisfy: #isNil)
						ifTrue: [ ^ false ] ].
			^ self
				addStatement:
					(SMethodStatement new
						receiverVarName: stm varName;
						returnTypeName: method returnType name;
						selector: method selector;
						args: args;
						yourself) ] blockAnd: false
]

{ #category : #generation }
STestCase >> addPrimitive [
	^ SAuxiliar classLiterals
		detect: [ :className | 
			(self addPrimitive: className at: self numberOfStatements + 1)
				isNotNil ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #generation }
STestCase >> addPrimitive: aClassName at: position [
	| result scalar primitive |
	result := self createScalar: aClassName.
	result ifNil: [ ^ nil ].
	scalar := result first.
	primitive := SPrimitiveStatement new
		returnTypeName: result second;
		value: scalar;
		yourself.
	^ (self addStatement: primitive at: position)
		ifTrue: [ primitive varName ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
STestCase >> addStatement: aStatement [
	^ self addStatement: aStatement at: self numberOfStatements + 1

]

{ #category : #accessing }
STestCase >> addStatement: aStatement at: position [
	self assert: aStatement id isNil description: 'The id of new statement must be nil to assign a new one'.
	aStatement id: self assignId.
	statements isEmpty
		ifTrue: [ statements add: aStatement ]
		ifFalse: [ [ statements add: aStatement afterIndex: (position > 1 ifTrue: [position - 1] ifFalse: [0]) ]
				on: Error
				do: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
STestCase >> allowNullParameters [
	^ allowNullParameters
]

{ #category : #accessing }
STestCase >> allowNullParameters: anObject [
	allowNullParameters := anObject
]

{ #category : #'as yet unclassified' }
STestCase >> assignId [
	| idToAssign assignedIds |
	assignedIds := self assignedIds.
	[ assignedIds includes: nextId ] whileTrue: [ nextId := nextId + 1 ].
	idToAssign := nextId.
	nextId := nextId + 1.
	^ idToAssign
]

{ #category : #accessing }
STestCase >> assignedIds [
	^ statements collect: #id 
]

{ #category : #accessing }
STestCase >> calledMethods [
	^ self statements
		select: #isMethod
		thenCollect: [ :method | method selector ]
]

{ #category : #mutation }
STestCase >> change [
	statements ifEmpty: [ ^ #() ].
^ self
				change:
					(statements
						at: (SAuxiliar randomNumberFrom: 1 to: statements size))
						varName
]

{ #category : #mutation }
STestCase >> change: varName [
	| statementToChange varNamesToChange statementsCopy |
	statementToChange := statements
		detect: [ :stm | stm varName = varName ]
		ifFound: [ :stm | stm ]
		ifNone: [ ^ #() ].
	varNamesToChange := OrderedCollection new.
	statementsCopy := statements deepCopy.
	statementsCopy
		do: [ :statement | 
			varNamesToChange
				addAll: (statement repairOn: self changing: statementToChange) ].
	varNamesToChange do: [ :aName | self change: aName ].
	^ { varName }, varNamesToChange 
]

{ #category : #removing }
STestCase >> changeStatementsOfClassName: aClassName [
	| constructors changed |
	constructors := self statements select: #isConstructor.
	constructors ifEmpty: [ ^ false ].
	changed := true.
	constructors
		select: [ :aStm | aStm theClassName = aClassName ]
		thenDo:
			[ :aStm | changed := changed and: [ (self change: aStm varName) isNotEmpty ] ].
	^ changed
]

{ #category : #'as yet unclassified' }
STestCase >> computeFitnessUsing: fitnessBlock [
	fitness := fitnessBlock value: self
]

{ #category : #'as yet unclassified' }
STestCase >> create: aArg argBefore: position [
	| stm  |
	stm := self statementAt: aArg.
	^ self
						addPrimitive:
							(stm isConstructor
								ifTrue: [ stm theClassName ]
								ifFalse: [ stm returnTypeName ])
						at:
							(SAuxiliar
								randomNumberFrom: 1
								to: position - 1
								default: position - 1).
]

{ #category : #generation }
STestCase >> createArg: aClassName [
	^ self
		createArg: aClassName
		before: statements size + 1
		avoiding: nil
]

{ #category : #generation }
STestCase >> createArg: aClassName before: stop avoiding: varName [
	| result candidates |
	candidates := OrderedCollection new.
	statements
		withIndexDo: [ :stm :index | 
			(index < stop and: [ stm varName ~= varName ])
				ifTrue: [ candidates add: stm ] ].
	result := SAuxiliar
		createStatementOf: aClassName
		typeIn: self
		testCaseUsing: candidates.
	result ifNil: [ result := self createScalar: aClassName ].
	result ifNotNil: [ ^ result first ].
	^ result
]

{ #category : #generation }
STestCase >> createScalar: aClassName [
	self profile scalars
		at: aClassName
		ifPresent: [ :value | 
			^ {(SAuxiliar listShuffle: value) first.
			aClassName} ]
		ifAbsent: [ ^ SAuxiliar
				valueOf: aClassName
				typeIn: self
				testCaseUsing: self profile scalars ]
]

{ #category : #accessing }
STestCase >> dictSubclasses [
	^ dictSubclasses 
]

{ #category : #accessing }
STestCase >> fitness [
	^ fitness
]

{ #category : #'as yet unclassified' }
STestCase >> generateAssertionsUsing: classInvariants [
	^ generatorInvariant
		generateAssertionsOf: self
		testCaseUsing: classInvariants
]

{ #category : #'as yet unclassified' }
STestCase >> generateStatements [
	self generateStatements: 54
]

{ #category : #'as yet unclassified' }
STestCase >> generateStatements: aNumber [
	[ self statements size < aNumber ]
		whileTrue: [ [ self
				perform: #(#addConstructor #addField #addMethod #addPrimitive) shuffle anyOne ]
				on: Error
				do: [  ] ]
]

{ #category : #'as yet unclassified' }
STestCase >> hasUniqueStatements [
	^ self numberOfStatements = self varNames asSet size
]

{ #category : #'as yet unclassified' }
STestCase >> hasValidDependencies [
	^ SAuxiliar
		validDependenciesOf: statements
		statementsUsing: self varNames
]

{ #category : #accessing }
STestCase >> indexOf: varName [
	self varNames withIndexDo: [ :aVar :index | 
		aVar = varName ifTrue: [ ^ index ]	
	].
	^ -1
]

{ #category : #initialization }
STestCase >> initialize [
	super initialize.
	nextId := 0.
	statements := OrderedCollection new.
	generatorInvariant := SSGeneratorInvariant new.
	dictSubclasses := Dictionary new.
	allowNullParameters := false.
	refactorizer := SRefactorizer new
]

{ #category : #'accessing untypeable characters' }
STestCase >> insert [
	| l stop varNames alpha count random varNamesInserted |
	statements ifEmpty: [ ^ #() ].
	l := 1.
	count := 0.
	stop := self numberOfStatements.
	alpha := 0.5.
	varNamesInserted := OrderedCollection new.
	random := Random new seed: DateAndTime current nanoSecond / 100.
	[ l < stop and: [ random next <= (alpha raisedTo: count) ] ]
		whileTrue: [ varNames := self insertRandomStatement.
			varNames ifNotNil: [ varNamesInserted addAll: varNames ].
			l := l + 1.
			count := count + 1 ].
	^ varNamesInserted
]

{ #category : #'as yet unclassified' }
STestCase >> insert: selector [
	| varNames copyStatements |
	copyStatements := statements deepCopy.
	copyStatements shuffle
		detect: [ :stmToInsert | 
			varNames := stmToInsert perform: selector with: self.
			varNames isNotNil ]
		ifFound: [ 
			^ varNames ].
	^ nil
]

{ #category : #'as yet unclassified' }
STestCase >> insert: aStatement statementWithArgsBefore: varName [
	| args newStatement newPosition addedList block |
	args := aStatement args.
	addedList := #().
	block := [ varName
		ifNil: [ 1 ]
		ifNotNil: [ (self indexOf: varName) + 1 ] ].
	newPosition := SAuxiliar
		randomNumberFrom: block value
		to: self numberOfStatements.
	args
		ifNotEmpty: [ | newArgs |
			newArgs := self
				satisfyParametersOf: args
				before: newPosition
				allowingNull: allowNullParameters.
			addedList := newArgs asArray.
			newPosition := SAuxiliar 
				positionToInsertAfter: block value
				indexStatementOf: self
				testCaseHaving: newArgs ].
	newStatement := aStatement createNewStatement
		args: addedList;
		yourself.
	(self addStatement: newStatement at: newPosition)
		ifTrue: [ ^ addedList , {newStatement varName} ].
	^ nil
]

{ #category : #'as yet unclassified' }
STestCase >> insertRandomStatement [
	| varNamesInserted |
	#(#insertRandomCallUsing: #insertMethodCallUsing: #insertParameterUsing:)
		shuffle
		detect: [ :selector | 
			varNamesInserted := self insert: selector.
			varNamesInserted isNotNil ]
		ifFound: [ ^ varNamesInserted ]
		ifNone: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
STestCase >> methodsOrAccessors: aStatement toSelect: aBoolean [
	| methods |
	methods := [(self profile >> aStatement theClassName) methods] on: Error do: [#()].
	methods := aBoolean ifTrue: [ methods select: #isQuick ] ifFalse: [ methods reject: #isQuick ].
	methods := methods select: [ :m | m returnType notNil ].
	^ methods
]

{ #category : #generation }
STestCase >> newConstructorStatement: classSpy of: methodList before: varName [
	| selected args selector |
	methodList
		ifEmpty: [ args := #().
			selector := 'new' ]
		ifNotEmpty: [ selected := methodList shuffle anyOne.
			args := selected argTypes
				collect: [ :class | 
					varName
						ifNil: [ self createArg: class name ]
						ifNotNil: [ self
								createArg: class name
								before: (self indexOf: varName)
								avoiding: nil ] ].
			allowNullParameters
				ifFalse: [ (args anySatisfy: #isNil)
						ifTrue: [ ^ nil ] ].
			selector := selected selector ].
	^ SAuxiliar
		newConstructorOf: classSpy
		classNameWith: selector
		selectorAnd: args
]

{ #category : #accessing }
STestCase >> numberOfStatements [
	^ statements size
]

{ #category : #'as yet unclassified' }
STestCase >> prettyCodeApplying: kindsRefactoring [
	^ refactorizer prettyCodeOf: self testCaseApplying: kindsRefactoring 
]

{ #category : #printing }
STestCase >> printOn: aStream [
	statements
		do: [ :stm | 
			stm printOn: aStream.
			aStream cr. ]
]

{ #category : #accessing }
STestCase >> profile [
	^ profile.
]

{ #category : #accessing }
STestCase >> profile: anObject [
	profile := anObject
]

{ #category : #mutation }
STestCase >> remove [
	statements ifEmpty: [ ^ #() ].
	 ^ self
				remove:
					(statements
						at: (SAuxiliar randomNumberFrom: 1 to: statements size))
						varName
]

{ #category : #mutation }
STestCase >> remove: varName [
	| statementToDelete varNamesToDelete statementsCopy |
	statementToDelete := self statementAt: varName.
	statementToDelete ifNil: [ ^ nil ].
	varNamesToDelete := OrderedCollection new.
	statementsCopy := statements deepCopy.
	statementsCopy
		do: [ :stm | 
			varNamesToDelete
				addAll: (stm repairOn: self deleting: statementToDelete) ].
	statements remove: statementToDelete.
	varNamesToDelete do: [ :aName | self remove: aName ].
	^ {varName}, varNamesToDelete
]

{ #category : #removing }
STestCase >> removeNumStatements: aNumber [
	| removed |
	removed := true.
	1 to: aNumber do: [ :number | 
		removed := removed and: [self remove isNotEmpty].	
	].
	^ removed
]

{ #category : #'as yet unclassified' }
STestCase >> satisfyParametersOf: args before: position allowingNull: aBoolean [
	| argsResult varNames |
	argsResult := OrderedCollection ofSize: args size.
	varNames := self varNames.
	args
		withIndexDo: [ :aArg :index | 
			(varNames includes: aArg)
				ifTrue: [ | newArg |
					newArg := self create: aArg argBefore: position.
					argsResult
						at: index
						put:
							(newArg
								ifNotNil: [ newArg ]
								ifNil: [ aBoolean
										ifTrue: [ nil ]
										ifFalse: [ aArg ] ]) ]
				ifFalse: [ argsResult at: index put: aArg mutateToChange ] ].
	^ argsResult
]

{ #category : #accessing }
STestCase >> statementAt: varName [
	statements
		detect: [ :aStm | 
			aStm varName = varName ]
		ifFound: [ :aStm | ^ aStm ].
	^ nil
]

{ #category : #accessing }
STestCase >> statements [
	^ statements
]

{ #category : #'as yet unclassified' }
STestCase >> varNames [
	^ statements collect: #varName
]
