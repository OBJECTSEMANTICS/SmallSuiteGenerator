Class {
	#name : #STestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'profile',
		'generatorInvariant'
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
	ifFound:[true] 
	ifNone:[false].
	
]

{ #category : #generation }
STestCase >> addConstructor: classSpy [
	| methods newStatement |
	methods := classSpy factoryMethods.
	methods ifEmpty: [ ^ (self addDefaultConstructor: classSpy) isNil ].
	newStatement := self
		newConstructorStatement: classSpy
		of: methods
		before: nil.
	newStatement ifNil: [ ^ false ].
	^ self addStatement: newStatement
	"factoryMethod := methods shuffle anyOne.
	args := factoryMethod argTypes
		collect: [ :class | self createArg: class name ].
	(args anySatisfy: #isNil)
		ifTrue: [ ^ false ].
	^ self
		addStatement:
			(SConstructorStatement create
				theClassName: classSpy className;
				selector: factoryMethod selector;
				args: args;
				yourself)"
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
			list ifEmpty: [ ^ self addDefaultConstructor: classSpy ] ].
	newStatement := self
		newConstructorStatement: aStatement theClassName
		of: list
		before: varName.
	(newStatement isNotNil and: [self addStatement: newStatement at: (self indexOf: varName) - 1])
				ifTrue: [ ^ newStatement ].
	^ nil
]

{ #category : #generation }
STestCase >> addDefaultConstructor: classSpy [
	| statement |
	statement := SConstructorStatement create
				theClassName: classSpy className;
				selector: 'new';
				args: #();
				yourself.
	self
		addStatement: statement.
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
							(SFieldStatement create
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
									(SMethodStatement create
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
			(SPrimitiveStatement create
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
	primitive := SPrimitiveStatement create
				returnTypeName: result second;
				value: scalar;
				yourself.
	^ (self
		addStatement:
			primitive
		at: position) ifTrue: [ primitive varName ] ifFalse: [ nil ]
]

{ #category : #accessing }
STestCase >> addStatement: aStatement [
	statements add: aStatement.
	^ true.
]

{ #category : #accessing }
STestCase >> addStatement: aStatement at: position [
	statements isEmpty
		ifTrue: [ statements add: aStatement ]
		ifFalse: [[ statements add: aStatement afterIndex: position - 1 ]
				on: Error
				do: [ ^ false ] ].
	^ true
]

{ #category : #adding }
STestCase >> addStatement: aStatement satisfyingParameters: otherTestCase [
	aStatement
		satisfyParameters: self
		with: otherTestCase
]

{ #category : #'as yet unclassified' }
STestCase >> applyMutator [
	^ statements isNotEmpty 
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

{ #category : #'as yet unclassified' }
STestCase >> classLiterals [
	^ #(#Array #Boolean #ByteArray #Character #Float #Integer #ScaledDecimal #String #UndefinedObject)
		shuffle
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
	| selectedList |
	selectedList := OrderedCollection new.
	statements
		withIndexDo: [ :stm :index | 
			index < stop
				ifTrue: [ (stm returnTypeName = aClassName and: [ stm varName ~= varName ])
						ifTrue: [ selectedList add: stm varName ] ] ].
	selectedList ifNotEmpty: [ ^ selectedList shuffle anyOne ] ifEmpty: [ ^ (self createScalar: aClassName) first ]
]

{ #category : #generation }
STestCase >> createScalar: aClassName [
	| scalars returnTypeName |
	returnTypeName := aClassName.
	scalars := self profile scalars
		at: aClassName
		ifAbsent: [ | subclasses |
			subclasses := (Smalltalk classNamed: aClassName) allSubclasses
				collect: [ :aClass | aClass name asString ].
			self profile scalars keys
				detect: [ :aString | subclasses includes: aString ]
				ifFound: [ :aString | 
					returnTypeName := aString.
					self profile scalars at: aString ]
				ifNone: [ ^ nil ] ].
	^ {scalars asOrderedCollection shuffle anyOne.
	returnTypeName}
]

{ #category : #'as yet unclassified' }
STestCase >> crossOverWith: otherTestCase [
	| alpha offSpring1 offSpring2 size sizeOther |
	alpha := (0.1 to: 0.9 by: 0.1) atRandom round: 1.
	size := statements size.
	sizeOther := otherTestCase statements size.
	offSpring1 := STestCase seed: otherTestCase profile.
	(statements copyFrom: 1 to: (size * alpha) asInteger)
		do: [ :aStm | offSpring1 addStatement: aStm ].	"first alpha(P1)"
	(otherTestCase statements
		copyFrom: (alpha * sizeOther) asInteger + 1
		to: sizeOther)
		do:
			[ :aStm | offSpring1 addStatement: aStm  satisfyingParameters: otherTestCase ].	"last (1-alpha)(P2)"
	offSpring2 := STestCase seed: self profile.
	(otherTestCase statements
		copyFrom: 1
		to: (sizeOther * alpha) asInteger)
		do: [ :aStm | offSpring2 addStatement: aStm ].	"first alpha(P2)"
	(statements copyFrom: (alpha * size) asInteger + 1 to: size)
		do: [ :aStm | offSpring2 addStatement: aStm satisfyingParameters: self ].	"last (1-alpha)(P1)"
	^ {offSpring1.
	offSpring2}
]

{ #category : #'as yet unclassified' }
STestCase >> generateInvariants [
	^ generatorInvariant generateInvariants: self
]

{ #category : #'as yet unclassified' }
STestCase >> generateStatements [
	20
		timesRepeat: [ [ self
				perform: #(#addConstructor #addField #addMethod #addPrimitive) shuffle anyOne ]
				on: Error
				do: [  ] ]
]

{ #category : #'as yet unclassified' }
STestCase >> hasValidDependencies [
	| currentVarNames |
	currentVarNames := OrderedCollection new.
	statements
		detect: [ :aStm | 
			(self
				validDependencies: aStm collectDependencies
				with: currentVarNames)
				ifTrue: [ currentVarNames add: aStm varName.
					false ]
				ifFalse: [ true ] ]
		ifFound: [ ^ false ].
	^ true
]

{ #category : #accessing }
STestCase >> indexOf: varName [
	| index |
	index := 0.
	statements
		detect: [ :statement | 
			index := index + 1.
			statement varName = varName ]
		ifFound: [ ^ index ]
		ifNone: [ ^ -1 ].
]

{ #category : #initialization }
STestCase >> initialize [
	super initialize.
	statements := OrderedCollection new.
	generatorInvariant := SSGeneratorInvariant new.
]

{ #category : #'accessing untypeable characters' }
STestCase >> insert [
	| l L varNames alpha count random varNamesInserted |
	self applyMutator
		ifFalse: [ ^ #() ].
	l := 1.
	count := 0.
	L := statements size.
	alpha := 0.5.
	varNamesInserted := OrderedCollection new.
	random := Random new seed: DateAndTime current nanoSecond / 100.
	[ l < L and: [ random next <= (alpha raisedTo: count) ] ]
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
		ifFound: [ ^ varNames ].
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
		ifFound: [ ^ varNames ].
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
		ifFound: [ ^ varNames ].
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
STestCase >> insertStatementWithArgs: aStatement before: aPosition [
	| args newArgs newStatement size newPosition addedList |
	args := aStatement args.
	size := statements size.
	newArgs := args deepCopy.
	addedList := #().
	newPosition := STransformValue
		randomNumberFrom: aPosition
		to: size
		default: aPosition.
	args
		ifNotEmpty: [ newArgs := self
				satisfyParametersOf: args
				before: size + 1
				allowingNull: true.
			addedList := newArgs asArray.
			newPosition := newArgs
				ifNotEmpty: [ | indexFrom |
					indexFrom := (self indexOf: newArgs last) + 1.
					STransformValue
						randomNumberFrom: indexFrom
						to: size
						default: indexFrom ]
				ifEmpty: [ size + 1 ] ].
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
	methodList ifEmpty: [ args := #(). selector := 'new' ] ifNotEmpty: [ 
	selected := methodList shuffle anyOne.
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
		selector := selected selector.
		].
	^ SConstructorStatement create
		theClassName: (classSpy isSymbol ifTrue: [ classSpy ] ifFalse: [classSpy className]);
		selector: selector;
		args: args;
		yourself
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
								default: position).
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

{ #category : #accessing }
STestCase >> statements [
	^ statements
]

{ #category : #'as yet unclassified' }
STestCase >> validDependencies [
	| isValid currentVarNames |
	isValid := true.
	currentVarNames := OrderedCollection new.
	statements detect: [ :aStm | 
		| collectDependencies |
		collectDependencies := aStm collectDependencies.
		(self validDependencies: collectDependencies with: currentVarNames) 
		ifTrue: [ currentVarNames addAll: collectDependencies; add: aStm varName. false ] ifFalse: [ true ]
		 ] ifFound: [ ^ false ]
	ifNone: [ ^ true ].
	^ true
]

{ #category : #'as yet unclassified' }
STestCase >> validDependencies: dependencies with: varNames [
	^ varNames includesAll: dependencies
	
]

{ #category : #'as yet unclassified' }
STestCase >> varNames [
	^ statements collect: #varName
]
