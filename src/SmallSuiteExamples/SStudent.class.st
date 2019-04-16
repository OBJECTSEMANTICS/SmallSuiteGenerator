Class {
	#name : #SStudent,
	#superclass : #SSPerson,
	#instVars : [
		'scoreStudent'
	],
	#category : #SmallSuiteExamples
}

{ #category : #initialization }
SStudent >> initialize [
	id := 1.
	scoreStudent := 1
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
