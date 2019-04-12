Class {
	#name : #SSTeacher,
	#superclass : #SSPerson,
	#instVars : [
		'yearsWorkExperience'
	],
	#category : #SmallSuiteExamples
}

{ #category : #initialization }
SSTeacher >> initialize [ 
	id := 100.
	yearsWorkExperience := 0.
]

{ #category : #accessing }
SSTeacher >> nickname [
	^ 'teacher_' , (nickname ifNil: [ '1' ])
]

{ #category : #accessing }
SSTeacher >> yearsWorkExperience [
	^ yearsWorkExperience
]

{ #category : #accessing }
SSTeacher >> yearsWorkExperience: anObject [
	yearsWorkExperience := anObject
]
