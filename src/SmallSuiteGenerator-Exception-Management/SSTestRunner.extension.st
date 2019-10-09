Extension { #name : #SSTestRunner }

{ #category : #'*SmallSuiteGenerator-Exception-Management' }
SSTestRunner >> performTest [
	| _var0 _var1 _var2 _var3 |
_var0 := 1.
_var1 := 1.
_var2 := Point x: _var0 y: _var1.
_var3 := Point x: _var1 y: _var0.
self assert: _var0 equals: _var1.
self assert: _var2 equals: _var3
]
