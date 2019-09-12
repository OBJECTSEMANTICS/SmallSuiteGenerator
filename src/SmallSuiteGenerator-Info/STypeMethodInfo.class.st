Class {
	#name : #STypeMethodInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'selector',
		'returnType',
		'argTypes',
		'isQuick',
		'isDeprecated'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'accessing structure variables' }
STypeMethodInfo class >> type: aAssoc [
	| aValue |
	aValue := aAssoc value.
	^ self new
		selector: aAssoc key;
		returnType: (SMultiTypeInfo new: aValue first);
		argTypes: (aValue second collect: [:aType | SMultiTypeInfo new: aType]);
		isQuick: aValue third
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
		returnType: returnType copy;
		isQuick: isQuick;
		argTypes: argTypes copy.
	^ copy
]

{ #category : #initialization }
STypeMethodInfo >> initialize [
	argTypes := #().
	isQuick := false.
	returnType := SMultiTypeInfo new.
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

{ #category : #accessing }
STypeMethodInfo >> isQuick [
	^ isQuick
]

{ #category : #accessing }
STypeMethodInfo >> isQuick: aBoolean [
	isQuick := aBoolean
]

{ #category : #'as yet unclassified' }
STypeMethodInfo >> joinWith: otherTypeMethod [
	argTypes ifNotNil: [argTypes
		with: otherTypeMethod argTypes
		do: [ :argType :otherArgType | argType joinWith: otherArgType ].  ].
	
	returnType joinWith: otherTypeMethod returnType
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
