Class {
	#name : #STransformValue,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #mutation }
STransformValue class >> change: args ofTypes: types using: aTestCase [
	| varToChange argsResult varNames |
	argsResult := args deepCopy.
	varToChange := OrderedCollection new.
	varNames := aTestCase varNames.
	args
		withIndexDo: [ :aArg :index | 
			(varNames includes: aArg)
				ifTrue: [ varToChange add: aArg ]
				ifFalse: [ argsResult
						at: index
						put: (self changeAndTransform: aArg ofType: (types at: index) using: aTestCase) ] ].
	^ {argsResult.
	varToChange}
]

{ #category : #'as yet unclassified' }
STransformValue class >> changeAndTransform: aObject ofType: aType using: aTestCase [
	| dictOfClasses |
	aObject isLiteral
		ifTrue: [ ^ aObject mutateToChange ].
	dictOfClasses := Dictionary newFromKeys: (aTestCase dictSubclasses keys, aTestCase profile scalars keys) andValues: (aTestCase dictSubclasses values, aTestCase profile scalars values).
	dictOfClasses 
	"aTestCase dictSubclasses"
		at: aType name
		ifPresent: [ :subClasses | 
			| otherValues |
			otherValues := OrderedCollection new.
			aTestCase profile scalars associations
				select: [ :assoc | subClasses includes: assoc key ]
				thenDo: [ :assoc | otherValues addAll: assoc value ].
			otherValues := self listShuffle: otherValues.
			otherValues
				detect: [ :str | str ~= aObject ]
				ifFound: [ :str | ^ str ]
				ifNone: [ ^ aObject ] ]
		ifAbsent: [ "^ self change: (self transform: aObject) using: aTestCase" ^ nil ]
]

{ #category : #'as yet unclassified' }
STransformValue class >> changeArg: aArg before: position using: aTestCase allowingNull: aBoolean [
	| listCandidates argToUse |
	argToUse := aArg.
	listCandidates := aTestCase statements copyFrom: 1 to: position - 1.
	listCandidates
		ifNotEmpty: [ | referencedStm |
			referencedStm := aTestCase statementAt: aArg.
			listCandidates
				detect: [ :aStm | aStm returnTypeName = referencedStm returnTypeName ]
				ifFound: [ :aStm | argToUse := aStm varName ]
				ifNone: [ aBoolean
						ifTrue: [ argToUse := nil ] ] ].
	^ argToUse
]

{ #category : #'as yet unclassified' }
STransformValue class >> collectDependenciesStatements: statements [
	| dictCollectedDependencies dependencies |
	dictCollectedDependencies := OrderedDictionary new.
	statements
		do: [ :aStatement | 
			dependencies := aStatement collectDependencies.
			dependencies
				ifNotEmpty: [ dictCollectedDependencies at: aStatement varName put: dependencies ] ].
	^ dictCollectedDependencies
]

{ #category : #'as yet unclassified' }
STransformValue class >> dataStatements: statements [
	| dictStringBody referencedVarNames |
	dictStringBody := Dictionary new.
	referencedVarNames := Set new.
	statements
		do: [ :aStatement | 
			dictStringBody
				at: aStatement stringBody
				ifPresent: [ :coll | coll add: aStatement varName ]
				ifAbsentPut: [ OrderedCollection new
						add: aStatement varName;
						yourself ].
			referencedVarNames addAll: aStatement collectDependencies ].
	^ {dictStringBody.
	referencedVarNames asOrderedCollection}
]

{ #category : #'as yet unclassified' }
STransformValue class >> detectConstructor: aTestCase of: aStatement withCondition: aBlock [
	aTestCase statements
		detect: [ :aStm | 
			aStm isConstructor
				and: [ "((aTestCase methodsOrAccessors: aStm toSelect: true)
						collect: #selector) includes: self fieldName "
					aBlock
						valueWithArguments:
							{aTestCase.
							aStm.
							aStatement} ] ]
		ifFound: [ :aStm | ^ aStm ]
		ifNone: [ ^ nil ].
	^ nil
]

{ #category : #'as yet unclassified' }
STransformValue class >> getTypeArgs: aClassName of: selector with: aTestCase [
	(aTestCase profile >> aClassName) methods
		detect: [ :method | method selector = selector ]
		ifFound: [ :method | ^ aTestCase classOfArgs: method ]
		ifNone: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
STransformValue class >> getTypeArgs: aClassName of: selector with: aTestCase and: otherTestCase [	
	| typeArgs |
	typeArgs := self getTypeArgs: aClassName of: selector with: aTestCase.
	typeArgs ifNotNil: [ ^ typeArgs  ] ifNil: [ ^ self getTypeArgs: aClassName of: selector with: otherTestCase ].
]

{ #category : #'as yet unclassified' }
STransformValue class >> listShuffle: aCollection [
	aCollection
		ifEmpty: [ ^ aCollection  ]
		ifNotEmpty: [ ^ aCollection asArray shuffle ]
]

{ #category : #compiling }
STransformValue class >> nodeFormattedOf: testCase [
	| statements varNames node temporaries |
	statements := testCase statements.
	varNames := testCase varNames.
	node := RBParser parseExpression: '[]'.
	temporaries := varNames
		collect: [ :varName | RBParser parseExpression: varName ].
	node body temporaries: temporaries.
	statements
		collect: [ :statement | 
			statement
				referencesToArgs: varNames;
				printString ]
		thenDo: [ :aString | node body addNode: (RBParser parseExpression: aString) ].
	^ node
]

{ #category : #'as yet unclassified' }
STransformValue class >> randomNumberFrom: aNumber1 to: aNumber2 default: aNumber3 [
	| interval |
	interval := aNumber1 to: aNumber2.
	^ interval ifEmpty: [ aNumber3 ] ifNotEmpty: [ interval atRandom ]
]

{ #category : #'as yet unclassified' }
STransformValue class >> randomValueCharacter: aCharacter [
	| value interval |
	interval := 33 to: 127.
	value := interval atRandom.
	[ value == aCharacter asInteger ]
		whileTrue: [ value := interval atRandom ].
	^ value
]

{ #category : #removing }
STransformValue class >> removeOrRepairArgs: args of: aStatement with: varName using: aTestCase [
	| varToDelete replace argsResult |
	argsResult := args deepCopy.
	varToDelete := OrderedCollection new.
	replace := Dictionary new.
	args
		select: [ :stringArg | stringArg = aStatement varName ]
		thenDo: [ :stringArg | 
			| newArg |
			newArg := aTestCase
				createArg:
					(aStatement isConstructor
						ifTrue: [ aStatement theClassName ]
						ifFalse: [ aStatement returnTypeName ])
				before: (aTestCase indexOf: varName)
				avoiding: aStatement varName.
			newArg
				ifNil: [ varToDelete add: stringArg ]
				ifNotNil: [ replace at: stringArg put: newArg ] ].
	varToDelete
		ifEmpty: [ argsResult := args
				collect: [ :arg | replace at: arg ifAbsent: [ arg ] ] ].
	^ {argsResult.
	varToDelete}
]

{ #category : #'as yet unclassified' }
STransformValue class >> satisfyArgs: aTestCase with: otherTestCase of: aStatement and: constructor [
	| args varNames otherVarNames resultArgs argTypes |
	aStatement args ifEmpty: [ ^ #() ].
	args := aStatement args.
	varNames := aTestCase varNames.
	otherVarNames := otherTestCase varNames.
	resultArgs := OrderedCollection new.
	argTypes := self
		getTypeArgs: constructor theClassName
		of: aStatement selector
		with: aTestCase
		and: otherTestCase.
	argTypes
		doWithIndex: [ :argType :index | 
			| aArg found |
			found := false.
			aArg := args at: index.
			(varNames includes: aArg)
				ifTrue: [ (self satisfyTypeArg: aArg ofType: argType with: aTestCase)
						ifTrue: [ found := true ] ].
			found
				ifFalse: [ (otherVarNames includes: aArg)
						ifTrue: [ aArg := aTestCase
								createArg: argType
								before: aTestCase statements size + 1
								avoiding: nil ] ].
			self assert: aArg isNotNil description: 'The arg must not be nil'.
			resultArgs add: aArg ].
	^ resultArgs
]

{ #category : #'as yet unclassified' }
STransformValue class >> satisfyConstructor: aTestCase with: otherTestCase of: aStatement and: aBlock [
	| constructor |
	constructor := self
		detectConstructor: aTestCase
		of: aStatement
		withCondition: aBlock.
	constructor
		ifNil: [ constructor := self
				detectConstructor: otherTestCase
				of: aStatement
				withCondition: aBlock.
			constructor
				ifNotNil: [ constructor := aTestCase
						newConstructorStatement: constructor theClassName
						of:
							(otherTestCase profile classAt: constructor theClassName)
								factoryMethods
						before: constructor varName.
						constructor ifNotNil: [ aTestCase addStatement: constructor ]
						 ] ].
	^ constructor
]

{ #category : #'as yet unclassified' }
STransformValue class >> satisfyParameters: aTestCase with: otherTestCase of: aStatement withBlocks: blocks [
	| constructor |
	constructor := self
		satisfyConstructor: aTestCase
		with: otherTestCase
		of: aStatement
		and: blocks first.
	constructor
		ifNotNil: [ aStatement isMethod
				ifTrue: [ ^ blocks second
						valueWithArguments:
							{aTestCase.
							aStatement.
							constructor.
							(self satisfyArgs: aTestCase with: otherTestCase of: aStatement and: constructor)} ]
				ifFalse: [ ^ blocks second
						valueWithArguments:
							{aTestCase.
							aStatement.
							constructor} ] ].
	^ false
]

{ #category : #'as yet unclassified' }
STransformValue class >> satisfyTypeArg: aArg ofType: argType with: aTestCase [
	^ (aTestCase statementAt: aArg) returnTypeName = argType
]

{ #category : #'as yet unclassified' }
STransformValue class >> selectVarNames: args [
	^ args select: [ :aArg | [(aArg beginsWith: '_var') and: [ aArg endsWithDigit ]] on: Error do: [ false ] ]
]
