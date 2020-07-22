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
	#category : #'SmallSuiteGenerator-Core'
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

{ #category : #creation }
SAbstractMessage class >> receiver: receiver selector: aSelector args: aArgCollection [
	^ self new
			selector: aSelector;
			receiver: receiver;
			args: aArgCollection;
			yourself.
]

{ #category : #comparing }
SAbstractMessage >> = other [
	^ super = other 
		and: [ args = other args 
			and: [ receiver = other receiver 
				and: [ (selector = other selector) ] ] ]
]

{ #category : #visitor }
SAbstractMessage >> accept: aSSVisitor [
	^ aSSVisitor visitAbstractMessage: self.
]

{ #category : #accessing }
SAbstractMessage >> args [
	^ args
]

{ #category : #accessing }
SAbstractMessage >> args: anObject [
	args := anObject
]

{ #category : #actions }
SAbstractMessage >> changeOn: aTestCase [
	"nothing to change"
	|val|
	val := self random next.
	val <=0.3 
		ifTrue:[	
			aTestCase addAlternativeReceiverFor: self. 
		] ifFalse:[
			val <= 0.6 
				ifTrue:[
					aTestCase addAlternativeSelectorFor: self. 
				] ifFalse:[
					aTestCase addAlternativeArgsFor: self. 
				]
			]
		
	"
	#(#addAlternativeReceiverFor: #addAlternativeSelectorFor: #addAlternativeArgsFor:) 
		safelyPickAny: [ :aSelector | 
			[ ^ aTestCase
				perform: aSelector
				with: self]
		] ifNone:[self serror: 'Cannot change the statement ' , self printString]."
	
]

{ #category : #querying }
SAbstractMessage >> containsVariable: aVariable [
	^ (self receiver containsVariable: aVariable) or:[ self args anySatisfy: [:arg| arg containsVariable: aVariable]].
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

{ #category : #querying }
SAbstractMessage >> isThereEnoughArgumentsToBuild: aTestCase [
	^ self variablesWithId allSatisfy: [ :var | (aTestCase containsVariable: var) or: (aTestCase containsVariableWithReturnType: var returnType)].
]

{ #category : #querying }
SAbstractMessage >> pickUpReferences: aExpression [
	^ (receiver pickUpReferences: aExpression)
		, (args flatCollect: [ :arg | arg pickUpReferences: aExpression ])
]

{ #category : #accessing }
SAbstractMessage >> receiver [
	^ receiver
]

{ #category : #accessing }
SAbstractMessage >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
SAbstractMessage >> selector [
	^ selector
]

{ #category : #accessing }
SAbstractMessage >> selector: anObject [
	selector := anObject
]

{ #category : #querying }
SAbstractMessage >> variablesWithId [
	^ receiver variablesWithId , (args flatCollect: [:arg | arg variablesWithId])
]
