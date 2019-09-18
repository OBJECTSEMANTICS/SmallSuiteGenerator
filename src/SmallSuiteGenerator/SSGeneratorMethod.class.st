Class {
	#name : #SSGeneratorMethod,
	#superclass : #S2Method,
	#instVars : [
		'returnType',
		'argTypes',
		'receiverType'
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
		receiver: self receiverType;
		returnType: self returnType;
		argTypes: self argTypes;
		isQuick: self isQuick;
		isDeprecated: originalMethod isDeprecated
]

{ #category : #hooks }
SSGeneratorMethod >> beforeRun: methodName with: listOfArguments in: receiver [
	self initArgsTypesWith: listOfArguments.
	self saveReceiver: receiver.
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
	"classNames := args
		collect: [ :arg | 
			arg isClass
				ifTrue: [ arg name ]
				ifFalse: [ arg class name ] ]."
	argTypes
		ifNil: [ classNames
				ifNotEmpty: [ argTypes := classNames
						collect: [ :aName | SMultiTypeInfo new: aName ] ] ]
		ifNotNil: [ self mergeArgsTypes: classNames ]
]

{ #category : #hooks }
SSGeneratorMethod >> initialize [
	super initialize.
	returnType := SMultiTypeInfo new.
	receiverType := SMultiTypeInfo new
]

{ #category : #hooks }
SSGeneratorMethod >> mergeArgsTypes: args [
	argTypes
		with: args
		do: [ :argType :otherArgType | argType type: otherArgType ]
]

{ #category : #accessing }
SSGeneratorMethod >> receiverType [
	
	^ receiverType
]

{ #category : #accessing }
SSGeneratorMethod >> returnType [
	^ returnType
]

{ #category : #hooks }
SSGeneratorMethod >> returnValue: value [

	returnType type: value class name.
	self checkIfArgIsScalar: value
]

{ #category : #hooks }
SSGeneratorMethod >> saveReceiver: aObject [
	receiverType
		type: (aObject isClass ifTrue: [aObject name] ifFalse: [aObject class name])
]
