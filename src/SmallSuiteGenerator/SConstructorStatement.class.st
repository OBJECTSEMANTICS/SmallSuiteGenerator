Class {
	#name : #SConstructorStatement,
	#superclass : #SStatement,
	#instVars : [
		'theClassName',
		'selector',
		'args'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SConstructorStatement >> args [
	^ args
]

{ #category : #accessing }
SConstructorStatement >> args: anObject [
	args := anObject
]

{ #category : #private }
SConstructorStatement >> createNewStatement [
	^ self class create 
	args: self args;
	selector: self selector;
	theClassName: self theClassName; yourself
	
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> insertMethodCallUsing: aTestcase [
	^ -1
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> insertParameterUsing: aTestcase [
	args
		ifNotEmpty: [ | varNames position argsCopy index newStatement |
			argsCopy := args deepCopy.
			varNames := aTestcase statements collect: #varName.
			index := 0.
			argsCopy
				detect: [ :aArg | 
					index := index + 1.
					(varNames includes: aArg)
						ifTrue: [ | interval |
							newStatement := (aTestcase statementAt: aArg)
								createNewStatement.
							interval := (1 to: (aTestcase indexOf: self varName) - 1).
							position := interval ifEmpty: [ 1 ] ifNotEmpty: [ interval atRandom ].
							aTestcase addStatement: newStatement at: position ]
						ifFalse: [ false ] ]
				ifFound: [ args at: index put: newStatement varName.
						^ position
					 ] ifNone: [ ^ -1 ] ].
			
	^ -1
]

{ #category : #accessing }
SConstructorStatement >> insertRandomCallAt: position using: aTestCase [
	| argsNewConstructor newPosition |
	argsNewConstructor := self
		satisfyParameters: aTestCase
		before: position
		allowingNull: true
		of: self.
	argsNewConstructor
		ifNotNil: [ 
			| index |
			index := aTestCase indexOf: argsNewConstructor last.
			newPosition := index > 0 ifTrue: [ (index + 1 to: aTestCase statements size) atRandom] ifFalse: [(1 to: aTestCase statements size) atRandom].
			(aTestCase
				addStatement:
					(SConstructorStatement create
						args: argsNewConstructor;
						selector: self selector;
						theClassName: self theClassName;
						yourself)
				at: newPosition)
				ifTrue: [ ^ newPosition ] ].
	^ -1
]

{ #category : #accessing }
SConstructorStatement >> isConstructor [
	^ true.
]

{ #category : #printing }
SConstructorStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self theClassName.
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

{ #category : #mutation }
SConstructorStatement >> repairOn: aTestCase changing: aStatement [
	| collection |
	self varName = aStatement varName ifFalse: [ ^ #() ].
	collection := self change: args using: aTestCase of: aStatement.
	(aTestCase statements at: (aTestCase indexOf: self varName))
		args: collection first.
	^ collection second
]

{ #category : #mutation }
SConstructorStatement >> repairOn: aTestCase deleting: aStatement [
	"aStatement varName = self varName
		ifFalse: [ ^ self ]"

	| collection |
	collection := self
		removeStatementsOf: aStatement
		using: aTestCase
		in: args.
	(aTestCase statements at: (aTestCase indexOf: self varName)) args: collection first.
	^ collection second
	"aTestCase statements
		select: [ :statement | 
			(statement isField or: [ statement isMethod ])
				and: [ statement receiverVarName = aStatement varName ] ]
		thenDo: [ :statement | aTestCase remove: statement varName ]"
]

{ #category : #accessing }
SConstructorStatement >> selector [
	^ selector
]

{ #category : #accessing }
SConstructorStatement >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
SConstructorStatement >> theClassName [
	^ theClassName
]

{ #category : #accessing }
SConstructorStatement >> theClassName: anObject [
	theClassName := anObject
]
