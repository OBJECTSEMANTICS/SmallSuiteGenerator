"
SSPerson is a proof class created to test project functionality
"
Class {
	#name : #SSPerson,
	#superclass : #SObject,
	#instVars : [
		'name',
		'id',
		'nickname'
	],
	#category : #'SmallSuiteGenerator-Scenario'
}

{ #category : #'instance creation' }
SSPerson class >> name: aString [ 
	| inst |
	inst := self new
		name: aString;
		id: 1;
		nickname: aString.
	^ inst
]

{ #category : #'instance creation' }
SSPerson class >> name: aString with: aNumber [
	| inst |
	inst := self new name: aString; id: aNumber; nickname: aString.
	^ inst
]

{ #category : #accessing }
SSPerson >> age: aNumber [
	^ aNumber
]

{ #category : #testing }
SSPerson >> canRegister: aConference [
	^ aConference price - aConference offerPrice
		> (aConference price * 0.05)
]

{ #category : #accessing }
SSPerson >> fullIdentifier [
	^ name , '_' , nickname , '_' , id printString
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
	^ name , id printString
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
	self subclassResponsibility 
]

{ #category : #accessing }
SSPerson >> nickname: anObject [
	nickname := anObject
]
