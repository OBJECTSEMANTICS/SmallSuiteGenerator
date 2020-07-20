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
	aVariable id ifNotNil:[ aVariable id: (nameMap at: aVariable id). ].
]
