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
		do: [ :stm | dict at: stm returnType put: stm variable ].
	^ aMethodTypeInfo argTypes
		collect: [ :aType |  dict at: aType ]
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
	"| newArgs |
	newArgs := args
		collect: [ :arg | 
			[ [ aTestCase alternativeStatementOf: arg before: aExpression ]
				on: SError
				do: [ aTestCase addStatementOfType: arg returnType before: aExpression ] ]
				on: SError
				do: [ arg ] ].
	self args: newArgs.
	aTestCase replaceFrom: aExpression with: self"
]

{ #category : #'as yet unclassified' }
SAbstractMessage >> changeReceiverFrom: aExpression in: aTestCase [
	| otherExpression |
	otherExpression := receiver repairOn: aTestCase changing: aExpression.
	self receiver: otherExpression.
	"aTestCase replaceFrom: aExpression with: self"
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
		detect: [ :sel | 
			self
				perform: sel
				withArguments:
					{aExpression.
					aTestCase} ]
		ifNone: [ self
				error: 
				(String streamContents: [:s | 
		 s nextPutAll: 'cant change the statement: ';
		nextPutAll: aExpression reference printString ])]
	
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
