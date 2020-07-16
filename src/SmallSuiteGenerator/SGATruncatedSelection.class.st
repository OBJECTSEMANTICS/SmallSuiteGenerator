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

{ #category : #accessing }
SGATruncatedSelection >> discarding: aNumber [
	discarding := aNumber
]

{ #category : #initialization }
SGATruncatedSelection >> initialize [ 
	super initialize.
	discarding := 5
]

{ #category : #selection }
SGATruncatedSelection >> selectJustOneOf: aCollection with: probabilities [

	^ (self selectOf: aCollection) first
]

{ #category : #selection }
SGATruncatedSelection >> selectOf: aCollection [
	| newColl |
	newColl := (aCollection sort: [ :a :b | (self fitnessFor: a) > (self fitnessFor: b) ]).
	(discarding < aCollection size)
		ifTrue: [ newColl := newColl copyFrom: 1 to: (aCollection size - discarding) ].
	^ newColl
]
