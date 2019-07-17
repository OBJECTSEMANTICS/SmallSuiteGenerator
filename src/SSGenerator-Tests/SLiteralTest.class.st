Class {
	#name : #SLiteralTest,
	#superclass : #TestCase,
	#category : #'SSGenerator-Tests-Nodes'
}

{ #category : #tests }
SLiteralTest >> testInsertParameterUsing [
	| testCase literal |
	testCase := SSTestCase with: SSTestCaseTest typeInfoSFoo.
	literal := testCase addLiteral: #SmallInteger.
	self
		assertCollection: (testCase statements collect: #printString)
		hasSameElements: {'_var0 := 5.'}.
	literal insertParameterUsing: testCase.
	self
		assertCollection: (testCase statements collect: #printString)
		includesAll: {'_var0 := 5.' . '_var1 := 5.'}
]
