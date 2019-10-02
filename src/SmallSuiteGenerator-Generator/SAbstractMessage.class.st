Class {
	#name : #SAbstractMessage,
	#superclass : #SExpression,
	#instVars : [
		'receiver',
		'selector',
		'args'
	],
	#category : #'SmallSuiteGenerator-Generator-Nodes'
}

{ #category : #creation }
SAbstractMessage class >> args: aMethodTypeInfo with: statements [
	| dict |
	(statements isEmpty or: [ aMethodTypeInfo argTypes isNil ])
		ifTrue: [ ^ #() ].
	((statements
		collect: #returnType
		thenSelect: [ :aType | aType isNotNil ]) asSet
		includesAll: (aMethodTypeInfo argTypes flatCollect: [ :arg | arg types ]))
		ifFalse: [ ^ SError error: 'statements dont contain some types of method' ].
	dict := Dictionary new.
	statements copy shuffle
		do: [ :stm | 
			dict
				at: stm returnType
				put:  stm variable copy ].
	^ aMethodTypeInfo argTypes
		collect: [ :aTypeReturn | dict at: aTypeReturn type ]
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

{ #category : #'as yet unclassified' }
SAbstractMessage >> changeArgsFrom: aExpression in: aTestCase [
	args isEmpty
		ifTrue: [ ^ self error: 'cannot change args' ].
	args do: [ :arg | arg repairOn: aTestCase changing: aExpression ]
]

{ #category : #'as yet unclassified' }
SAbstractMessage >> changeReceiverFrom: aExpression in: aTestCase [
	receiver repairOn: aTestCase changing: aExpression
]

{ #category : #'as yet unclassified' }
SAbstractMessage >> changeSelectorFrom: aExpression in: aTestCase [
	^ self subclassResponsibility
]

{ #category : #copying }
SAbstractMessage >> copy [ 
	| copy|
	copy := super copy.
	copy args: args deepCopy;
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
SAbstractMessage >> insertRandomMessage: aExpression using: aTestCase [
	^ aTestCase insertExpression: self copy after: aExpression
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
		ifNotEmpty: [ | withColon index stop |
			withColon := self selector includes: $:.
			index := 0.
			stop := self args size.
			(self selector substrings: ':')
				with: self args
				do: [ :selectorPart :arg | 
					index := index + 1.
					aStream nextPutAll: selectorPart.
					withColon
						ifTrue: [ aStream nextPutAll: ': ' ].
					aStream nextPutAll: arg asString.
					(index < stop and: [ withColon  ]) ifTrue: [ 
						aStream nextPut: Character space.
						 ] ] ].
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

{ #category : #mutation }
SAbstractMessage >> repairOn: aTestCase changing: aExpression [
	#(#changeReceiverFrom:in: #changeSelectorFrom:in: #changeArgsFrom:in:)
		shuffle
		do: [ :aSelector | 
			[^ self
				perform: aSelector
				withArguments:
					{aExpression.
					aTestCase} ] on: SError do: []].
	self
				error: 'cant change the statement: ', aExpression reference printString
]

{ #category : #'as yet unclassified' }
SAbstractMessage >> replaceArgBy: aExpression [
	args ifEmpty: [ self error: 'cant insert expression as parameter' ].
	args
		do: [ :arg | 
			[ ^ arg replaceArgBy: aExpression ]
				on: SError
				do: [  ] ].
	self error: 'cant insert as parameter'
]

{ #category : #accessing }
SAbstractMessage >> replaceBy: otherExpression [
	receiver replaceBy: otherExpression receiver.
	self selector: otherExpression selector.
	self args size = otherExpression args size ifTrue: [ 
	self args with: otherExpression args do: [ :arg :newArg | arg replaceBy: newArg ]] ifFalse: [ self args: otherExpression args deepCopy ]
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

{ #category : #'as yet unclassified' }
SAbstractMessage >> variablesWithId [
	^ receiver variablesWithId , (args flatCollect: [:arg | arg variablesWithId])
]
