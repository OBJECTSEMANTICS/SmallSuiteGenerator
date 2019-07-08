Class {
	#name : #STypeMethodInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'selector',
		'returnType',
		'argTypes',
		'isQuick'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'accessing structure variables' }
STypeMethodInfo class >> type: aAssoc [
	| aValue|
	aValue := aAssoc value.
	^ self new 
	selector: aAssoc key;
	returnType: aValue first;
	argTypes: aValue second;
	isQuick: aValue third
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
	copy := STypeMethodInfo new.
	copy
		selector: selector;
		returnType: returnType;
		isQuick: isQuick;
		argTypes: argTypes copy.
	^ copy
]

{ #category : #initialization }
STypeMethodInfo >> initialize [
	argTypes := #().
	isQuick := false
]

{ #category : #accessing }
STypeMethodInfo >> isQuick [
	^ isQuick
]

{ #category : #accessing }
STypeMethodInfo >> isQuick: aBoolean [
	isQuick := aBoolean
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
