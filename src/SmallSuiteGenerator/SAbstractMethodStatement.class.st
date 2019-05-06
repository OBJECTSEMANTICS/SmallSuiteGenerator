Class {
	#name : #SAbstractMethodStatement,
	#superclass : #SStatement,
	#instVars : [
		'selector',
		'args',
		'references'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SAbstractMethodStatement >> argToString: aArg [
	^ (references isNotNil and: [ references includes: aArg ])
		ifTrue: [ aArg asString ]
		ifFalse: [ aArg storeString ]
]

{ #category : #accessing }
SAbstractMethodStatement >> args [
	^ args
]

{ #category : #accessing }
SAbstractMethodStatement >> args: anObject [
	args := anObject
]

{ #category : #private }
SAbstractMethodStatement >> createNewStatement [
	^ (self class create)
		args: self args;
		selector: self selector;
		yourself
]

{ #category : #'as yet unclassified' }
SAbstractMethodStatement >> insertParameterUsing: aTestCase [
	"insert its parameters"
	^ self insertParametersOf: self using: aTestCase
]

{ #category : #'as yet unclassified' }
SAbstractMethodStatement >> name [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SAbstractMethodStatement >> notReferenced: referencedVarNames orIrrelevant: dictStringStatement [
	| varName |
	varName := self varName.
	^ (referencedVarNames includes: varName) not
		and: [ ((dictStringStatement at: self stringBody) first ~= varName) ]
]

{ #category : #private }
SAbstractMethodStatement >> printOn: aStream [
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

{ #category : #'as yet unclassified' }
SAbstractMethodStatement >> referencesToArgs: varNames [
	references := varNames
]

{ #category : #mutation }
SAbstractMethodStatement >> repairOn: aTestCase changing: aStatement [
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
	^ self changeUsing: aTestCase.
]

{ #category : #accessing }
SAbstractMethodStatement >> selector [
	^ selector
]

{ #category : #accessing }
SAbstractMethodStatement >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
SAbstractMethodStatement >> stream: aStream withSpacesOf: arg [
	aStream
			nextPut: Character space;
			nextPutAll: (self argToString: arg);
			nextPut: Character space
]

{ #category : #'as yet unclassified' }
SAbstractMethodStatement >> stringBody [
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
