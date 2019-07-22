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
	statements copy shuffle
		do: [ :stm | dict at: stm returnType put: stm variable copy ].
	^ aMethodTypeInfo argTypes collect: [ :aType | dict at: aType ]
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
	

	args isEmpty ifTrue: [ ^self error: 'cannot change args' ].
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
	copy args: args copy;
	receiver: receiver copy;
	selector: selector copy.
	^ copy
]

{ #category : #'as yet unclassified' }
SAbstractMessage >> expressionWithMaxIndex: aTestCase [
	^ aTestCase expressionWithMaxIndexFrom: { receiver }, args.
	
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
SAbstractMessage >> insertParameterUsing: aTestCase [
	(args collect: #reference)
		do: [ :ref | 
			(aTestCase statementOfVarName: ref printString)
				insertParameterUsing: aTestCase ]
]

{ #category : #'as yet unclassified' }
SAbstractMessage >> insertRandomMessageUsing: aTestCase [
	| expression |
	expression := self expressionWithMaxIndex: aTestCase.
	^ (aTestCase insertExpression: self copy after: expression) reference
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

{ #category : #accessing }
SAbstractMessage >> replaceBy: otherExpression [
	receiver replaceBy: otherExpression receiver.
	self selector: otherExpression selector.
	self args size = otherExpression args size ifTrue: [ 
	self args with: otherExpression args do: [ :arg :newArg | arg replaceBy: newArg ]] ifFalse: [ self args: otherExpression args copy ]
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
