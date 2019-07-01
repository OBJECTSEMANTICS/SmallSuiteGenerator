Class {
	#name : #SAuxiliar,
	#superclass : #Object,
	#classInstVars : [
		'level'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #mutation }
SAuxiliar class >> change: args argsOf: types typesUsing: aTestCase [
	| varToChange argsResult varNames |
	argsResult := args collect: [ :arg | arg ].
	varToChange := OrderedCollection new.
	varNames := aTestCase varNames.
	args
		withIndexDo: [ :aArg :index | 
			(varNames includes: aArg)
				ifTrue: [ varToChange add: aArg ]
				ifFalse: [ argsResult
						at: index
						put:
							(self
								changeAndTransform: aArg
								ofType: (types at: index)
								using: aTestCase) ] ].
	^ {argsResult.
	varToChange}
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> changeAndTransform: aObject ofType: aType using: aTestCase [
	| dictOfClasses |
	aObject isLiteral
		ifTrue: [ ^ aObject mutateToChange ].
	dictOfClasses := Dictionary
		newFromKeys: aTestCase dictSubclasses keys , aTestCase spyInfo scalars keys
		andValues: aTestCase dictSubclasses values , aTestCase spyInfo scalars values.
	dictOfClasses
		at: aType name
		ifPresent: [ :subClasses | 
			| otherValues |
			otherValues := OrderedCollection new.
			aTestCase spyInfo scalars associations
				select: [ :assoc | subClasses includes: assoc key ]
				thenDo: [ :assoc | otherValues addAll: assoc value ].
			otherValues := self listShuffle: otherValues.
			otherValues
				detect: [ :str | str ~= aObject ]
				ifFound: [ :str | ^ str ]
				ifNone: [ ^ aObject ] ]
		ifAbsent: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> classLiterals [
	^ #(#Array #Boolean #ByteArray #Character #Float #Integer #ScaledDecimal #String #UndefinedObject)
		shuffle
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> classesForRegex: regex [
	^ (S2Gatherer new packagesForRegexExpressions: {regex}) flatCollect: #definedClasses.
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> constructorIn: aTestCase testCaseOf: aStatement statementWithBlockCondition: aBlock [
	"If there is a constructor which has the selector either method or field, it returns the found constructor, Opposite it returns nil"

	aTestCase statements
		detect: [ :aStm | 
			aStm isConstructor
				and: [ aBlock
						valueWithArguments:
							{aTestCase.
							aStm.
							aStatement} ] ]
		ifFound: [ :aStm | ^ aStm ]
		ifNone: [ ^ nil ].
	^ nil
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> createStatementOf: aClassName typeIn: testCase testCaseUsing: candidates [
	| dictionary |
	candidates ifEmpty: [ ^ nil ].
	dictionary := Dictionary new.
	candidates
		do: [ :stm | 
			dictionary
				at:
					(stm isConstructor
						ifTrue: [ stm theClassName ]
						ifFalse: [ stm returnTypeName ])
				ifPresent: [ :aSet | aSet add: stm varName ]
				ifAbsentPut: [ {stm varName} asSet ] ].
	^ self valueOf: aClassName typeIn: testCase testCaseUsing: dictionary
]

{ #category : #testing }
SAuxiliar class >> deepOf: aObject objectGreaterThan: level [
	level < 0
		ifTrue: [ ^ true ].
	aObject class instSize = 0
		ifTrue: [ ^ false ].
	1 to: aObject class instSize do: [ :n | 
		(self deepOf: (aObject instVarAt: n) objectGreaterThan: level - 1)
			ifTrue: [
				^ true ] ].
	^ false
]

{ #category : #generation }
SAuxiliar class >> defaultConstructor: classSpy [
	"returns a new constructor with the selector 'new'"
	^ SConstructorStatement new
		theClassName: classSpy className;
		selector: 'new';
		args: #();
		yourself
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> dictInfoMethodsFrom: arrMethods [
	| dict |
	dict := Dictionary new.
	arrMethods
		do: [ :method | dict at: method selector put: method asTypeInfo ].
	^ dict
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> fillTypeInfo: aTypeInfo withDataFrom: aClass [
	|meths |
	aTypeInfo types
		at: aClass className
		put: (self dictInfoMethodsFrom: aClass methods).
	meths := aClass metaclassSpy methods.
	meths
		ifNotEmpty: [ aTypeInfo types
				at: aClass metaclassSpy className
				put: (self dictInfoMethodsFrom: meths) ]
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> initLevel: aInt [
	level := aInt
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> initLevelDefault [
	level := 10
]

{ #category : #testing }
SAuxiliar class >> isVeryDeep: aObject [
	^ self deepOf: aObject objectGreaterThan: 3
]

{ #category : #accessing }
SAuxiliar class >> level [ 
	^ level
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> listShuffle: aCollection [
	aCollection
		ifEmpty: [ ^ aCollection  ]
		ifNotEmpty: [ ^ aCollection asArray shuffle ]
]

{ #category : #'instance creation' }
SAuxiliar class >> newConstructorOf: classSpy classNameWith: selector selectorAnd: args [
	^ SConstructorStatement new
		theClassName:
			(classSpy isSymbol
				ifTrue: [ classSpy ]
				ifFalse: [ classSpy className ]);
		selector: selector;
		args: args;
		yourself
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> packagesClassesAndMethodsOf: profile filterBy: mutatedMethods [
	| packages classes methods selectors |
	packages := Set new.
	classes := Set new.
	methods := Set new.
	selectors := (mutatedMethods
		collect: [ :meth | meth originalClass name -> meth originalMethod selector ])
		asSet.
	profile allMethods
		select:
			[ :meth | selectors includes: meth classSpy className -> meth selector ]
		thenDo: [ :meth | 
			| aClass splited |
			aClass := meth classSpy.
			packages add: aClass packageSpy packageName.
			splited := aClass className splitOn: ' '.
			classes add: (splited size > 1 ifFalse: [aClass className]ifTrue: [splited first asSymbol]).
			methods add: meth classSpy className -> meth selector ].
	^ {packages.
	classes.
	methods}
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> positionToInsertAfter: position indexStatementOf: testCase testCaseHaving: newArgs [
	| positionResult |
	positionResult := position.
	newArgs
		do: [ :aArg | 
			positionResult := {positionResult.
			(testCase indexOf: aArg)} max ].
	positionResult := self
		randomNumberFrom: positionResult + 1
		to: testCase numberOfStatements.
	^ positionResult
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> randomNumberFrom: aNumber1 to: aNumber2 [
	^ self randomNumberFrom: aNumber1 to: aNumber2 default: aNumber1
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> randomNumberFrom: aNumber1 to: aNumber2 default: aNumber3 [
	| interval |
	interval := aNumber1 to: aNumber2.
	^ interval ifEmpty: [ aNumber3 ] ifNotEmpty: [ interval atRandom ]
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> randomValueCharacter: aCharacter [
	| value interval |
	interval := 33 to: 127.
	value := interval atRandom.
	[ value == aCharacter asInteger ]
		whileTrue: [ value := interval atRandom ].
	^ value
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> reduceLevel [
	level := level - 1.
]

{ #category : #removing }
SAuxiliar class >> removeOrRepair: args argsOf: aStatement statementWith: varName varNameUsing: aTestCase [
	| varToDelete replace argsResult |
	argsResult := args collect: [ :arg | arg ].
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
SAuxiliar class >> replace: varName varNameIn: receiver receiverBy: object [
	^ [ | index |
	index := receiver indexOfSubCollection: '''' , varName , ''''.
	index > 0
		ifTrue: [ receiver
				copyReplaceFrom: index + 1
				to: index + varName size 
				with: object ]
		ifFalse: [ receiver ] ]
		on: Exception
		do: [ receiver ]
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> satisfyArgs: aTestCase with: otherTestCase of: aStatement and: constructor [
	| args varNames otherVarNames resultArgs argTypes |
	args := aStatement args.
	args ifEmpty: [ ^ #() ].
	varNames := aTestCase varNames.
	otherVarNames := otherTestCase varNames.
	resultArgs := OrderedCollection new.
	argTypes := self
		typeNameArgsOf: aStatement selector
		selectorIn: constructor theClassName
		classNameUsing: aTestCase
		testCaseAnd: otherTestCase.
	argTypes
		doWithIndex: [ :argType :index | 
			| aArg found |
			found := false.
			aArg := args at: index.
			(varNames includes: aArg)
				ifTrue: [ (aTestCase statementAt: aArg) returnTypeName = argType
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
SAuxiliar class >> satisfyConstructor: aTestCase with: otherTestCase of: aStatement and: aBlock [
	| constructor |
	constructor := self
		constructorIn: aTestCase
		testCaseOf: aStatement
		statementWithBlockCondition: aBlock.
	constructor
		ifNil: [ constructor := self
				constructorIn: otherTestCase
				testCaseOf: aStatement
				statementWithBlockCondition: aBlock.
			constructor
				ifNotNil: [ constructor := aTestCase
						newConstructorStatement: constructor theClassName
						of:
							(otherTestCase spyInfo classAt: constructor theClassName)
								factoryMethods
						before: constructor varName.
					constructor ifNotNil: [ aTestCase addStatement: constructor ] ] ].
	^ constructor
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> satisfyParameters: aTestCase with: otherTestCase of: aStatement withBlocks: blocks [
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

{ #category : #testing }
SAuxiliar class >> string: aString equalsOrIncludes: otherString [
	| stringWithDoubleQuotes |
	stringWithDoubleQuotes := '''', otherString, ''''.
	^ aString = otherString
		or: [ (aString splitOn: ' ') detect: [ :subString | (subString = otherString or: [ subString = stringWithDoubleQuotes ]) or: [ subString includesSubstring: stringWithDoubleQuotes ] ] ifFound: [ true ] ifNone: [ false ] ]
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> transformReplacement: object [
	^ (object isString and: [ object beginsWith: '_' ])
		ifTrue: [ object ]
		ifFalse: [ self transformToVar: object ]
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> transformToVar: aString [
	^ '(' , aString , ')'
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> typeMethodInfoFrom: aMethod [
	^ STypeMethodInfo new
		selector: aMethod selector;
		returnType:
			([ aMethod returnType name ]
				on: Exception
				do: [ nil ]);
		argTypes:
			([ aMethod argTypes collect: #name ]
				on: Exception
				do: [ nil ]);
		yourself
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> typeNameArgsOf: selector selectorIn: aClassName classNameUsing: aTestCase [
	(aTestCase spyInfo >> aClassName) methods
		detect: [ :method | method selector = selector ]
		ifFound: [ :method | ^ method argTypes collect: [ :type | type name ] ]
		ifNone: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> typeNameArgsOf: selector selectorIn: aClassName classNameUsing: aTestCase testCaseAnd: otherTestCase [
	| typeArgs |
	typeArgs := self
		typeNameArgsOf: selector
		selectorIn: aClassName
		classNameUsing: aTestCase.
	typeArgs
		ifNotNil: [ ^ typeArgs ]
		ifNil: [ ^ self
				typeNameArgsOf: selector
				selectorIn: aClassName
				classNameUsing: otherTestCase ]
]

{ #category : #testing }
SAuxiliar class >> validDependenciesOf: statements statementsUsing: varNames [
	| currentVarNames |
	currentVarNames := OrderedCollection new.
	statements
		detect: [ :aStm | 
			(currentVarNames
				includesAll: (aStm dependenciesConsidering: varNames))
				ifTrue: [ currentVarNames add: aStm varName.
					false ]
				ifFalse: [ true ] ]
		ifFound: [ ^ false ].
	^ true
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> validate: aList ifNotValid: aBlock [
	^ (aList isNil or: [ aList isEmpty ]) ifTrue: [ aBlock value ] ifFalse: aList
]

{ #category : #'as yet unclassified' }
SAuxiliar class >> valueOf: aClassName typeIn: testCase testCaseUsing: aDictionary [
	"If the dictionary has the key = aClassName, it returns the values. Opposite if any subclass of the class is in the dictionary, its values are returned"

	aDictionary
		at: aClassName
		ifPresent: [ :value | 
			^ {(self listShuffle: value) first.
			aClassName} ]
		ifAbsent: [ | classes |
			testCase dictSubclasses
				at: aClassName
				ifPresent: [ :value | classes := (value asArray), { aClassName } ]
				ifAbsent: [ 
					classes := (Smalltalk classNamed: aClassName) subclasses
						collect: [ :aClass | aClass name ].
					classes ifEmpty: [ ^ nil ].
					testCase dictSubclasses at: aClassName put: classes asSet ].
			(self listShuffle: aDictionary keys)
				detect: [ :aName | classes includes: aName ]
				ifFound: [ :aName | 
					^ {(self listShuffle: (aDictionary at: aName) asOrderedCollection)
						first.
					aName} ].
			^ nil ]
]
