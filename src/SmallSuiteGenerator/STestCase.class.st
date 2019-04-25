Class {
	#name : #STestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'profile',
		'generatorInvariant',
		'dictSubclasses',
		'fitness',
		'nextId'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
STestCase class >> create: numberOfTestCases testCasesAndInitialize: numberOfStatements statementsUsing: profiler [
	| collection testCase |
	collection := OrderedCollection new.
	1 to: numberOfTestCases do: [ :index | 
		testCase := self new.
		testCase profile: profiler.
		testCase generateStatements: numberOfStatements.
		collection add: testCase ].
	^ collection
]

{ #category : #'instance creation' }
STestCase class >> createTestSuite: aGeneratorProfile ofSize: aNumber [
	| collection testCase |
	collection := OrderedCollection new.
	1 to: aNumber do: [ :index | 
		testCase := self new.
		testCase profile: aGeneratorProfile.
		testCase generateStatements: (10 to: 54) atRandom.
		collection add: testCase ].
	^ collection
]

{ #category : #'instance creation' }
STestCase class >> seed: aGeneratorProfile [
	| ins |
	ins := self new.
	ins profile: aGeneratorProfile.
	^ ins
]

{ #category : #adding }
STestCase >> add: collStatements fromParentWith: collIds. [
	self assert: statements isEmpty description: 'Statements must be empty'.
	"self assert: assignedIds isEmpty description: 'AssignedIds must be empty'."
	statements addAll: collStatements.
	"assignedIds addAll: collIds."
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
	(classSpy methods select: #isAbstract) isNotEmpty 
		ifTrue: [ classSpy subclasses
				ifEmpty: [ ^ false ]
				ifNotEmpty: [ dictSubclasses
						at: classSpy className
						ifAbsentPut: (classSpy subclasses collect: [ :subc | subc className ]) asSet.
					^ self addConstructor: classSpy subclasses shuffle anyOne ] ]
		ifFalse: [ | methods newStatement |
			methods := classSpy factoryMethods.
			methods
				ifEmpty: [ ^ (self addDefaultConstructor: classSpy) isNotNil ].
			newStatement := self
				newConstructorStatement: classSpy
				of: methods
				before: nil.
			newStatement ifNil: [ ^ false ].
			^ self addStatement: newStatement ]
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
					constructor := self defaultConstructor: classSpy.
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
	statement := self defaultConstructor: classSpy.
	self addStatement: statement.
	^ statement
]

{ #category : #generation }
STestCase >> addField [
	| constructStatements |
	constructStatements := statements select: #isConstructor.
	constructStatements ifEmpty: [ ^ false ].
	constructStatements shuffle
		do: [ :stm | 
			| accessors |
			accessors := self methodsOrAccessors: stm toSelect: true.
			accessors
				ifNotEmpty: [ | selected |
					selected := accessors shuffle anyOne.
					^ self
						addStatement:
							(SFieldStatement new
								returnTypeName: selected returnType name;
								receiverVarName: stm varName;
								fieldName: selected selector;
								yourself) ] ].
	^ false
]

{ #category : #generation }
STestCase >> addMethod [
	| constructStatements |
	constructStatements := statements select: #isConstructor.
	constructStatements ifEmpty: [ ^ false ].
	constructStatements shuffle
		do: [ :stm | 
			| methods |
			methods := self methodsOrAccessors: stm toSelect: false.
			methods
				ifNotEmpty: [ | selected args |
					selected := methods shuffle anyOne.
					args := selected argTypes
						collect: [ :class | self createArg: class name ].
					(args anySatisfy: #isNil)
						ifFalse: [ ^ self
								addStatement:
									(SMethodStatement new
										receiverVarName: stm varName;
										returnTypeName: selected returnType name;
										selector: selected selector;
										args: args;
										yourself) ] ] ].
	^ false
]

{ #category : #generation }
STestCase >> addPrimitive [
	^ self classLiterals
		detect: [ :className | self addPrimitive: className ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #generation }
STestCase >> addPrimitive: aClassName [
	| result scalar |
	result := self createScalar: aClassName.
	result ifNil: [ ^ false ].
	scalar := result first.
	^ self
		addStatement:
			(SPrimitiveStatement new
				returnTypeName: result second;
				value: scalar;
				yourself)
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
	"statements add: aStatement.
	^ true"
]

{ #category : #accessing }
STestCase >> addStatement: aStatement at: position [
	self assert: aStatement id isNil description: 'The id of new statement must be nil to assign a new one'.
	aStatement id: self assignId.
	statements isEmpty
		ifTrue: [ statements add: aStatement ]
		ifFalse: [ [ statements add: aStatement afterIndex: position - 1 ]
				on: Error
				do: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
STestCase >> applyMutator [
	^ statements isNotEmpty 
]

{ #category : #'as yet unclassified' }
STestCase >> assignId [
	| idToAssign assignedIds |
	assignedIds := self assignedIds.
	[ assignedIds includes: nextId ] whileTrue: [ nextId := nextId + 1 ].
	idToAssign := nextId.
	"assignedIds add: idToAssign."
	nextId := nextId + 1.
	^ idToAssign
]

{ #category : #accessing }
STestCase >> assignedIds [
	^ statements collect: #id 
]

{ #category : #mutation }
STestCase >> change [
	self applyMutator
		ifFalse: [ ^ #() ]
		ifTrue: [ ^ self
				change:
					(statements
						at: (STransformValue randomNumberFrom: 1 to: statements size default: 1))
						varName ]
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
STestCase >> classLiterals [
	^ #(#Array #Boolean #ByteArray #Character #Float #Integer #ScaledDecimal #String #UndefinedObject)
		shuffle
]

{ #category : #'as yet unclassified' }
STestCase >> classOfArgs: method [
	^ method argTypes
						collect: [ :class | class name ]
]

{ #category : #'as yet unclassified' }
STestCase >> cleanIrrelevantStatements [
	| dataStatements varNamesToRemove dictStringStatement referencedVarNames removedVarNames |
	dataStatements := STransformValue dataStatements: statements.
	dictStringStatement := dataStatements first.
	referencedVarNames := dataStatements second.
	varNamesToRemove := OrderedCollection new.
	removedVarNames := OrderedCollection new.
	statements
		do: [ :aStatement | 
			(aStatement
				notReferenced: referencedVarNames
				orIrrelevant: dictStringStatement)
				ifTrue: [ varNamesToRemove add: aStatement varName ] ].
	varNamesToRemove
		do: [ :varName | removedVarNames addAll: (self remove: varName) ].
	^ removedVarNames
]

{ #category : #'as yet unclassified' }
STestCase >> computeFitnessUsing: fitnessBlock [
	fitness := fitnessBlock value: self
]

{ #category : #metric }
STestCase >> coverageOnClass: aClass [
	^ SCalculatorCoverage new
		coverageTestCase: self
		onClass: aClass
]

{ #category : #metric }
STestCase >> coverageOnClass: aClass using: profiler [
	^ SCalculatorCoverage new coverageTestCase: self onClass: aClass
]

{ #category : #metric }
STestCase >> coverageOnPackagesMatching: regex [
	^ SCalculatorCoverage new
		coverageTestCase: self
		onPackagesMatching: regex
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
	| result |
	result := self
		statementOfType: aClassName
		before: stop
		noCalledEqualTo: varName.
	result ifNil: [ result := self createScalar: aClassName 	 ].
	^ result ifNil: [ ^ nil ] ifNotNil: [ result first ]
]

{ #category : #generation }
STestCase >> createScalar: aClassName [
	self profile scalars
		at: aClassName
		ifPresent: [ :value | 
			^ {(STransformValue listShuffle: value) first.
			aClassName} ]
		ifAbsent: [ ^ self valueOfType: aClassName using: self profile scalars]
]

{ #category : #generation }
STestCase >> defaultConstructor: classSpy [
	^ (SConstructorStatement new)
		theClassName: classSpy className;
		selector: 'new';
		args: #();
		yourself
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
STestCase >> generateInvariants [
	^ generatorInvariant generateInvariants: self
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
	| currentVarNames |
	currentVarNames := OrderedCollection new.
	statements
		detect: [ :aStm | 
			(currentVarNames includesAll: aStm collectDependencies)
				ifTrue: [ currentVarNames add: aStm varName.
					false ]
				ifFalse: [ true ] ]
		ifFound: [ ^ false ].
	^ true
]

{ #category : #accessing }
STestCase >> indexOf: varName [
	self varNames withIndexDo: [ :aVar :index | 
		aVar = varName ifTrue: [ ^ index ]	
	].
	^ -1
	"index := 0.
	statements
		detect: [ :statement | 
			index := index + 1.
			statement varName = varName ]
		ifFound: [ ^ index ]
		ifNone: [ ^ -1 ]"
]

{ #category : #initialization }
STestCase >> initialize [
	super initialize.
	nextId := 0.
	statements := OrderedCollection new.
	generatorInvariant := SSGeneratorInvariant new.
	dictSubclasses := Dictionary new.
]

{ #category : #'accessing untypeable characters' }
STestCase >> insert [
	| l stop varNames alpha count random varNamesInserted |
	self applyMutator
		ifFalse: [ ^ #() ].
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
STestCase >> insertMethodCall [
	| varNames copyStatements |
	copyStatements := statements deepCopy.
	copyStatements shuffle
		detect: [ :stmToInsert | 
			varNames := stmToInsert insertMethodCallUsing: self.
			varNames isNotNil ]
		ifFound: [ 
			^ varNames ].
	^ nil
]

{ #category : #'as yet unclassified' }
STestCase >> insertParameter [
	| varNames copyStatements |
	copyStatements := statements deepCopy.
	copyStatements shuffle
		detect: [ :stmToInsert | 
			varNames := stmToInsert insertParameterUsing: self.
			varNames isNotNil ]
		ifFound: [ 
			^ varNames ].
	^ nil
]

{ #category : #'as yet unclassified' }
STestCase >> insertRandomCall [
	| varNames copyStatements |
	copyStatements := statements deepCopy.
	copyStatements shuffle
		detect: [ :stmToInsert | 
			varNames := stmToInsert insertRandomCallUsing: self.
			varNames isNotNil ]
		ifFound: [ 
			^ varNames ].
	^ nil
]

{ #category : #'as yet unclassified' }
STestCase >> insertRandomStatement [
	| varNamesInserted |
	self methodsToInsert shuffle
		detect: [ :method | 
			varNamesInserted := self perform: method.
			varNamesInserted isNotNil ]
		ifFound: [ ^ varNamesInserted ]
		ifNone: [ ^ -1 ]
]

{ #category : #'as yet unclassified' }
STestCase >> insertStatementWithArgs: aStatement from: aPosition [
	| args newArgs newStatement size newPosition addedList |
	args := aStatement args.
	size := self numberOfStatements.
	newArgs := args deepCopy.
	addedList := #().
	newPosition := STransformValue
		randomNumberFrom: aPosition
		to: size
		default: aPosition.
	args
		ifNotEmpty: [ newArgs := self
				satisfyParametersOf: args
				before: newPosition
				allowingNull: true.
			addedList := newArgs asArray.
			newPosition := {newArgs
				ifNotEmpty: [ | indexFrom |
					indexFrom := -1.
					newArgs
						do: [ :aArg | 
							indexFrom := {indexFrom.
							(self indexOf: aArg)} max ].
					indexFrom := indexFrom < 0
						ifTrue: [ newPosition ]
						ifFalse: [ indexFrom + 1 ].
					STransformValue
						randomNumberFrom: indexFrom
						to: size
						default: indexFrom ]. newPosition} max ].
	newStatement := aStatement createNewStatement
		args: newArgs asArray;
		yourself.
	(self addStatement: newStatement at: newPosition)
		ifTrue: [ ^ addedList , {newStatement varName} ].
	^ nil
]

{ #category : #'as yet unclassified' }
STestCase >> methodsOrAccessors: aStatement toSelect: aBoolean [
	| methods |
	methods := (self profile >> aStatement theClassName) methods.
	methods := aBoolean ifTrue: [ methods select: #isQuick ] ifFalse: [ methods reject: #isQuick ].
	methods := methods select: [ :m | m returnType notNil ].
	^ methods
]

{ #category : #'as yet unclassified' }
STestCase >> methodsToInsert [
	^ #(#insertRandomCall #insertMethodCall #insertParameter)
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
			(args anySatisfy: #isNil)
				ifTrue: [ ^ nil ].
			selector := selected selector ].
	^ (SConstructorStatement new)
		theClassName:
			(classSpy isSymbol
				ifTrue: [ classSpy ]
				ifFalse: [ classSpy className ]);
		selector: selector;
		args: args;
		yourself
]

{ #category : #accessing }
STestCase >> numberOfStatements [
	^ statements size
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
	self applyMutator
		ifFalse: [ ^ #() ]
		ifTrue: [ ^ self
				remove:
					(statements
						at: (STransformValue randomNumberFrom: 1 to: statements size default: 1))
						varName ]
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

{ #category : #removing }
STestCase >> removeStatementsOfClassName: aClassName [
	| constructors removed |
	constructors := self statements select: #isConstructor.
	constructors ifEmpty: [ ^ false ].
	removed := true.
	constructors
		select: [ :aStm | aStm theClassName = aClassName ]
		thenDo:
			[ :aStm | removed := removed and: [ (self remove: aStm varName) isNotEmpty ] ].
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
					newArg := self
						addPrimitive: (self statementAt: aArg) returnTypeName
						at:
							(STransformValue
								randomNumberFrom: 1
								to: position - 1
								default: position - 1).
					argsResult
						at: index
						put:
							(newArg
								ifNotNil: [ newArg ]
								ifNil: [ aBoolean
										ifTrue: [ nil ]
										ifFalse: [ aArg ] ]) ]
				ifFalse:
					[ argsResult at: index put: (STransformValue changeAndTransform: aArg) ] ].
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

{ #category : #'as yet unclassified' }
STestCase >> statementOfType: aClassName before: stop noCalledEqualTo: varName [
	| dictionary candidates |
	dictionary := Dictionary new.
	candidates := OrderedCollection new.
	statements
		withIndexDo: [ :stm :index | 
			(index < stop
				and: [ stm varName ~= varName ])
				ifTrue: [ candidates add: stm ] ].
	candidates
		do: [ :stm | 
			dictionary
				at:
					(stm isConstructor
						ifTrue: [ stm theClassName ]
						ifFalse: [ stm returnTypeName ])
				ifPresent: [ :aSet | aSet add: stm varName ]
				ifAbsentPut: [ {stm varName} asSet ] ].
	dictionary
		ifNotEmpty: [ ^ self valueOfType: aClassName using: dictionary ].
	^ nil
]

{ #category : #accessing }
STestCase >> statements [
	^ statements
]

{ #category : #'as yet unclassified' }
STestCase >> statementsGroupedByDependencies [
	| groups dependencies referencedVarNames |
	groups := Dictionary new.
	referencedVarNames := Set new.
	dependencies := STransformValue
		collectDependenciesStatements: statements.
	dependencies associations
		do: [ :assoc | 
			| group |
			group := OrderedCollection new.
			assoc value
				do: [ :varName | 
					groups
						at: varName
						ifPresent: [ :groupVarName | 
							group addAll: groupVarName.
							referencedVarNames add: varName ]
						ifAbsent: [ group add: varName ] ].
			groups
				at: assoc key
				put:
					(group
						add: assoc key;
						yourself) ].
	^ {groups.
	referencedVarNames asOrderedCollection}
]

{ #category : #'as yet unclassified' }
STestCase >> valueOfType: aClassName using: aDictionary [
	aDictionary at: aClassName 
	ifPresent: [ :value | ^ {(STransformValue listShuffle: value) first. aClassName} ] 
	ifAbsent: [ 
	| subclasses |
	dictSubclasses at: aClassName 
	ifPresent: [:value | subclasses := value  ]
	ifAbsent: [ 
	subclasses := (Smalltalk classNamed: aClassName) subclasses
		collect: [ :aClass | aClass name ].
	subclasses ifEmpty: [ ^ nil ].
		dictSubclasses at: aClassName put: subclasses asSet ].
	(STransformValue listShuffle: aDictionary keys)
		detect: [ :aName | subclasses includes: aName ]
		ifFound: [ :aName | 
			^ {(STransformValue
				listShuffle: (aDictionary at: aName) asOrderedCollection) first.
			aName} ].
	^ nil]
]

{ #category : #'as yet unclassified' }
STestCase >> varNames [
	^ statements collect: #varName
]
