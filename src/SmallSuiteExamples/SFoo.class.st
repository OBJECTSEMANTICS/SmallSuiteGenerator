Class {
	#name : #SFoo,
	#superclass : #Object,
	#instVars : [
		'score'
	],
	#category : #SmallSuiteExamples
}

{ #category : #accessing }
SFoo class >> score: aNumber [
	| ins |
	ins := self new score: aNumber.
	^ ins
]

{ #category : #'initailize-release' }
SFoo >> initialize [
	score := 0
]

{ #category : #'as yet unclassified' }
SFoo >> person: aPerson [
	^ aPerson
]

{ #category : #accessing }
SFoo >> return: aType [
	^ aType.
]

{ #category : #handling }
SFoo >> returnCollection [
	| a |
	a := OrderedCollection new.
	^ a
]

{ #category : #handling }
SFoo >> returnFloat [
	| a |
	a := 2.3.
	^ a
]

{ #category : #handling }
SFoo >> returnNum [ 
	| a |
	a := 4.
	^ a
]

{ #category : #handling }
SFoo >> returnString [
	| a |
	a := 'Hello'.
	^ a
]

{ #category : #accessing }
SFoo >> score [
	^ score
]

{ #category : #accessing }
SFoo >> score: aNumber [
	score := aNumber
]
