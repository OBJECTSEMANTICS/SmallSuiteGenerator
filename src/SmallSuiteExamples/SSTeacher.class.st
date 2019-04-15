Class {
	#name : #SSTeacher,
	#superclass : #SSPerson,
	#instVars : [
		'yearsWorkExperience',
		'idTeacher'
	],
	#category : #SmallSuiteExamples
}

{ #category : #accessing }
SSTeacher >> idTeacher [
	^ idTeacher
]

{ #category : #initialization }
SSTeacher >> initialize [
	idTeacher := 100 + (id ifNil: [0]).
	yearsWorkExperience := 0
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
