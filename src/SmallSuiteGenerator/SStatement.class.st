Class {
	#name : #SStatement,
	#superclass : #Object,
	#instVars : [
		'id',
		'returnTypeName'
	],
	#classVars : [
		'counter'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'class initialization' }
SStatement class >> create [
	| inst |
	inst := self new.
	inst id: counter.
	counter := counter + 1.
	^ inst
]

{ #category : #'class initialization' }
SStatement class >> initialize [
	super initialize.
	counter := 0.
	
]

{ #category : #'class initialization' }
SStatement class >> reset [
	counter := 0.
]

{ #category : #mutation }
SStatement >> change: aScalar [
	aScalar isNumber
		ifTrue: [ ^ (aScalar + (1 to: 100) atRandom) printString ].
	aScalar isCharacter
		ifTrue: [ ^ (Character value: (33 to: 127) atRandom) printString ].
	aScalar class superclass = Boolean
		ifTrue: [ aScalar
				ifTrue: [ ^ false printString ]
				ifFalse: [ ^ true printString ] ].
	"aScalar isArray
		ifTrue: [ ^ aScalar shuffle ]."
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
SStatement >> change: args using: aTestCase of: aStatement [
	| varToChange argsResult varNames |
	argsResult := args deepCopy.
	varToChange := OrderedCollection new.
	varNames := aTestCase statements
		collect: [ :statement | statement varName ].
	args
		withIndexDo: [ :aArg :index | 
			(varNames includes: aArg)
				ifTrue: [ varToChange add: aArg ]
				ifFalse: [ argsResult
						at: index
						put: (self change: (self transform: aArg))] ].
	^ {argsResult.
	varToChange}
]

{ #category : #private }
SStatement >> createNewStatement [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SStatement >> exchange: aArg using: aTestCase before: position allowingNull: aBoolean [
	| listCandidates argToUse |
	argToUse := aArg.
	listCandidates := aTestCase statements copyFrom: 1 to: position - 1.
	listCandidates
		ifNotEmpty: [ | referencedStm |
			referencedStm := aTestCase statements at: (aTestCase indexOf: aArg).
			listCandidates 
				detect: [ :aStm | aStm returnTypeName = referencedStm returnTypeName ]
				ifFound: [ :aStm | argToUse := aStm varName ]
				ifNone: [ aBoolean
						ifTrue: [ argToUse := nil ] ] ].
	^ argToUse
]

{ #category : #accessing }
SStatement >> id [
	^ id
]

{ #category : #accessing }
SStatement >> id: anInteger [
	id:= anInteger.
]

{ #category : #'as yet unclassified' }
SStatement >> insertMethodCallUsing: aTestcase [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SStatement >> insertParameterUsing: aTestcase [
	^ self subclassResponsibility
]

{ #category : #accessing }
SStatement >> insertRandomCallAt: position using: aTestCase [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SStatement >> isConstructor [
	^ false
]

{ #category : #accessing }
SStatement >> isField [
	^ false.
]

{ #category : #accessing }
SStatement >> isMethod [
	^ false.
]

{ #category : #accessing }
SStatement >> isPrimitive [
	^ false
]

{ #category : #printing }
SStatement >> printOn: aStream [
	^ self subclassResponsibility.
]

{ #category : #removing }
SStatement >> removeStatementsOf: aStatement using: aTestCase in: args [
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
				avoiding: aStatement varName.
			newArg
				ifNil: [ varToDelete add: stringArg ]
				ifNotNil: [ replace at: stringArg put: newArg ] ].
	varToDelete
		ifEmpty: [ argsResult := args
				collect: [ :arg | replace at: arg ifAbsent: [ arg ] ] ].
	"ifNotEmpty: [ varToDelete do: [ :var | aTestCase remove: var ] ]."
	^ {argsResult.
	varToDelete}
]

{ #category : #mutation }
SStatement >> repairOn: aTestCase changing: aStatement [
	^ self subclassResponsibility
]

{ #category : #mutation }
SStatement >> repairOn: aTestCase deleting: aStatement [
	^ self subclassResponsibility.
]

{ #category : #accessing }
SStatement >> returnTypeName [
	^ returnTypeName
]

{ #category : #accessing }
SStatement >> returnTypeName: anObject [
	returnTypeName := anObject
]

{ #category : #'as yet unclassified' }
SStatement >> satisfyParameters: aTestCase before: position allowingNull: aBoolean of: aStatement [
	| argsResult varNames args |
	args := aStatement args.
	args
		ifNotNil: [ argsResult := OrderedCollection ofSize: args size.
			varNames := aTestCase statements
				collect: [ :statement | statement varName ].
			args
				withIndexDo: [ :aArg :index | 
					(varNames includes: aArg)
						ifTrue: [ argsResult
								at: index
								put:
									(self
										exchange: aArg
										using: aTestCase
										before: position
										allowingNull: aBoolean) ]
						ifFalse: [ argsResult at: index put: (self change: (self transform: aArg)) ] ].
			^ argsResult ].
	^ nil
]

{ #category : #removing }
SStatement >> statementsToRemove: aStatement using: aTestCase in: args [
	| varToDelete replace |
	varToDelete := OrderedCollection new.
	replace := Dictionary new.
	args
		select: [ :stringArg | stringArg = aStatement varName ]
		thenDo: [ :stringArg | 
			| newArg |
			newArg := aTestCase createArg: aStatement returnType before: stringArg.
			newArg
				ifNil: [ varToDelete add: stringArg ]
				ifNotNil: [ replace at: stringArg put: newArg ] ].
	^ {varToDelete.
	replace}
]

{ #category : #accessing }
SStatement >> transform: aString [
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
	"((aString beginsWith: '#(') and: [ aString endsWith: ')' ])
	ifTrue: [ ^  ]."
	^ aString
]

{ #category : #accessing }
SStatement >> varName [
	^ self variableKeyword , id asString
]

{ #category : #'as yet unclassified' }
SStatement >> variableKeyword [
	^  '_var'

]
