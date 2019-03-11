Class {
	#name : #SStudent,
	#superclass : #Object,
	#instVars : [
		'score'
	],
	#category : #SmallSuiteGeneratorTest
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

{ #category : #accessing }
SStudent >> score [
	^ score
]
