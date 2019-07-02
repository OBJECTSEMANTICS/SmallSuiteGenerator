Class {
	#name : #STypeMethodInfo,
	#superclass : #Object,
	#instVars : [
		'selector',
		'returnType',
		'argTypes',
		'typeInfo',
		'isClassMethod'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'instance creation' }
STypeMethodInfo class >> newFrom: aMethod [
	| block |
	block := [ :aBlock :excBlock | 
	aBlock
		on: MessageNotUnderstood
		do: excBlock ].
	^ self new
		selector: aMethod selector;
		returnType:
			(block
				valueWithArguments:
					{[ aMethod returnType name ].
					[ nil ]});
		argTypes:
			(block
				valueWithArguments:
					{[ aMethod argTypes collect: #name ].
					[ #() ]});
			isClassMethod: aMethod isFactory
]

{ #category : #accessing }
STypeMethodInfo >> argTypes [
	^ argTypes
]

{ #category : #accessing }
STypeMethodInfo >> argTypes: anObject [
	argTypes := anObject
]

{ #category : #initialization }
STypeMethodInfo >> initialize [
	argTypes := #().
	isClassMethod := false
]

{ #category : #accessing }
STypeMethodInfo >> isClassMethod [
	^ isClassMethod 
]

{ #category : #accessing }
STypeMethodInfo >> isClassMethod: aBoolean [
	isClassMethod := aBoolean
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

{ #category : #accessing }
STypeMethodInfo >> typeInfo [
	^ typeInfo
]

{ #category : #accessing }
STypeMethodInfo >> typeInfo: anObject [
	typeInfo := anObject
]
