"
SParty is a proof class created to test project functionality

Instance Variables
	date:		<Object>
"
Class {
	#name : #SParty,
	#superclass : #SEvent,
	#instVars : [
		'date'
	],
	#category : #'SmallSuiteGenerator-Scenario'
}

{ #category : #accessing }
SParty >> date [
	^ date
]

{ #category : #accessing }
SParty >> date: anObject [
	date := anObject
]
