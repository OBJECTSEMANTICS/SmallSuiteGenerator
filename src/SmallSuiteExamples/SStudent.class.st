Class {
	#name : #SStudent,
	#superclass : #Object,
	#instVars : [
		'score'
	],
	#category : #SmallSuiteExamples
}

{ #category : #accessing }
SStudent class >> score: aNumber [
	|ins|
	ins := self new.
	^ ins.
]

{ #category : #'initailize-release' }
SStudent >> initialize [
	super initialize.
	score:=0.
]

{ #category : #accessing }
SStudent >> return: aType [
	^ aType.
]

{ #category : #handling }
SStudent >> returnCollection [
	| a |
	a := OrderedCollection new.
	^ a
]

{ #category : #handling }
SStudent >> returnFloat [
	| a |
	a := 2.3.
	^ a
]

{ #category : #handling }
SStudent >> returnNum [ 
	| a |
	a := 4.
	^ a
]

{ #category : #handling }
SStudent >> returnString [
	| a |
	a := 'Hello'.
	^ a
]

{ #category : #accessing }
SStudent >> score [
	^ score
]
