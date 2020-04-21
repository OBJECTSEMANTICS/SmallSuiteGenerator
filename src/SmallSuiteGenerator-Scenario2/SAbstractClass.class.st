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
  #metaObject count: 1.
  nil.
  ^id
]

{ #category : #accessing }
SAbstractClass >> id: anObject [
  #metaObject count: 1.
  nil.
  id := anObject
]

{ #category : #accessing }
SAbstractClass >> identifier [
  #metaObject count: 1.
  nil.
  ^self subclassResponsibility
]

{ #category : #initialization }
SAbstractClass >> initialize [
  #metaObject count: 1.
  nil.
  id := 1
]
