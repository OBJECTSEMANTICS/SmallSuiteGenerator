"
SSTypeCollectorMethod is a subclass of profiler method that collects method types.

Instance Variables
	argTypes:			<Collection>
	executed:			<False>
	receiverType:	<SMultiTypeInfo>
	returnType:		<SMultiTypeInfo>
"
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
	classNames := args collect: [ :arg | self typeName: arg class ].
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

{ #category : #testing }
SSTypeCollectorMethod >> isValidReturnTypeWithReceiver [
	^ self receiverType types = self returnType types
	
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
	returnType type: (self typeName: value class).
	self checkIfArgIsScalar: value
]

{ #category : #hooks }
SSTypeCollectorMethod >> saveReceiver: anObject [
	receiverType
		type:
			(anObject isClass
				ifTrue: [ self typeName: anObject ]
				ifFalse: [ self typeName: anObject class ])
]

{ #category : #'as yet unclassified' }
SSTypeCollectorMethod >> typeName: anObject [
	^ SSTypeCollector typeNameOf: anObject
]

{ #category : #hooks }
SSTypeCollectorMethod >> wasExecuted [
	^ executed.
]
