Class {
	#name : #SSPerson,
	#superclass : #Object,
	#instVars : [
		'name',
		'id',
		'nickname'
	],
	#category : #SmallSuiteExamples
}

{ #category : #'as yet unclassified' }
SSPerson class >> name: aString [ 
	| inst |
	inst := self new
		name: aString;
		id: 1;
		nickname: aString.
	^ inst
]

{ #category : #'as yet unclassified' }
SSPerson class >> name: aString with: aNumber [
	| inst |
	inst := self new name: aString; id: aNumber; nickname: aString.
	^ inst
]

{ #category : #accessing }
SSPerson >> age: aNumber [
	^ aNumber
]

{ #category : #'as yet unclassified' }
SSPerson >> fullIdentifier [
	^ name, '_', nickname, '_', id asString
]

{ #category : #accessing }
SSPerson >> id [
	^ id
]

{ #category : #accessing }
SSPerson >> id: anObject [
	id := anObject
]

{ #category : #accessing }
SSPerson >> identifier [ 	
	^ name, id asString
]

{ #category : #accessing }
SSPerson >> name [
	^ name
]

{ #category : #accessing }
SSPerson >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SSPerson >> nickname [
	^ nickname
]

{ #category : #accessing }
SSPerson >> nickname: anObject [
	nickname := anObject
]