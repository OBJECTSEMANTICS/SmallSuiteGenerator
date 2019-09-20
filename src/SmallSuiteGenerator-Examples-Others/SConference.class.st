Class {
	#name : #SConference,
	#superclass : #SEvent,
	#instVars : [
		'date',
		'speaker',
		'offerPrice'
	],
	#category : #'SmallSuiteGenerator-Examples-Others'
}

{ #category : #accessing }
SConference >> date [
	^ date
]

{ #category : #accessing }
SConference >> date: anObject [
	date := anObject
]

{ #category : #initialization }
SConference >> initialize [
	price := 100.
	discount := 0.
	offerPrice := price.
	date := Date today
]

{ #category : #accessing }
SConference >> offerPrice [
	^ offerPrice
]

{ #category : #accessing }
SConference >> offerPrice: aNumber [
	offerPrice := aNumber
]

{ #category : #accessing }
SConference >> speaker [
	^ speaker
]

{ #category : #accessing }
SConference >> speaker: anObject [
	speaker := anObject
]