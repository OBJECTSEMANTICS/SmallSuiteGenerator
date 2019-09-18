Class {
	#name : #STypeMethodInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'selector',
		'returnType',
		'argTypes',
		'isQuick',
		'isDeprecated',
		'receiver'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'accessing structure variables' }
STypeMethodInfo class >> type: aAssoc [
	| aValue |
	aValue := aAssoc value.
	^ self new
		selector: aAssoc key;
		receiver: (SMultiTypeInfo new: aValue first);
		returnType: (SMultiTypeInfo new: aValue second);
		argTypes: (aValue third collect: [ :aType | SMultiTypeInfo new: aType ]);
		isQuick: aValue fourth";
		isDeprecated: aValue fifth"
]

{ #category : #adding }
STypeMethodInfo >> addType: aType [
	argTypes do: [ :arg | arg type: aType ].
	returnType type: aType
]

{ #category : #'as yet unclassified' }
STypeMethodInfo >> allArgTypes [
	argTypes ifNil: [ ^ #() ].
	^ argTypes flatCollect: [ :arg | arg types ]
]

{ #category : #'as yet unclassified' }
STypeMethodInfo >> allReceivers [
	^ receiver types
]

{ #category : #accessing }
STypeMethodInfo >> argTypes [
	^ argTypes
]

{ #category : #accessing }
STypeMethodInfo >> argTypes: anObject [
	argTypes := anObject
]

{ #category : #copying }
STypeMethodInfo >> copy [
	| copy |
	copy := self class instance.
	copy
		selector: selector;
		
		isQuick: isQuick;
		isDeprecated: isDeprecated;
		returnType: returnType copy;
		argTypes: argTypes copy;
		receiver: receiver copy.
	^ copy
]

{ #category : #initialization }
STypeMethodInfo >> initialize [
	argTypes := #().
	isQuick := false.
	returnType := SMultiTypeInfo new.
	receiver := SMultiTypeInfo new.
	isDeprecated := false
]

{ #category : #accessing }
STypeMethodInfo >> isDeprecated [
	^ isDeprecated
]

{ #category : #accessing }
STypeMethodInfo >> isDeprecated: anObject [
	isDeprecated := anObject
]

{ #category : #testing }
STypeMethodInfo >> isFromReceiver: aClassName [
	^ receiver types includes: aClassName
]

{ #category : #accessing }
STypeMethodInfo >> isQuick [
	^ isQuick
]

{ #category : #accessing }
STypeMethodInfo >> isQuick: aBoolean [
	isQuick := aBoolean
]

{ #category : #testing }
STypeMethodInfo >> isWithReturnType: aClassName [
	^ returnType types includes: aClassName
]

{ #category : #'as yet unclassified' }
STypeMethodInfo >> joinWith: otherTypeMethod [
	argTypes ifNotNil: [argTypes
		with: otherTypeMethod argTypes
		do: [ :argType :otherArgType | argType joinWith: otherArgType ].  ].
	
	returnType joinWith: otherTypeMethod returnType
]

{ #category : #accessing }
STypeMethodInfo >> receiver [
	^ receiver
]

{ #category : #accessing }
STypeMethodInfo >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
STypeMethodInfo >> returnType [
	^ returnType
]

{ #category : #accessing }
STypeMethodInfo >> returnType: anObject [
	returnType := anObject
]

{ #category : #accessing }
STypeMethodInfo >> selector [
	^ selector
]

{ #category : #accessing }
STypeMethodInfo >> selector: anObject [
	selector := anObject
]
