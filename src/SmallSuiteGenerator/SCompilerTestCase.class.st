Class {
	#name : #SCompilerTestCase,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SCompilerTestCase >> compileTestCase [
| _var0 _var1 _var10 _var2 _var3 _var4 _var6 _var7 _var8 _var9 |
_var0 := SEvent new.
_var1 := SSTeacher new.
_var10 := 45.
_var2 := SStudent new.
_var3 := _var2 initialize.
_var4 := SStudent new.
_var6 := _var2 scoreStudent: _var10.
_var7 := _var2 idStudent.
_var8 := _var2 scoreStudent.
_var9 := _var2 nickname
]
