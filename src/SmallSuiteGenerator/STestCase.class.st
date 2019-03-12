Class {
	#name : #STestCase,
	#superclass : #Object,
	#instVars : [
		'statements',
		'profile',
		'generatorInvariant'
	],
	#category : #'SmallSuiteGenerator-Model'
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
	(args anySatisfy: #isNil) ifTrue:[ ^ false.].
	^ self
		addStatement:
			(SConstructorStatement create
				theClassName: classSpy className;
				selector: factoryMethod selector;
				args: args;
				yourself)
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
						ifFalse: [ ^  self
						addStatement:
							(SMethodStatement create
								receiverVarName: stm varName;
								selector: selected selector;
								args: args;
								yourself)  ].
					] ].
	^ false
]

{ #category : #generation }
STestCase >> addPrimitive [
	"| col |
	col := OrderedCollection new." "Refactor to consider the valid subclasss and classes in profile"
	"col add: #Array; addAll: (Array allSubclasses collect: [:subC | subC name])."
	^ "#(#ByteString #SmallInteger #False #True #Character )"
		
		#(#Array #Boolean #ByteArray #Character #Float #Integer #ScaledDecimal #String #UndefinedObject) shuffle
		detect: [ :className | self addPrimitive: className ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #generation }
STestCase >> addPrimitive: aClassName [
	| scalar |
	scalar := self createScalar: aClassName.
	scalar ifNil: [ ^ false ].
	^ self
		addStatement:
			(SPrimitiveStatement create
				returnTypeName: aClassName;
				value: scalar;
				yourself)
]

{ #category : #accessing }
STestCase >> addStatement: aStatement [
	statements add: aStatement.
	^ true.
]

{ #category : #generation }
STestCase >> createArg: aClassName [
	^ statements
		detect: [ :stm | stm returnTypeName = aClassName ]
		ifFound: [ :stm | stm varName ]
		ifNone: [self createScalar: aClassName ]
]

{ #category : #generation }
STestCase >> createScalar: aClassName [
	| scalars |
	scalars := self profile scalars
		at: aClassName
		ifAbsent: [ | subclasses |
			subclasses := (Smalltalk classNamed: aClassName) allSubclasses collect: [:aClass | aClass name asString ].
			self profile scalars keys detect: [ :aString | 
				subclasses includes: aString ]
			ifFound: [ :aString | self profile scalars at: aString ] 
			ifNone: [ ^ nil ] ].
		"ifAbsent: [ ^ nil. ]."
	^ scalars asOrderedCollection shuffle anyOne
]

{ #category : #'as yet unclassified' }
STestCase >> generateInvariants [
	^ generatorInvariant generateInvariants: self
]

{ #category : #initialization }
STestCase >> initialize [
	super initialize.
	statements := OrderedCollection new.
	generatorInvariant := SSGeneratorInvariant new.
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

{ #category : #accessing }
STestCase >> statements [
	^ statements
]
