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

{ #category : #'as yet unclassified' }
STransformValue class >> changeAndTransform: aObject [
	^ self change: (self transform: aObject)
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
STransformValue class >> changeArgsOf: aStatement using: aTestCase [
	| varToChange argsResult varNames args |
	args := aStatement args.
	argsResult := args deepCopy.
	varToChange := OrderedCollection new.
	varNames := aTestCase varNames.
	args
		withIndexDo: [ :aArg :index | 
			(varNames includes: aArg)
				ifTrue: [ varToChange add: aArg ]
				ifFalse: [ argsResult at: index put: (self change: (self transform: aArg)) ] ].
	^ {argsResult.
	varToChange}
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
