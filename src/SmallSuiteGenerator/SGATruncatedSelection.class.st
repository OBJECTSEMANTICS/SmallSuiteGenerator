"
SGATrouncateSelection is responsible for select testCases, this type of selection descart the worst N testCases (less fitness) and then select randomly testCases
"
Class {
	#name : #SGATruncatedSelection,
	#superclass : #SGASelection,
	#instVars : [
		'discarding'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SGATruncatedSelection >> discarding: aNumber [
	discarding := aNumber
]

{ #category : #initialization }
SGATruncatedSelection >> initialize [ 
	discarding := 5
]

{ #category : #actions }
SGATruncatedSelection >> selectOf: aCollection [
	| newColl |
	newColl := (aCollection sort: [ :a :b |(a fitness at: fitness functionName)> (b fitness at: fitness functionName) ]).
	(discarding < aCollection size)
		ifTrue: [
			newColl := newColl copyFrom: 1 to: (aCollection size - discarding)
		].
	^ newColl
]
