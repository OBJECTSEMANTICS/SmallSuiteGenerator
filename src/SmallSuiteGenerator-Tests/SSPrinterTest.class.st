Class {
	#name : #SSPrinterTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SSPrinterTest >> testDictionaryBasedPrinting [
	|test result|
	test := SSTestCase new.
	test addStatements:
			(self parse:
					'_var0 := 1.
					 _var1 := 1.
					 _var2 := Point x: _var0 y: _var1.
					 _var3 := Point x: _var1 y: _var0.
					 _var4 := _var2 x.
					 _var5 := _var2 equals: _var3.').
	result := String streamContents: [ :stream | 
		test accept:(SSDictionaryBasedPrinter on: stream).
	].
	self assert: result equals: 'var at: 1 put: (1 ).
var at: 2 put: (1 ).
var at: 3 put: (Point x: ( var at: 1 ) y: ( var at: 2 )  ).
var at: 4 put: (Point x: ( var at: 2 ) y: ( var at: 1 )  ).
var at: 5 put: (( var at: 3 ) x ).
var at: 6 put: (( var at: 3 ) equals: ( var at: 4 )  ).
'
	
]

{ #category : #tests }
SSPrinterTest >> testStandardPrinting [
	|test result|
	test := SSTestCase new.
	test
		addStatements:
			(self parse:
					'_var0 := 1.
					 _var1 := 1.
					 _var2 := Point x: _var0 y: _var1.
					 _var3 := Point x: _var1 y: _var0.
					 _var4 := _var2 x.
					 _var5 := _var2 equals: _var3.').
	result := String streamContents: [ :stream | 
		test accept:(SSStandardPrinter on: stream).
	].
	self assert: result equals: '_var0 := 1.
_var1 := 1.
_var2 := Point x: _var0 y: _var1 .
_var3 := Point x: _var1 y: _var0 .
_var4 := _var2 x.
_var5 := _var2 equals: _var3 .
'
	
]
