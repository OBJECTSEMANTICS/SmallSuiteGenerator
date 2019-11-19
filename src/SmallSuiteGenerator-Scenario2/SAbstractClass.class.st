Class {
	#name : #SAbstractClass,
	#superclass : #SObject,
	#instVars : [
		'id'
	],
	#category : #'SmallSuiteGenerator-Scenario2'
}

{ #category : #testing }
SAbstractClass class >> isAbstract [
	^ self name = #SAbstractClass
]

{ #category : #accessing }
SAbstractClass >> id [
	^ id
]

{ #category : #accessing }
SAbstractClass >> id: anObject [
	id := anObject
]

{ #category : #initialization }
SAbstractClass >> initialize [ 
	id := 1
]
