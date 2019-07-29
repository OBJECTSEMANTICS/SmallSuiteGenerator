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
	^ STypeMethodInfo new
		selector: selector;
		returnType: self returnType;
		argTypes: self argTypes;
		isQuick: self isQuick
]

{ #category : #hooks }
SSGeneratorMethod >> beforeRun: methodName with: listOfArguments in: receiver [
	self initArgsTypesWith: listOfArguments.
	listOfArguments do: [ :arg | self checkIfArgIsScalar: arg ]
]

{ #category : #hooks }
SSGeneratorMethod >> checkIfArgIsScalar: arg [
	
	(self profiler isScalar: arg)
		ifTrue: [ self profiler addScalar: arg ]
]

{ #category : #hooks }
SSGeneratorMethod >> initArgsTypesWith: args [
	| classNames |
	classNames := args collect: [ :arg | arg class name ].
	argTypes ifNil: [ 
		classNames ifNotEmpty: [argTypes := classNames collect: [ :aName | STypeReturnInfo new: aName ]]
		 ] ifNotNil: [ self mergeTypes: classNames ].
]

{ #category : #hooks }
SSGeneratorMethod >> initialize [
	super initialize.
	returnType := STypeReturnInfo new.
	"argTypes := OrderedCollection new"
]

{ #category : #hooks }
SSGeneratorMethod >> isFactory [
	"so its class is meta and it is returning an object of this class"

	returnType type ifNil: [ ^ false ].
	^ returnType type name == self classSpy nonMetaClassName
]

{ #category : #hooks }
SSGeneratorMethod >> mergeTypes: args [
	argTypes
		with: args
		do: [ :argType :otherArgType | argType type: otherArgType ]
]

{ #category : #accessing }
SSGeneratorMethod >> returnType [
	^ returnType
]

{ #category : #accessing }
SSGeneratorMethod >> returnTypeName [
	"to remove"
	^ returnType ifNotNil: [ returnType name ]	"ifNil: [ nil ]"
]

{ #category : #hooks }
SSGeneratorMethod >> returnValue: value [

	returnType type: value class name.
	self checkIfArgIsScalar: value
]
