Class {
	#name : #SSVisitorTest,
	#superclass : #SExpressionTest,
	#category : #'SmallSuiteGenerator-Tests-AST'
}

{ #category : #tests }
SSVisitorTest >> testDictionaryBasedPrinting [
	|test result|
	test := SSTestCase new.
	test addStatements:
			(self parse:
					'_var0 := 1.
					 _var1 := 1.
					 _var2 := Point x: _var0 y: _var1.
					 _var3 := Point x: _var1 y: _var0.
					 _var4 := _var2 x.
					 _var5 := _var2 closeTo: _var3.').
	result := String streamContents: [ :stream | 
		test accept:(SSDictionaryBasedPrinter on: stream).
	].
	self assert: result equals: 'var at: 1 put: (1 ).
var at: 2 put: (1 ).
var at: 3 put: (Point x: ( var at: 1 ) y: ( var at: 2 )  ).
var at: 4 put: (Point x: ( var at: 2 ) y: ( var at: 1 )  ).
var at: 5 put: (( var at: 3 ) x ).
var at: 6 put: (( var at: 3 ) closeTo: ( var at: 4 )  ).
'
	
]

{ #category : #tests }
SSVisitorTest >> testRename [
	|test result|
	test := SSTestCase new.
	test
		addStatements:
			(self parse:
					'_var99 := 1.
					 _var23 := 1.
					 _var2 := Point x: _var99 y: _var23.
					 _var33 := Point x: _var23 y: _var99.
					 _var4 := _var2 x.
					 _var5 := _var2 equals: _var33.').
	SSVariableNameSwapper repairNamesOf: test.
	self assert: test printString equals: '_var0 := 1.
_var1 := 1.
_var2 := Point x: _var0 y: _var1 .
_var3 := Point x: _var1 y: _var0 .
_var4 := _var2 x.
_var5 := _var2 equals: _var3 .
'
	
	
]

{ #category : #tests }
SSVisitorTest >> testRunWithoutAsssertions [
	|test result|
	test := SSTestCase new.
	test
		addStatements:
			(self parse:
					'_var0 := 1.
					 _var1 := 0.
					 _var2 := Point x: _var0 y: _var1.
					 _var3 := Point x: _var1 y: _var0.
					 _var4 := _var2 x.
					 _var5 := _var2 closeTo: _var3.').
	result := test runWithoutAssertions.
	self assert: (result at:'_var0') equals: 1.
	self assert: (result at:'_var1') equals: 0.
	self assert: (result at:'_var2') equals: (1@0).
	self assert: (result at:'_var3') equals: (0@1).
	self assert: (result at:'_var4') equals: 1.
	self assert: (result at:'_var5') equals: false.
]

{ #category : #tests }
SSVisitorTest >> testStandardPrinting [
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
