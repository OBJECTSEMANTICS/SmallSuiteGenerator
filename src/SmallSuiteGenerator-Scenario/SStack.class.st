"
SStack is a proof class created to test project functionality
"
Class {
	#name : #SStack,
	#superclass : #LinkedList,
	#instVars : [
		'firstLinkStack',
		'lastLinkStack'
	],
	#category : #'SmallSuiteGenerator-Scenario'
}

{ #category : #'instance creation' }
SStack class >> newStack [
	^ self new
]

{ #category : #'instance creation' }
SStack class >> newStackWith: aList [
	| inst |
	inst := self newStack.
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
SStack >> push: anObject [
	self addFirst: anObject.
	^ anObject
]

{ #category : #accessing }
SStack >> top [
	self isEmpty
		ifTrue: [ 
			^ nil ]
		ifFalse: [ 
			^ self firstLink value ]
]
