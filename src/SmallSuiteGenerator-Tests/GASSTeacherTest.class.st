Class {
	#name : #GASSTeacherTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGenerator-Tests-Generated'
}

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test1 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var3 _var1 _var2 |
_var3 := SSTeacher new.
_var1 := _var3 nickname.
_var2 := _var3 yearsWorkExperience.
self assert: _var3 idTeacher equals: 100.
self assert: _var3 yearsWorkExperience equals: 0.
self assert: _var1 equals: 'teacher_1'.
self assert: _var2 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test10 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSPerson:7.143%
SSTeacher:75.0%
"
| _var0 _var1 _var3 _var2 |
_var0 := SSTeacher new.
_var1 := _var0 nickname.
_var3 := _var0 name: _var1.
_var2 := _var3 yearsWorkExperience.
self assert: _var0 idTeacher equals: 100.
self assert: _var0 yearsWorkExperience equals: 0.
self assert: _var3 idTeacher equals: 100.
self assert: _var3 yearsWorkExperience equals: 0.
self assert: _var1 equals: 'teacher_1'.
self assert: _var2 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test2 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var1 _var0 _var2 |
_var1 := SSTeacher new.
_var0 := _var1 nickname.
_var2 := _var1 yearsWorkExperience.
self assert: _var1 idTeacher equals: 100.
self assert: _var1 yearsWorkExperience equals: 0.
self assert: _var0 equals: 'teacher_1'.
self assert: _var2 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test3 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var3 _var1 _var2 |
_var3 := SSTeacher new.
_var1 := _var3 nickname.
_var2 := _var3 yearsWorkExperience.
self assert: _var3 idTeacher equals: 100.
self assert: _var3 yearsWorkExperience equals: 0.
self assert: _var1 equals: 'teacher_1'.
self assert: _var2 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test4 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var3 _var0 _var1 |
_var3 := SSTeacher new.
_var0 := _var3 nickname.
_var1 := _var3 yearsWorkExperience.
self assert: _var3 idTeacher equals: 100.
self assert: _var3 yearsWorkExperience equals: 0.
self assert: _var0 equals: 'teacher_1'.
self assert: _var1 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test5 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var3 _var1 _var2 |
_var3 := SSTeacher new.
_var1 := _var3 nickname.
_var2 := _var3 yearsWorkExperience.
self assert: _var3 idTeacher equals: 100.
self assert: _var3 yearsWorkExperience equals: 0.
self assert: _var1 equals: 'teacher_1'.
self assert: _var2 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test6 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var3 _var1 _var2 |
_var3 := SSTeacher new.
_var1 := _var3 nickname.
_var2 := _var3 yearsWorkExperience.
self assert: _var3 idTeacher equals: 100.
self assert: _var3 yearsWorkExperience equals: 0.
self assert: _var1 equals: 'teacher_1'.
self assert: _var2 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test7 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var3 _var1 _var2 |
_var3 := SSTeacher new.
_var1 := _var3 nickname.
_var2 := _var3 yearsWorkExperience.
self assert: _var3 idTeacher equals: 100.
self assert: _var3 yearsWorkExperience equals: 0.
self assert: _var1 equals: 'teacher_1'.
self assert: _var2 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test8 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var3 _var1 _var2 |
_var3 := SSTeacher new.
_var1 := _var3 nickname.
_var2 := _var3 yearsWorkExperience.
self assert: _var3 idTeacher equals: 100.
self assert: _var3 yearsWorkExperience equals: 0.
self assert: _var1 equals: 'teacher_1'.
self assert: _var2 equals: 0
]

{ #category : #'as yet unclassified' }
GASSTeacherTest >> test9 [
"Fitness: 
block-coverage: 75.0
"
"This test covers: 
block-coverage
SSTeacher:75.0%
"
| _var0 _var5 _var1 _var2 |
_var0 := SSTeacher new.
_var5 := 'Ann'.
_var1 := _var0 nickname.
_var2 := _var0 yearsWorkExperience.
self deny: _var5 equals: _var1.
self assert: _var0 idTeacher equals: 100.
self assert: _var0 yearsWorkExperience equals: 0.
self assert: _var5 equals: 'Ann'.
self assert: _var1 equals: 'teacher_1'.
self assert: _var2 equals: 0
]
