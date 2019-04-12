Class {
	#name : #SStudent,
	#superclass : #SSPerson,
	#instVars : [
		'score'
	],
	#category : #SmallSuiteExamples
}

{ #category : #initialization }
SStudent >> initialize [ 	
	id := 1.
	score := 1.
]

{ #category : #accessing }
SStudent >> nickname [
	^ 'student_' , (nickname ifNil: ['1'])
]

{ #category : #accessing }
SStudent >> score [ 	
	^ score
]

{ #category : #accessing }
SStudent >> score: aNumber [
	score := aNumber
]
