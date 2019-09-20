Class {
	#name : #SStack,
	#superclass : #LinkedList,
	#instVars : [
		'firstLinkStack',
		'lastLinkStack'
	],
	#category : #'SmallSuiteGenerator-Examples'
}

{ #category : #'instance creation' }
SStack class >> newStack [
	^ self new
]

{ #category : #'instance creation' }
SStack class >> newStackWith: aList [
	| inst |
	inst := self new.
	aList
		do: [ :element | 
			inst push: element ].
	^ inst
]

{ #category : #accessing }
SStack >> firstLinkStack [

	^ firstLink
]

{ #category : #accessing }
SStack >> lastLinkStack [
	^ lastLink
]

{ #category : #removing }
SStack >> pop [
	self isEmpty
		ifTrue: [ ^ nil ]
		ifFalse: [ ^ self removeFirst ]
]

{ #category : #adding }
SStack >> push: aObject [
	| aLink |
	aLink := aObject asLink.
	self isEmpty
		ifTrue: [
			lastLink := aLink ].
	aLink nextLink: firstLink.
	firstLink := aLink.
	^ aObject
]

{ #category : #accessing }
SStack >> top [
	self isEmpty
		ifTrue: [ 
			^ nil ]
		ifFalse: [ 
			^ self firstLink value ]
]
