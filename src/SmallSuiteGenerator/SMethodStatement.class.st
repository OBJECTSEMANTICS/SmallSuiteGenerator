Class {
	#name : #SMethodStatement,
	#superclass : #SAbstractStatementWithArgs,
	#instVars : [
		'receiverVarName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SMethodStatement >> changeUsing: aTestCase [
	| methods calledMethods constructStatement result |
	result := #().
	constructStatement := aTestCase statementAt: self receiverVarName.
	calledMethods := aTestCase calledMethods asSet.
	methods := (aTestCase
		methodsOrAccessors: constructStatement
		toSelect: false)
		reject: [ :method | 
			((calledMethods includes: method selector) not
				and: [ method returnType name ~= self returnTypeName ])
				or: [ method returnType name = constructStatement theClassName ] ].
	methods
		ifNotEmpty: [ | selected newArgs |
			selected := methods shuffle
				detect: [ :accessor | accessor selector ~= self selector ]
				ifFound: [ :accessor | accessor ]
				ifNone: [ methods first ].
			selected selector = self selector
				ifTrue: [ result := STransformValue
						change: args
						ofTypes: selected argTypes
						using: aTestCase.
					newArgs := result first.
					result := result second ]
				ifFalse: [ newArgs := selected argTypes
						collect: [ :class | 
							aTestCase
								createArg: class name
								before: (aTestCase indexOf: self varName)
								avoiding: nil ].
					(newArgs anySatisfy: #isNil)
						ifTrue: [ ^ result ] ].
			(aTestCase statementAt: self varName)
				selector: selected selector;
				args: newArgs ].
	^ result
]

{ #category : #'as yet unclassified' }
SMethodStatement >> collectDependencies [
	^ {receiverVarName} , (STransformValue selectVarNames: args)
]

{ #category : #private }
SMethodStatement >> createNewStatement [
	^ super createNewStatement
		returnTypeName: self returnTypeName;
		receiverVarName: self receiverVarName;
		yourself
]

{ #category : #'as yet unclassified' }
SMethodStatement >> insertMethodCallUsing: aTestcase [
	^ self insertRandomCallUsing: aTestcase
]

{ #category : #accessing }
SMethodStatement >> insertRandomCallUsing: aTestCase [
	^ aTestCase
		insertStatementWithArgs: self
		from: (aTestCase indexOf: self receiverVarName) + 1
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
			collectResult := STransformValue
				removeOrRepairArgs: args
				of: aStatement
				with: self varName
				using: aTestCase.
			(aTestCase statementAt: self varName) args: collectResult first.
			varNamesToRemove := collectResult second ].
	"if the receiverVarName must be deleted"
	aStatement varName = self receiverVarName
		ifTrue: [ | constructStatement |
			constructStatement := aTestCase
				addConstructor: aStatement
				before: self varName
				forField: false.
			constructStatement
				ifNil: [ varNamesToRemove add: self varName ]
				ifNotNil: [ (aTestCase statementAt: self varName)
						receiverVarName: constructStatement varName ] ].
	^ varNamesToRemove
]

{ #category : #'as yet unclassified' }
SMethodStatement >> satisfyParameters: aTestCase with: otherTestCase [
	| blockCondition blockInsertion |
	blockCondition := [ :testCase :stmOfCollection :aStatement | 
	((testCase methodsOrAccessors: stmOfCollection toSelect: false)
		collect: #selector) includes: aStatement selector ].
	blockInsertion := [ :testCase :aStatement :constructor :aArgs | 
	^ testCase
		addStatement:
			((aStatement createNewStatement)
				receiverVarName: constructor varName;
				args: aArgs;
				yourself) ].
	^ STransformValue
		satisfyParameters: aTestCase
		with: otherTestCase
		of: self
		withBlocks:
			{blockCondition.
			blockInsertion}
]
