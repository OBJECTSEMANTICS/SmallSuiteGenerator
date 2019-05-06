Class {
	#name : #SConstructorStatement,
	#superclass : #SAbstractMethodStatement,
	#instVars : [
		'theClassName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SConstructorStatement >> changeUsing: aTestCase [
	| classSpy method result methods |
	result := nil.
	classSpy := aTestCase profile classAt: self theClassName.
	methods := classSpy factoryMethods shuffle.
	method := self findMethodIn: methods.
	method
		ifNil: [ result := STransformValue
				change: args
				ofTypes: (methods ifEmpty: [ #() ] ifNotEmpty: [ methods first argTypes ])
				using: aTestCase.
			(aTestCase statementAt: self varName) args: result first.
			result := result second ]
		ifNotNil: [ | newArgs |
			newArgs := method argTypes
				collect: [ :class | 
					aTestCase
						createArg: class name
						before: (aTestCase indexOf: self varName)
						avoiding: nil ].
			(aTestCase statementAt: self varName)
				args: newArgs;
				selector: method selector.
			result := newArgs ].
	^ result
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> collectDependencies [
	^ STransformValue selectVarNames: args
]

{ #category : #private }
SConstructorStatement >> createNewStatement [
	^ super createNewStatement
		theClassName: self theClassName;
		yourself
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> findMethodIn: methods [
	^ methods
		detect: [ :aMethod | aMethod selector ~= self selector ]
		ifFound: [ :aMethod | aMethod ]
		ifNone: [  ].
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> insertMethodCallUsing: aTestcase [
	^ nil
]

{ #category : #accessing }
SConstructorStatement >> insertRandomCallUsing: aTestCase [
	^ aTestCase
		insertStatementWithArgs: self
		from: 1
]

{ #category : #accessing }
SConstructorStatement >> isConstructor [
	^ true.
]

{ #category : #printing }
SConstructorStatement >> name [ 
	^ self theClassName
]

{ #category : #mutation }
SConstructorStatement >> repairOn: aTestCase deleting: aStatement [
	(args includes: aStatement varName)
		ifTrue: [ | collection |
			collection := STransformValue
				removeOrRepairArgs: args
				of: aStatement
				with: self varName
				using: aTestCase.
			(aTestCase statementAt: self varName) args: collection first.
			^ collection second ]
		ifFalse: [ ^ #() ]
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> satisfyParameters: aTestCase with: otherTestCase [
	| newConstructor class |
	class := aTestCase profile
		classAt: theClassName
		ifNone: [ otherTestCase profile classAt: theClassName ].
	newConstructor := aTestCase
		newConstructorStatement: theClassName
		of: class factoryMethods
		before: self varName.
	newConstructor ifNotNil: [ ^ aTestCase addStatement: newConstructor ].
	^ false
]

{ #category : #accessing }
SConstructorStatement >> theClassName [
	^ theClassName
]

{ #category : #accessing }
SConstructorStatement >> theClassName: anObject [
	theClassName := anObject
]
