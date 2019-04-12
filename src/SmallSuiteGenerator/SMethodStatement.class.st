Class {
	#name : #SMethodStatement,
	#superclass : #SStatement,
	#instVars : [
		'selector',
		'args',
		'receiverVarName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SMethodStatement >> args [
	^ args
]

{ #category : #accessing }
SMethodStatement >> args: anObject [
	args := anObject
]

{ #category : #'as yet unclassified' }
SMethodStatement >> changeUsing: aTestCase [
	| methods calledMethods constructStatement result |
	result := #().
	constructStatement := aTestCase statementAt: self receiverVarName.
	calledMethods := (aTestCase statements
		select: #isMethod
		thenCollect: [ :method | method selector ]) asSet.
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
						changeArgsOf: args
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
SMethodStatement >> createNewStatement: aId [
	^ (self class create: aId)
		selector: self selector;
		args: self args;
		returnTypeName: self returnTypeName;
		receiverVarName: self receiverVarName;
		yourself
]

{ #category : #'as yet unclassified' }
SMethodStatement >> insertMethodCallUsing: aTestcase [
	^ self insertRandomCallUsing: aTestcase
]

{ #category : #'as yet unclassified' }
SMethodStatement >> insertParameterUsing: aTestCase [
	^ self insertParametersOf: self using: aTestCase
]

{ #category : #accessing }
SMethodStatement >> insertRandomCallUsing: aTestCase [
	| position |
	position := STransformValue
		randomNumberFrom: (aTestCase indexOf: self receiverVarName) + 1
		to: aTestCase statements size
		default: aTestCase statements size + 1.
	^ aTestCase insertStatementWithArgs: self before: position
]

{ #category : #accessing }
SMethodStatement >> isMethod [ 	
	^ true
]

{ #category : #'as yet unclassified' }
SMethodStatement >> notReferenced: referencedVarNames orIrrelevant: dictStringStatement [
	| varName |
	varName := self varName.
	^ (referencedVarNames includes: varName) not
		and: [ (dictStringStatement at: self stringBody) first ~= varName ]
]

{ #category : #printing }
SMethodStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self stringBody. "self receiverVarName.
	aStream nextPutAll: ' '.
	self args size = 0
		ifTrue: [ aStream nextPutAll: self selector ]
		ifFalse: [ (self selector substrings: ':')
				with: self args
				do: [ :selectorPart :arg | 
					aStream nextPutAll: selectorPart.
					aStream nextPutAll: ': '.
					aStream nextPutAll: arg ] ].
	aStream nextPut: $."
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
SMethodStatement >> repairOn: aTestCase changing: aStatement [
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
	^ self changeUsing: aTestCase.
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
			((aStatement createNewStatement: aTestCase assignedId)
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

{ #category : #accessing }
SMethodStatement >> selector [
	^ selector
]

{ #category : #accessing }
SMethodStatement >> selector: anObject [
	selector := anObject
]

{ #category : #printing }
SMethodStatement >> stringBody [
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: self receiverVarName;
				nextPutAll: ' '.
			self args
				ifEmpty: [ aStream nextPutAll: self selector ]
				ifNotEmpty: [ (self selector substrings: ':')
						with: self args
						do: [ :selectorPart :arg | 
							aStream
								nextPutAll: selectorPart;
								nextPutAll: ': ';
								nextPutAll: arg;
								nextPut: Character space ] ].
			aStream nextPut: $. ]
]
