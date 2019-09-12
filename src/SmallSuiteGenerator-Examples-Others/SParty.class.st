Class {
	#name : #SParty,
	#superclass : #SEvent,
	#instVars : [
		'date'
	],
	#category : #'SmallSuiteGenerator-Examples-Others'
}

{ #category : #accessing }
SParty >> date [
	^ date
]

{ #category : #accessing }
SParty >> date: anObject [
	date := anObject
]
