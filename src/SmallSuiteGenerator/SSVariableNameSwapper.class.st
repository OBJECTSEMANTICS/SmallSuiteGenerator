"
Visit all SSG node in a generated test to fix order of assignments, for instance, given a testCase like this:

'	_var99 := 1.
	_var23 := 1.
	_var2 := Point x: _var99 y: _var23.
	_var33 := Point x: _var23 y: _var99.
	_var4 := _var2 x.
	_var5 := _var2 equals: _var33.
'

is transformed in this:

'	_var0 := 1.
	_var1 := 1.
	_var2 := Point x: _var0 y: _var1 .
	_var3 := Point x: _var1 y: _var0 .
	_var4 := _var2 x.
	_var5 := _var2 equals: _var3 .
'
"
Class {
	#name : #SSVariableNameSwapper,
	#superclass : #SSVisitor,
	#instVars : [
		'nameMap'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'instance creation' }
SSVariableNameSwapper class >> negate: testCase [
	|map|
	
	map := Dictionary new.
	testCase statements do:[ :assign| 
		map at: (assign variable id) put: (assign variable id* (-1)). ].
	testCase accept: (self new nameMap: map).
]

{ #category : #'instance creation' }
SSVariableNameSwapper class >> repairNamesOf: testCase [
	|map|
	
	map := Dictionary new.
	self negate: testCase.
	testCase statements doWithIndex:[ :stm :index |
		map at: (stm variable id) put: (index-1).].
	testCase accept: (self new nameMap: map).
]

{ #category : #intialization }
SSVariableNameSwapper >> initialize [

	super initialize.
	nameMap := Dictionary new.
]

{ #category : #accessing }
SSVariableNameSwapper >> nameMap [

	^ nameMap
]

{ #category : #accessing }
SSVariableNameSwapper >> nameMap: anObject [

	nameMap := anObject
]

{ #category : #accessing }
SSVariableNameSwapper >> visitVariable: aVariable [

	aVariable id ifNotNil: [ aVariable id: (nameMap at: aVariable id) ].
]
