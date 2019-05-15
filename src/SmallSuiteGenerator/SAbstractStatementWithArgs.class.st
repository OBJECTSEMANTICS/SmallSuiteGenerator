Class {
	#name : #SAbstractStatementWithArgs,
	#superclass : #SStatement,
	#instVars : [
		'selector',
		'args',
		'references'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SAbstractStatementWithArgs >> alternativeMethodIn: methods [
	^ methods
		detect: [ :aMethod | aMethod selector ~= self selector ]
		ifFound: [ :aMethod | aMethod ]
		ifNone: [  ]
]

{ #category : #accessing }
SAbstractStatementWithArgs >> argToString: aArg [
	^ (references isNotNil and: [ references includes: aArg ])
		ifTrue: [ aArg asString ]
		ifFalse: [ aArg storeString ]
]

{ #category : #accessing }
SAbstractStatementWithArgs >> args [
	^ args
]

{ #category : #accessing }
SAbstractStatementWithArgs >> args: anObject [
	args := anObject
]

{ #category : #'as yet unclassified' }
SAbstractStatementWithArgs >> changeUsing: aTestCase [
	self subclassResponsibility 
]

{ #category : #private }
SAbstractStatementWithArgs >> createNewStatement [
	^ (self class create)
		args: self args;
		selector: self selector;
		yourself
]

{ #category : #'as yet unclassified' }
SAbstractStatementWithArgs >> insertParameterUsing: aTestCase [
	"insert its parameters"
	^ self insertParametersOf: self using: aTestCase
]

{ #category : #'as yet unclassified' }
SAbstractStatementWithArgs >> name [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SAbstractStatementWithArgs >> notReferenced: referencedVarNames orIrrelevant: dictStringStatement [
	| varName |
	varName := self varName.
	^ (referencedVarNames includes: varName) not
		and: [ ((dictStringStatement at: self stringBody) first ~= varName) ]
]

{ #category : #private }
SAbstractStatementWithArgs >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self stringBody
]

{ #category : #'as yet unclassified' }
SAbstractStatementWithArgs >> referencesToArgs: varNames [
	references := varNames
]

{ #category : #mutation }
SAbstractStatementWithArgs >> repairOn: aTestCase changing: aStatement [
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
	^ self changeUsing: aTestCase.
]

{ #category : #accessing }
SAbstractStatementWithArgs >> selector [
	^ selector
]

{ #category : #accessing }
SAbstractStatementWithArgs >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
SAbstractStatementWithArgs >> stream: aStream withSpacesOf: arg [
	aStream
			nextPut: Character space;
			nextPutAll: (self argToString: arg);
			nextPut: Character space
]

{ #category : #'as yet unclassified' }
SAbstractStatementWithArgs >> stringBody [
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: self name;
				nextPutAll: ' '.
			self args
				ifEmpty: [ aStream nextPutAll: self selector ]
				ifNotEmpty: [ | withColon |
					withColon := self selector includes: $:.
					(self selector substrings: ':')
						with: self args
						do: [ :selectorPart :arg | 
							aStream nextPutAll: selectorPart.
							withColon
								ifTrue: [ aStream nextPutAll: ':' ].
							self stream: aStream withSpacesOf: arg ] ].
			aStream nextPut: $. ]
]
