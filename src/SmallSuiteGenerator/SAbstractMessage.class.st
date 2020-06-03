"
Abstract class of nodes for
	- messages (access messages and messages that update the state of a class)
	- factory methods (to represent the class creation messages),
	- assertion messages (to represent assertion messages that match with an according requirement)

Instance Variables
	args:		    <Collection>
	receiver:		 <Symbol>
	selector:		 <Symbol>
"
Class {
	#name : #SAbstractMessage,
	#superclass : #SExpression,
	#instVars : [
		'receiver',
		'selector',
		'args'
	],
	#category : #'SmallSuiteGenerator-AST'
}

{ #category : #creation }
SAbstractMessage class >> args: aMethodTypeInfo with: statements [
	| dict |
	(statements isEmpty or: [ aMethodTypeInfo argTypes isNil ])
		ifTrue: [ ^ #() ].
	dict := Dictionary new.
	(SPlatform randomGenerator collectAtRandom: statements)
		do: [ :stm | dict at: stm returnType put: stm variable copy ].
	^ aMethodTypeInfo argTypes
		collect: [ :aTypeReturn | 
			| ft |
			ft := (SPlatform randomGenerator collectAtRandom: aTypeReturn types) "lack to update types of MultiTypeInfo"
				detect: [ :type | dict at: type ifPresent: [ true ] ifAbsent: [ false ] ]
				ifNone: [ nil ].
			ft
				ifNil: [ self
						error:
							'Cannot build the method call: ' , aMethodTypeInfo selector
								, ', even it was tried to build the argument first' ].
			dict at: ft ]
]

{ #category : #comparing }
SAbstractMessage >> = other [
	^ super = other 
		and: [ args = other args 
			and: [ receiver = other receiver 
				and: [ (selector = other selector) ] ] ]
]

{ #category : #accessing }
SAbstractMessage >> args [
	^ args
]

{ #category : #accessing }
SAbstractMessage >> args: anObject [
	args := anObject
]

{ #category : #mutation }
SAbstractMessage >> changeArgsFrom: expression in: aTestCase [
	args isEmpty
		ifTrue: [ ^ self error: 'Cannot change args from: ', self selector  ].
	args do: [ :arg | arg repairOn: aTestCase changing: expression ]
]

{ #category : #mutation }
SAbstractMessage >> changeReceiverFrom: expression in: aTestCase [
	receiver repairOn: aTestCase changing: expression
]

{ #category : #override }
SAbstractMessage >> changeSelectorFrom: aExpression in: aTestCase [
	^ self subclassResponsibility
]

{ #category : #copying }
SAbstractMessage >> copy [
	| copy |
	copy := super copy.
	copy
		args: args deepCopy;
		receiver: receiver copy;
		selector: selector copy.
	^ copy
]

{ #category : #comparing }
SAbstractMessage >> hash [
  ^super hash bitXor: (receiver hash bitXor: (selector hash bitXor: args hash))
]

{ #category : #accessing }
SAbstractMessage >> id [ 
	^ receiver id
]

{ #category : #initialization }
SAbstractMessage >> initialize [
	super initialize.
	args := OrderedCollection new: 2
]

{ #category : #mutation }
SAbstractMessage >> insertRandomMessage: expression using: aTestCase [
	| anotherExpression |
	anotherExpression := self copy.
	anotherExpression mutated: true.
	anotherExpression needsBeFixed: true.
	^ aTestCase insertExpression: anotherExpression after: expression
]

{ #category : #accessing }
SAbstractMessage >> mutated [ 
	^ mutated or: [receiver mutated or: [ args detect: #mutated ifFound: [ true ] ifNone: [ false ] ]]
]

{ #category : #mutation }
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
					aStream nextPutAll: arg printString.
					(index < stop and: [ withColon ])
						ifTrue: [ aStream nextPut: Character space ] ] ]
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
SAbstractMessage >> repairOn: aTestCase changing: expression [
	(self random collectAtRandom: #(#changeReceiverFrom:in: #changeSelectorFrom:in: #changeArgsFrom:in:))
		do: [ :aSelector | 
			[ ^ self
				perform: aSelector
				withArguments: (Array with: expression with: aTestCase) ]
				on: SError
				do: [  ] ].
	self error: 'Cannot change the statement: ' , expression printString
]

{ #category : #mutation }
SAbstractMessage >> replaceArgBy: expression [
	args ifEmpty: [ self error: self printString, ' does not have args to replace.' ].
	
	args do: [ :arg | [ ^ arg replaceArgBy: expression ] on: SError do: [  ] ].
	self error: 'Cannot replace any argument by: ', expression printString
]

{ #category : #accessing }
SAbstractMessage >> replaceBy: anAbstractMessage [
	" I replace my attributes values with the ones in the otherExpression."
	
	mutated := (receiver ~= anAbstractMessage receiver) or: [( selector ~= anAbstractMessage selector) or: [ args ~= anAbstractMessage args ]].
	receiver replaceBy: anAbstractMessage receiver.
	self selector: anAbstractMessage selector.
	self args size = anAbstractMessage args size
		ifTrue: [ self args
				with: anAbstractMessage args
				do: [ :arg :newArg | arg replaceBy: newArg ] ]
		ifFalse: [ self args: anAbstractMessage args deepCopy ].
]

{ #category : #actions }
SAbstractMessage >> replaceExpression: anExpression by: newExpression [
	"It replace the references to this expresion to the newExpresion"
	receiver replaceExpression: anExpression by: newExpression.
	args do: [ :arg | arg replaceExpression: anExpression by: newExpression ]
]

{ #category : #accessing }
SAbstractMessage >> selector [
	^ selector
]

{ #category : #accessing }
SAbstractMessage >> selector: anObject [
	selector := anObject
]

{ #category : #mutation }
SAbstractMessage >> variablesWithId [
	^ receiver variablesWithId , (args flatCollect: [:arg | arg variablesWithId])
]
