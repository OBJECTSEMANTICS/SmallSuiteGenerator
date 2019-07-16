Class {
	#name : #SAbstractMessage,
	#superclass : #SExpression,
	#instVars : [
		'receiver',
		'selector',
		'args'
	],
	#category : #'SSGenerator-Nodes'
}

{ #category : #creation }
SAbstractMessage class >> args: aMethodTypeInfo with: statements [
	| dict |
	(statements isEmpty or: [ aMethodTypeInfo argTypes isEmpty ])
		ifTrue: [ ^ #() ].
	dict := Dictionary new.
	((statements collect: #returnType) asSet
		includesAll: aMethodTypeInfo argTypes)
		ifFalse: [ ^ SError error: 'statements dont contain soms types of method' ].
	 (statements copy shuffle
		do: [ :stm | dict at: stm returnType put: stm variable ]).
	^ aMethodTypeInfo argTypes collect: [ :aType | dict at: aType ]

	" review
	aMethodTypeInfo argTypes
		collect: [ :className | 
			assocs
				detect: [ :assoc | assoc key = className ]
				ifFound: [ :assoc | assoc value ]
				ifNone: [ self error: 'we could find an argument of type ' , className ] ].
		collect: [ :className | 
			assocs
				detect: [ :assoc | assoc key = className ]
				ifFound: [ :assoc | assoc value ]
				ifNone: [ SError signal: 'we could find an argument of type ' , className ] ]"
]

{ #category : #comparing }
SAbstractMessage >> = other [
	^ super = other and: [ args = other args and: [ receiver = other receiver and: [ selector = other selector ] ] ]
]

{ #category : #accessing }
SAbstractMessage >> args [
	^ args
]

{ #category : #accessing }
SAbstractMessage >> args: anObject [
	args := anObject
]

{ #category : #copying }
SAbstractMessage >> copy [ 
	| copy|
	copy := super copy.
	copy args: args copy;
	receiver: receiver copy;
	selector: selector copy.
	^ copy
]

{ #category : #comparing }
SAbstractMessage >> hash [ 	
	^ super hash xor: (receiver hash xor: (selector hash xor: args hash))
]

{ #category : #accessing }
SAbstractMessage >> id [ 
	^ receiver id
]

{ #category : #initialization }
SAbstractMessage >> initialize [ 	
	args := #().
]

{ #category : #'as yet unclassified' }
SAbstractMessage >> pickUpReferences: aExpression [
	^ (receiver pickUpReferences: aExpression)
		, (args flatCollect: [ :arg | arg pickUpReferences: aExpression ])
]

{ #category : #printing }
SAbstractMessage >> printOn: aStream [
	receiver printOn: aStream.
	aStream	nextPut: Character space.
	self printSelectors: aStream
]

{ #category : #printing }
SAbstractMessage >> printSelectors: aStream [
	args
		ifEmpty: [ aStream nextPutAll: self selector ]
		ifNotEmpty: [ | withColon |
			withColon := self selector includes: $:.
			(self selector substrings: ':')
				with: self args
				do: [ :selectorPart :arg | 
					aStream nextPutAll: selectorPart.
					withColon
						ifTrue: [ aStream nextPutAll: ': ' ].
					aStream nextPutAll: arg asString ] ].
	aStream nextPut: $.
]

{ #category : #accessing }
SAbstractMessage >> receiver [
	^ receiver
]

{ #category : #accessing }
SAbstractMessage >> receiver: anObject [
	receiver := anObject
]

{ #category : #actions }
SAbstractMessage >> replaceExpression: anExpression by: newExpression [
	receiver replaceExpression: anExpression by: newExpression.
	args
		do: [ :arg | arg replaceExpression: anExpression by: newExpression ]
]

{ #category : #accessing }
SAbstractMessage >> selector [
	^ selector
]

{ #category : #accessing }
SAbstractMessage >> selector: anObject [
	selector := anObject
]
