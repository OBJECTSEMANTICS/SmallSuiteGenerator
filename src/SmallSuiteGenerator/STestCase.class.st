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
	| factoryMethod args methods |
	methods := classSpy factoryMethods.
	methods ifEmpty: [ ^ self addDefaultConstructor: classSpy ].
	factoryMethod := methods shuffle anyOne.
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
				yourself)
]

{ #category : #accessing }
STestCase >> addConstructorField: aStatement before: varName [
	| accessors newStatement index |
	accessors := (self profile >> aStatement theClassName) methods
		select: #isQuick.
	accessors := accessors select: [ :m | m returnType notNil ].
	accessors
		ifNotEmpty: [ | selected args |
			selected := accessors shuffle anyOne.
			args := selected argTypes
				collect: [ :class | self createArg: class name before: aStatement varName ].
			(args anySatisfy: #isNil)
				ifTrue: [ ^ false ].
			newStatement := SConstructorStatement create
				theClassName: aStatement theClassName;
				selector: selected selector;
				args: args;
				yourself.
			index := self addStatement: newStatement before: varName.
			index > 0
				ifTrue: [ (statements at: index) receiverVarName: aStatement varName.
					^ true ] ].
	^ false
]

{ #category : #accessing }
STestCase >> addConstructorMethod: aStatement before: varName [
	| factoryMethod args methods classSpy newStatement index |
	classSpy := profile classAt: aStatement theClassName.
	methods := classSpy factoryMethods.
	methods ifEmpty: [ ^ self addDefaultConstructor: classSpy ].
	factoryMethod := methods shuffle anyOne.
	args := factoryMethod argTypes
		collect: [ :class | self createArg: class name before: aStatement varName ].
	(args anySatisfy: #isNil)
		ifTrue: [ ^ false ].
	newStatement := SConstructorStatement create
		theClassName: classSpy className;
		selector: factoryMethod selector;
		args: args;
		yourself.
	index := self addStatement: newStatement before: varName.
	index > 0
		ifTrue: [ (statements at: index) receiverVarName: newStatement varName.
			^ true ].
	^ false
]

{ #category : #generation }
STestCase >> addDefaultConstructor: classSpy [
	^ self
		addStatement:
			(SConstructorStatement create
				theClassName: classSpy className;
				selector: 'new';
				args: #();
				yourself)
]

{ #category : #generation }
STestCase >> addField [
	| constructStatements |
	constructStatements := statements select: #isConstructor.
	constructStatements ifEmpty: [ ^ false ].
	constructStatements shuffle
		do: [ :stm | 
			| accessors |
			accessors := (self profile >> stm theClassName) methods
				select: #isQuick.

			accessors := accessors select: [ :m | m returnType notNil ].
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
			methods := (self profile >> stm theClassName) methods
				reject: #isQuick.
			methods := methods select: [ :m | m returnType notNil ].
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
STestCase >> addMethodInRandomPosition [
	| constructStatements |
	constructStatements := statements select: #isConstructor.
	constructStatements ifEmpty: [ ^ false ].
	constructStatements shuffle
		do: [ :stm | 
			| methods |
			methods := (self profile >> stm theClassName) methods
				reject: #isQuick.
			methods := methods select: [ :m | m returnType notNil ].
			methods
				ifNotEmpty: [ | selected args |
					selected := methods shuffle anyOne.
					args := selected argTypes
						collect: [ :class | self createArg: class name ].
					(args anySatisfy: #isNil)
						ifFalse: [ | position posSelected |
							posSelected := self indexOf: selected varName.
							position := (posSelected + 1 to: statements size) atRandom.
							(self
								addStatement:
									(SMethodStatement create
										receiverVarName: stm varName;
										returnTypeName: selected returnType name;
										selector: selected selector;
										args: args;
										yourself) at: position) ifTrue: [ ^ position ] ] ] ].
	^ -1
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

{ #category : #accessing }
STestCase >> addStatement: aStatement before: varName [
	| index |
	index := 0.
	statements
		detect: [ :statement | 
			index := index + 1.
			statement varName = varName ]
		ifFound: [ statements add: aStatement beforeIndex: index.
			^ index + 1 ].
	^ index
]

{ #category : #'as yet unclassified' }
STestCase >> applyMutator [
	^ statements isNotEmpty 
]

{ #category : #mutation }
STestCase >> change [
	| statement |
	statement := statements at: self randomIndex.
	self change: statement varName
]

{ #category : #mutation }
STestCase >> change: varName [
	| statementToChange varNamesToChange statementsCopy |
	statementToChange := statements
		detect: [ :stm | stm varName = varName ]
		ifNone: [ ^ nil ].
	varNamesToChange := OrderedCollection new.
	statementsCopy := statements deepCopy.
	statementsCopy
		do: [ :statement | 
			varNamesToChange
				addAll: (statement repairOn: self changing: statementToChange) ].
	varNamesToChange do: [ :aName | self change: aName ]
]

{ #category : #accessing }
STestCase >> changeField: aStatement [
	| accessors |
	accessors := (self profile
		>>
			(statements at: (self indexOf: aStatement receiverVarName))
				theClassName) methods select: #isQuick.
	accessors := accessors
		select: [ :m | m returnType name = aStatement returnTypeName ].
	accessors
		ifNotEmpty: [ | selected |
			selected := accessors shuffle
				detect: [ :accessor | accessor selector ~= aStatement fieldName ]
				ifFound: [ :accessor | accessor selector ]
				ifNone: [ aStatement fieldName ].
			(statements at: (self indexOf: aStatement varName))
				fieldName: selected ]
]

{ #category : #accessing }
STestCase >> changeMethod: aStatement [
	| methods constructStatement createdSelectors |
	constructStatement := (statements
		at: (self indexOf: aStatement receiverVarName)) theClassName.
	methods := (self profile >> constructStatement) methods
		reject: #isQuick.
	createdSelectors := (statements
		select: #isMethod
		thenCollect: [ :method | method selector ]) asSet.
	methods := methods
		reject: [ :m | 
			((createdSelectors includes: m selector) not
				and: [ m returnType name = constructStatement ])
				or: [ m returnType name ~= aStatement returnTypeName ] ].
	methods
		ifNotEmpty: [ | selected args shuffleMethods |
			shuffleMethods := methods shuffle.
			selected := shuffleMethods
				detect: [ :accessor | accessor selector ~= aStatement selector ]
				ifFound: [ :accessor | accessor ]
				ifNone: [ shuffleMethods anyOne ].
			selected selector = aStatement selector
				ifTrue: [ | coll |
					coll := aStatement
						change: aStatement args
						using: self
						of: aStatement.
					args := coll first ]
				ifFalse: [ args := selected argTypes
						collect: [ :class | self createArg: class name before: aStatement varName ].
					(args anySatisfy: #isNil)
						ifTrue: [ ^ self ] ].
			(statements at: (self indexOf: aStatement varName))
				selector: selected selector;
				args: args ]
]

{ #category : #'as yet unclassified' }
STestCase >> classLiterals [
	^ #(#Array #Boolean #ByteArray #Character #Float #Integer #ScaledDecimal #String #UndefinedObject)
		shuffle
]

{ #category : #generation }
STestCase >> createArg: aClassName [
	^ statements
		detect: [ :stm | stm returnTypeName = aClassName ]
		ifFound: [ :stm | stm varName ]
		ifNone: [ | result |
			result := self createScalar: aClassName.
			result first ]
]

{ #category : #generation }
STestCase >> createArg: className avoiding: aVarName [
	^ statements
		detect:
			[ :stm | stm returnTypeName = className and: [ stm varName ~= aVarName ] ]
		ifFound: [ :stm | stm varName ]
		ifNone: [ | result |
			result := self createScalar: className.
			result first ]
]

{ #category : #generation }
STestCase >> createArg: aClassName before: varName [
	| indexStatement index scalar |
	indexStatement := self indexOf: varName.
	index := 1.
	[ index < indexStatement and: [ scalar isNil ] ]
		whileTrue: [ | stm |
			stm := statements at: index.
			stm returnTypeName = aClassName
				ifTrue: [ scalar := stm varName ].
			index := index + 1 ].
	scalar ifNil: [ scalar := (self createScalar: aClassName) first ].
	"^ statements
		detect: [ :stm | stm returnTypeName = aClassName and: [  ] ]
		ifFound: [ :stm | stm varName ]
		ifNone: [ self createScalar: aClassName ]"
	^ scalar
]

{ #category : #generation }
STestCase >> createScalar: aClassName [
	| scalars returnTypeName |
	returnTypeName := aClassName.
	scalars := self profile scalars
		at: aClassName
		ifAbsent: [ | subclasses |
			subclasses := (Smalltalk classNamed: aClassName) allSubclasses collect: [:aClass | aClass name asString ].
			self profile scalars keys detect: [ :aString | 
				subclasses includes: aString ]
			ifFound: [ :aString | 
				returnTypeName := aString.
				self profile scalars at: aString ] 
			ifNone: [ ^ nil ] ].
		"ifAbsent: [ ^ nil. ]."
	^ {scalars asOrderedCollection shuffle anyOne. returnTypeName }
]

{ #category : #mutation }
STestCase >> crossover: aTestCase [
	"devuelve dos nuevos test case"
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
	| l L position alpha count random changed |
	self applyMutator
		ifFalse: [ ^ false ].
	l := 1.
	count := 0.
	L := statements size.
	alpha := 0.5.
	changed := false.
	random := Random new seed: DateAndTime current nanoSecond / 100.
	[ l < L and: [ random next <= (alpha raisedTo: count) ] ]
		whileTrue: [ position := self insertRandomStatement.
			position > 0
				ifTrue: [ changed := true ].
			l := l + 1.
			count := count + 1 ].
	^ changed
]

{ #category : #accessing }
STestCase >> insert: varName [
	| statementToInsert statementsCopy |
	statementToInsert := statements
		detect: [ :stm | stm varName = varName ]
		ifNone: [ ^ false ].
	statementsCopy := statements deepCopy.
	self methodsToApplyInsertion shuffle
		detect:
			[ :aMethod | statementToInsert perform: aMethod withArguments: {self} ]
		ifFound: [ ^ true ].
	^ false
	"varNamesToDelete := OrderedCollection new.
	statementsCopy
		do: [ :smt | 
			varNamesToDelete
				addAll: (smt repairOn: self deleting: statementToDelete) ].
	statements remove: statementToDelete.
	varNamesToDelete do: [ :aName | self remove: aName ].
	^ varName"
]

{ #category : #'as yet unclassified' }
STestCase >> insertMethodCall [
	| position |
	statements shuffle
		detect: [ :stmToInsert | 
			position := stmToInsert
				insertMethodCallUsing: self.
			position > 0 ]
		ifFound: [ ^ position ].
	^ -1
]

{ #category : #'as yet unclassified' }
STestCase >> insertParameter [
	| position |
	statements shuffle
		detect: [ :stmToInsert | 
			position := stmToInsert insertParameterUsing: self.
			position > 0 ]
		ifFound: [ ^ position ].
	^ -1
]

{ #category : #'as yet unclassified' }
STestCase >> insertRandomCall [
	| position |
	statements shuffle
		detect: [ :stmToInsert | 
			position := stmToInsert
				insertRandomCallAt: self statements size
				using: self.
			position > 0 ]
		ifFound: [ ^ position ].
	^ -1
]

{ #category : #'as yet unclassified' }
STestCase >> insertRandomStatement [
	| position |
	self methodsToInsert shuffle
		detect: [ :method | 
			position := self perform: method.
			position > 0 ]
		ifFound: [ ^ position ]
		ifNone: [ ^ -1 ]
]

{ #category : #'as yet unclassified' }
STestCase >> methodsToApplyInsertion [
	^ #(#insertRandomCall #insertMethodCall #valueAsParameter)
]

{ #category : #'as yet unclassified' }
STestCase >> methodsToInsert [
	^ #(#insertRandomCall #insertMethodCall #insertParameter)
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

{ #category : #'as yet unclassified' }
STestCase >> randomIndex [
	^ (1 to: statements size) atRandom.
]

{ #category : #mutation }
STestCase >> remove [
	| smt |
	smt := statements at: self randomIndex.
	^ self remove: smt varName
]

{ #category : #mutation }
STestCase >> remove: varName [
	| statementToDelete varNamesToDelete statementsCopy |
	statementToDelete := statements
		detect: [ :stm | stm varName = varName ]
		ifNone: [ ^ nil ].
	varNamesToDelete := OrderedCollection new.
	statementsCopy := statements deepCopy.
	statementsCopy
		do: [ :smt | 
			varNamesToDelete
				addAll: (smt repairOn: self deleting: statementToDelete) ].
	statements remove: statementToDelete.
	varNamesToDelete do: [ :aName | self remove: aName ].
	^ varName
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
