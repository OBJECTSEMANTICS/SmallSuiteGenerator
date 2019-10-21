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
	^ idStudent
]

{ #category : #initialization }
SStudent >> initialize [
	id := 1.
	scoreStudent := 1.
	idStudent := id
]

{ #category : #accessing }
SStudent >> nickname [
	^ 'student_' , (nickname ifNil: ['1'])
]

{ #category : #accessing }
SStudent >> scoreStudent [

	^ scoreStudent
]

{ #category : #accessing }
SStudent >> scoreStudent: aNumber [
	
	scoreStudent := aNumber
]
