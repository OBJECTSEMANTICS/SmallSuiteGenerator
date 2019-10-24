Class {
	#name : #SSTypeCollectorMethod,
	#superclass : #S2Method,
	#instVars : [
		'returnType',
		'argTypes',
		'receiverType',
		'executed'
	],
	#category : #'SmallSuiteGenerator-Profiler'
}

{ #category : #accessing }
SSTypeCollectorMethod >> argTypes [
	^ argTypes
]

{ #category : #converting }
SSTypeCollectorMethod >> asTypeInfo [
	^ STypeMethodInfo new
		selector: selector;
		receiver: self receiverType;
		returnType: self returnType;
		argTypes: self argTypes;
		isQuick: self isQuick;
		isDeprecated: originalMethod isDeprecated
]

{ #category : #hooks }
SSTypeCollectorMethod >> beforeRun: methodName with: listOfArguments in: receiver [
	self initArgsTypesWith: listOfArguments.
	self saveReceiver: receiver.
	listOfArguments do: [ :arg | self checkIfArgIsScalar: arg ].
	executed := true.
]

{ #category : #hooks }
SSTypeCollectorMethod >> checkIfArgIsScalar: arg [
	
	(self profiler isScalar: arg)
		ifTrue: [ self profiler addScalar: arg ]
]

{ #category : #hooks }
SSTypeCollectorMethod >> initArgsTypesWith: args [
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
SSTypeCollectorMethod >> initialize [
	super initialize.
	returnType := SMultiTypeInfo new.
	receiverType := SMultiTypeInfo new.
	executed := false.
]

{ #category : #hooks }
SSTypeCollectorMethod >> mergeArgsTypes: args [
	argTypes
		with: args
		do: [ :argType :otherArgType | argType type: otherArgType ]
]

{ #category : #accessing }
SSTypeCollectorMethod >> receiverType [
	
	^ receiverType
]

{ #category : #accessing }
SSTypeCollectorMethod >> returnType [
	^ returnType
]

{ #category : #hooks }
SSTypeCollectorMethod >> returnValue: value [

	returnType type: value class name.
	self checkIfArgIsScalar: value
]

{ #category : #hooks }
SSTypeCollectorMethod >> saveReceiver: aObject [
	receiverType
		type: (aObject isClass ifTrue: [aObject name] ifFalse: [aObject class name])
]

{ #category : #'as yet unclassified' }
SSTypeCollectorMethod >> validReturnTypeWithReceiver [
	^ self receiverType types = self returnType types
	
]

{ #category : #hooks }
SSTypeCollectorMethod >> wasExecuted [
	^ executed.
]
