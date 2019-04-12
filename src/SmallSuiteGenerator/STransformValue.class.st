Class {
	#name : #STransformValue,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #mutation }
STransformValue class >> change: aScalar [
	aScalar isNumber
		ifTrue: [ ^ (aScalar + (1 to: 100) atRandom) printString ].
	aScalar isCharacter
		ifTrue: [ ^ (Character value: (33 to: 127) atRandom) printString ].
	aScalar class superclass = Boolean
		ifTrue: [ aScalar
				ifTrue: [ ^ false printString ]
				ifFalse: [ ^ true printString ] ].
	(aScalar isString
		and: [ ((aScalar beginsWith: '#(') and: [ aScalar endsWith: ')' ]) not ])
		ifTrue: [ | interval |
			interval := 33 to: 127.
			^ ((Character value: interval atRandom) asString
				, (aScalar copyFrom: 2 to: aScalar size - 1)
				, (Character value: interval atRandom) asString) printString ].
	^ aScalar
]

{ #category : #mutation }
STransformValue class >> change: aScalar ofTypes: types using: aTestCase [
	aScalar isNumber
		ifTrue: [ ^ (aScalar + (1 to: 100) atRandom) printString ].
	aScalar isCharacter
		ifTrue: [ ^ (Character value: (33 to: 127) atRandom) printString ].
	aScalar class superclass = Boolean
		ifTrue: [ aScalar
				ifTrue: [ ^ false printString ]
				ifFalse: [ ^ true printString ] ].
	(aScalar isString
		and: [ ((aScalar beginsWith: '#(') and: [ aScalar endsWith: ')' ]) not ])
		ifTrue: [ | interval |
			interval := 33 to: 127.
			^ ((Character value: interval atRandom) asString
				, (aScalar copyFrom: 2 to: aScalar size - 1)
				, (Character value: interval atRandom) asString) printString ].
	^ aScalar
]

{ #category : #mutation }
STransformValue class >> change: aScalar using: aTestCase [
	aScalar isNumber
		ifTrue: [ ^ (aScalar + (1 to: 100) atRandom) printString ].
	aScalar isCharacter
		ifTrue: [ ^ (Character value: (33 to: 127) atRandom) printString ].
	aScalar class superclass = Boolean
		ifTrue: [ aScalar
				ifTrue: [ ^ false printString ]
				ifFalse: [ ^ true printString ] ].
	(aScalar isString
		and: [ ((aScalar beginsWith: '#(') and: [ aScalar endsWith: ')' ]) not ])
		ifTrue: [ | interval |
			interval := 33 to: 127.
			^ ((Character value: interval atRandom) asString
				, (aScalar copyFrom: 2 to: aScalar size - 1)
				, (Character value: interval atRandom) asString) printString ].
	^ aScalar
]

{ #category : #'as yet unclassified' }
STransformValue class >> changeAndTransform: aObject [
	^ self change: (self transform: aObject)
]

{ #category : #'as yet unclassified' }
STransformValue class >> changeAndTransform: aObject using: aTestCase [
	^ self change: (self transform: aObject) using: aTestCase
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
STransformValue class >> changeArgsOf: args using: aTestCase [
	| varToChange argsResult varNames |
	argsResult := args deepCopy.
	varToChange := OrderedCollection new.
	varNames := aTestCase varNames.
	args
		withIndexDo: [ :aArg :index | 
			(varNames includes: aArg)
				ifTrue: [ varToChange add: aArg ]
				ifFalse: [ argsResult at: index put: (self changeAndTransform: aArg using: aTestCase) ] ].
	^ {argsResult.
	varToChange}
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
		ifEmpty: [ ^ aCollection ]
		ifNotEmpty: [ ^ aCollection shuffle ]
]

{ #category : #'as yet unclassified' }
STransformValue class >> randomNumberFrom: aNumber1 to: aNumber2 default: aNumber3 [
	| interval |
	interval := aNumber1 to: aNumber2.
	^ interval ifEmpty: [ aNumber3 ] ifNotEmpty: [ interval atRandom ]
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
				createArg: aStatement returnTypeName
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
	^ args select: [ :aArg | (aArg beginsWith: '_var') and: [ aArg endsWithDigit ] ]
]

{ #category : #accessing }
STransformValue class >> transform: aString [
	| value |
	[ value := aString asNumber.
	^ value ]
		on: Error
		do: [  ].
	aString = 'true'
		ifTrue: [ ^ true ].
	aString = 'false'
		ifTrue: [ ^ false ].
	((aString beginsWith: '$') and: [ aString size = 2 ])
		ifTrue: [ ^ aString second ].
	^ aString
]
