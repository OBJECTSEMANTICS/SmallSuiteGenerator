Extension { #name : #SSTestRunner }

{ #category : #'*SmallSuiteGenerator-Exception-Management' }
SSTestRunner >> performTest [
	| _var0 _var1 _var3 |
_var0 := 1.
_var1 := 2.
_var3 := Point x: _var1 y: _var0.
^ self analyze: thisContext
]
