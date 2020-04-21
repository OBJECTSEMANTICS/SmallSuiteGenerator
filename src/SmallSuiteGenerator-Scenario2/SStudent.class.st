"
SStudent is a proof class created to test project functionality
"
Class {
	#name : #SStudent,
	#superclass : #SSPerson,
	#instVars : [
		'scoreStudent',
		'idStudent'
	],
	#category : #'SmallSuiteGenerator-Scenario2'
}

{ #category : #accessing }
SStudent >> idStudent [
  #metaObject count: 1.
  nil.
  ^idStudent
]

{ #category : #initialization }
SStudent >> initialize [
  #metaObject count: 1.
  nil.
  id := 1.
  scoreStudent := 1.
  idStudent := id
]

{ #category : #accessing }
SStudent >> nickname [
  #metaObject count: 1.
  nil.
  ^'student_' , (nickname ifNil: [ #metaObject count: 2.
              nil.
              '1' ])
]

{ #category : #accessing }
SStudent >> scoreStudent [
  #metaObject count: 1.
  nil.
  ^scoreStudent
]

{ #category : #accessing }
SStudent >> scoreStudent: aNumber [
  #metaObject count: 1.
  nil.
  scoreStudent := aNumber
]
