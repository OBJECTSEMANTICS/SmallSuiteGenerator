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

{ #category : #private }
SMethodStatement >> createNewStatement [
	^ self class create
		selector: self selector;
		args: self args;
		returnTypeName: self returnTypeName;
		yourself
]

{ #category : #'as yet unclassified' }
SMethodStatement >> insertMethodCallUsing: aTestcase [
	^ self insertRandomCallAt: aTestcase statements size using: aTestcase
]

{ #category : #'as yet unclassified' }
SMethodStatement >> insertParameterUsing: aTestcase [
	args
		ifNotEmpty: [ | varNames position argsCopy index newStatement |
			argsCopy := args deepCopy.
			varNames := aTestcase statements collect: #varName.
			index := 0.
			argsCopy
				detect: [ :aArg | 
					index := index + 1.
					(varNames includes: aArg)
						ifTrue: [ newStatement := (aTestcase statementAt: aArg) createNewStatement.
							position := (1 to: (aTestcase indexOf: self varName) - 1)
								atRandom.
							aTestcase addStatement: newStatement at: position ]
						ifFalse: [ false ] ]
				ifFound: [ args at: index put: newStatement varName.
					^ position ]
				ifNone: [ ^ -1 ] ].
	^ -1
]

{ #category : #accessing }
SMethodStatement >> insertRandomCallAt: position using: aTestCase [
	| aPosition argsNewMethod interval |
	interval := (aTestCase indexOf: self receiverVarName) + 1 to: aTestCase statements size.
	aPosition := interval
		ifEmpty: [ aTestCase statements size + 1 ]
		ifNotEmpty: [ interval atRandom ].
	argsNewMethod := self
		satisfyParameters: aTestCase
		before: aPosition
		allowingNull: true
		of: self.
	argsNewMethod
		ifNotNil: [ (aTestCase
				addStatement:
					(SMethodStatement create
						args: argsNewMethod;
						selector: self selector;
						receiverVarName: self receiverVarName;
						returnTypeName: self returnTypeName;
						yourself)
				at: aPosition)
				ifTrue: [ ^ aPosition ] ].
	^ -1
]

{ #category : #accessing }
SMethodStatement >> isMethod [ 	
	^ true
]

{ #category : #printing }
SMethodStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self receiverVarName.
	aStream nextPutAll: ' '.
	self args size = 0
		ifTrue: [ aStream nextPutAll: self selector ]
		ifFalse: [ (self selector substrings: ':')
				with: self args
				do: [ :selectorPart :arg | 
					aStream nextPutAll: selectorPart.
					aStream nextPutAll: ': '.
					aStream nextPutAll: arg ] ].
	aStream nextPut: $.
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
	aTestCase changeMethod: aStatement.
	^ #()
]

{ #category : #mutation }
SMethodStatement >> repairOn: aTestCase deleting: aStatement [
	| varNamesToRemove collectResult |
	collectResult := self
		removeStatementsOf: aStatement
		using: aTestCase
		in: args.
	(aTestCase statements at: (aTestCase indexOf: self varName))
		args: collectResult first.
	varNamesToRemove := collectResult second.
	aStatement varName = self receiverVarName
		ifFalse: [ ^ varNamesToRemove ].
	(aTestCase addConstructorMethod: aStatement before: self varName)
		ifFalse: [ varNamesToRemove add: self varName ].
	^ varNamesToRemove
]

{ #category : #accessing }
SMethodStatement >> selector [
	^ selector
]

{ #category : #accessing }
SMethodStatement >> selector: anObject [
	selector := anObject
]
