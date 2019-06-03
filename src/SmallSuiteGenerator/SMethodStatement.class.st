Class {
	#name : #SMethodStatement,
	#superclass : #SAbstractStatementWithArgs,
	#instVars : [
		'receiverVarName'
	],
	#classInstVars : [
		'blockCondition',
		'blockInsertion'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SMethodStatement class >> blockCondition [
	blockCondition ifNil: [ 
		blockCondition := [ :testCase :stmOfCollection :aStatement | 
	((testCase methodsOrAccessors: stmOfCollection toSelect: false)
		collect: #selector) includes: aStatement selector ] ].
	^ blockCondition
	
]

{ #category : #accessing }
SMethodStatement class >> blockInsertion [

	blockInsertion ifNil: [ blockInsertion := [ :testCase :aStatement :constructor :aArgs | 
	testCase
		addStatement:
			(aStatement createNewStatement
				receiverVarName: constructor varName;
				args: aArgs;
				yourself) ]].
	^ blockInsertion
]

{ #category : #'as yet unclassified' }
SMethodStatement >> alternativeArgsOf: selected using: aTestCase [
	^ selected argTypes
		collect: [ :class | 
			aTestCase
				createArg: class name
				before: (aTestCase indexOf: self varName)
				avoiding: nil ]
]

{ #category : #'as yet unclassified' }
SMethodStatement >> alternativeMethods: aTestCase [
	| calledMethods constructStatement |
	constructStatement := aTestCase statementAt: self receiverVarName.
	calledMethods := aTestCase calledMethods asSet.
	^ (aTestCase methodsOrAccessors: constructStatement toSelect: false)
		reject: [ :method | 
			((calledMethods includes: method selector) not
				and: [ method returnType name ~= self returnTypeName ])
				or: [ method returnType name = constructStatement theClassName ] ]
]

{ #category : #'as yet unclassified' }
SMethodStatement >> changeUsing: aTestCase [
	| methods result |
	result := #().
	methods := self alternativeMethods: aTestCase.
	methods
		ifNotEmpty: [ | method newArgs |
			method := self alternativeMethodIn: methods shuffle.
			method ifNil: [ method := methods first ].
			method selector = self selector
				ifTrue: [ result := SAuxiliar
						change: args
						argsOf: method argTypes
						typesUsing: aTestCase.
					newArgs := result first.
					result := result second ]
				ifFalse: [ newArgs := self alternativeArgsOf: method using: aTestCase.
				aTestCase allowNullParameters ifFalse: [ (newArgs anySatisfy: #isNil)
						ifTrue: [ ^ result ] ]
					 ].
			(aTestCase statementAt: self varName)
				selector: method selector;
				args: newArgs ].
	^ result
]

{ #category : #private }
SMethodStatement >> createNewStatement [
	^ super createNewStatement
		returnTypeName: self returnTypeName;
		receiverVarName: self receiverVarName;
		yourself
]

{ #category : #'as yet unclassified' }
SMethodStatement >> dependenciesConsidering: varNames [
	^ {receiverVarName} , (args select: [ :arg | varNames includes: arg ])
]

{ #category : #'as yet unclassified' }
SMethodStatement >> insertMethodCallUsing: aTestcase [
	^ self insertRandomCallUsing: aTestcase
]

{ #category : #accessing }
SMethodStatement >> insertRandomCallUsing: aTestCase [
	^ aTestCase
		insert: self
		statementWithArgsBefore: self receiverVarName
]

{ #category : #accessing }
SMethodStatement >> isMethod [ 	
	^ true
]

{ #category : #printing }
SMethodStatement >> name [
	^ self receiverVarName
]

{ #category : #accessing }
SMethodStatement >> receiverVarName [
	^ receiverVarName
]

{ #category : #accessing }
SMethodStatement >> receiverVarName: anObject [
	receiverVarName := anObject
]

{ #category : #mutation }
SMethodStatement >> repairOn: aTestCase deleting: aStatement [
	| varNamesToRemove |
	varNamesToRemove := OrderedCollection new.
	(args includes: aStatement varName)
		ifTrue: [ | collectResult |
			collectResult := SAuxiliar
				removeOrRepair: args
				argsOf: aStatement
				statementWith: self varName
				varNameUsing: aTestCase.
			(aTestCase statementAt: self varName) args: collectResult first.
			varNamesToRemove := collectResult second ].
	"if the receiverVarName must be deleted"
	aStatement varName = self receiverVarName
		ifTrue: [ varNamesToRemove
				addAll: (self repairReferencesOf: aStatement in: aTestCase) ].
	^ varNamesToRemove
]

{ #category : #'as yet unclassified' }
SMethodStatement >> repairReferencesOf: aStatement in: aTestCase [
	| constructStatement |
	constructStatement := aTestCase
		addConstructor: aStatement
		before: self varName
		forField: false.
	constructStatement
		ifNil: [ ^ {self varName} ]
		ifNotNil: [ (aTestCase statementAt: self varName)
				receiverVarName: constructStatement varName ].
	^ {  }
]

{ #category : #'as yet unclassified' }
SMethodStatement >> replace: varName varNameBy: stmToReplace [
	super replace: varName varNameBy: stmToReplace.
	receiverVarName = varName
		ifTrue: [ receiverVarName := SAuxiliar transformToVar: stmToReplace valueInline ]
]

{ #category : #'as yet unclassified' }
SMethodStatement >> satisfyParameters: aTestCase with: otherTestCase [
	^ SAuxiliar
		satisfyParameters: aTestCase
		with: otherTestCase
		of: self
		withBlocks:
			{self class blockCondition.
			self class blockInsertion}
]
