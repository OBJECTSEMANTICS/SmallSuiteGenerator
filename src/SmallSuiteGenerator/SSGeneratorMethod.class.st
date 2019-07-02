Class {
	#name : #SSGeneratorMethod,
	#superclass : #S2Method,
	#instVars : [
		'returnType',
		'argTypes'
	],
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #accessing }
SSGeneratorMethod >> argTypes [
	^ argTypes
]

{ #category : #converting }
SSGeneratorMethod >> asTypeInfo [
	^ STypeMethodInfo newFrom: self
]

{ #category : #hooks }
SSGeneratorMethod >> beforeRun: methodName with: listOfArguments in: receiver [
	argTypes := argTypes
		ifNil: [ listOfArguments collect: #class ]
		ifNotNil: [ self mergeTypes: listOfArguments ].
	listOfArguments
		do: [ :arg | self checkIfArgIsScalar: arg ]
]

{ #category : #hooks }
SSGeneratorMethod >> checkIfArgIsScalar: arg [
	(self profiler isScalar: arg)
		ifTrue: [ self profiler addScalar: arg ]
]

{ #category : #hooks }
SSGeneratorMethod >> initialize [
	super initialize.

]

{ #category : #hooks }
SSGeneratorMethod >> isFactory [
	"so its class is meta and it is returning an object of this class"
	returnType ifNil: [ ^ false ].
	^ returnType name == self classSpy nonMetaClassName
]

{ #category : #hooks }
SSGeneratorMethod >> mergeTypes: listOfArguments [
	1 to: argTypes size do: [ :index | 
		| a b |
		a := argTypes at: index.
		b := listOfArguments at: index.
		argTypes at: index put: (a commonSuperclassWith: b class) ].
	^ argTypes
]

{ #category : #accessing }
SSGeneratorMethod >> returnType [
	^ returnType
]

{ #category : #hooks }
SSGeneratorMethod >> returnValue: value [
	returnType := returnType
		ifNil: [ value class ]
		ifNotNil: [ returnType commonSuperclassWith: value class ].
	self checkIfArgIsScalar: value
]
