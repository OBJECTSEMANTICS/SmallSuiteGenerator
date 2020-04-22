"
SAbstractClass is a proof abstract class created to test project functionality
"
Class {
	#name : #SAbstractClass,
	#superclass : #SObject,
	#instVars : [
		'id'
	],
	#category : #'SmallSuiteGenerator-Scenario2'
}

{ #category : #accessing }
SAbstractClass >> id [
	^ id
]

{ #category : #accessing }
SAbstractClass >> id: anObject [
	id := anObject
]

{ #category : #accessing }
SAbstractClass >> identifier [
	^ self subclassResponsibility
]

{ #category : #initialization }
SAbstractClass >> initialize [ 
	id := 1
]
