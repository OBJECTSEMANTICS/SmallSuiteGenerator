Extension { #name : #SSTestRunner }

{ #category : #'*SmallSuiteGenerator-Exception' }
SSTestRunner >> performTest [
	| _var0 _var1 _var2 _var4 _var5 _var3 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var15 _var16 _var17 _var18 _var19 _var20 _var21 _var22 _var23 _var24 _var25 _var26 _var27 _var28 |
_var0 := SStudent new.
_var1 := _var0 initialize.
_var2 := _var0 scoreStudent.
_var4 := _var0 idStudent.
_var5 := _var0 nickname.
_var3 := SStudent new.
_var6 := 'student_Ann'.
_var7 := _var0 scoreStudent.
_var8 := _var0 idStudent.
_var9 := 'student_Ann'.
_var10 := _var0 idStudent.
_var11 := SStudent new.
_var12 := _var0 idStudent.
_var13 := SStudent new.
_var14 := SStudent new.
_var15 := SStudent new.
_var16 := 'student_Ann'.
_var17 := _var0 scoreStudent: _var12.
_var18 := _var0 initialize.
_var19 := _var0 nickname.
_var20 := _var0 scoreStudent.
_var21 := SStudent new.
_var22 := _var0 scoreStudent.
_var23 := _var0 scoreStudent: _var7.
_var24 := SStudent new.
_var25 := SStudent new.
_var26 := _var0 scoreStudent.
_var27 := 1.
_var28 := SStudent new.
^ self analyze: thisContext
]
