Class {
	#name : #SConstructorStatement,
	#superclass : #SAbstractStatementWithArgs,
	#instVars : [
		'theClassName'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SConstructorStatement >> changeUsing: aTestCase [
	| classSpy method methods newArgs |
	newArgs := nil.
	classSpy := aTestCase profile classAt: self theClassName.
	methods := classSpy factoryMethods shuffle.
	method := self alternativeMethodIn: methods.
	method ifNil: [ ^ self statementsToChange: methods using: aTestCase ].
	newArgs := self newArgsOf: aTestCase using: method.
	(aTestCase statementAt: self varName)
		args: newArgs;
		selector: method selector.
	^ newArgs
]

{ #category : #private }
SConstructorStatement >> createNewStatement [
	^ super createNewStatement
		theClassName: self theClassName;
		yourself
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> dependenciesConsidering: varNames [
	^ args select: [ :arg | varNames includes: arg ]
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> insertMethodCallUsing: aTestcase [
	^ nil
]

{ #category : #accessing }
SConstructorStatement >> insertRandomCallUsing: aTestCase [
	^ aTestCase insert: self statementWithArgsBefore: nil	"1"
]

{ #category : #accessing }
SConstructorStatement >> isConstructor [
	^ true.
]

{ #category : #printing }
SConstructorStatement >> name [ 
	^ self theClassName
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> newArgsOf: aTestCase using: method [
	^ method argTypes
		collect: [ :class | 
			aTestCase
				createArg: class name
				before: (aTestCase indexOf: self varName)
				avoiding: nil ]
]

{ #category : #mutation }
SConstructorStatement >> repairOn: aTestCase deleting: aStatement [
	(args includes: aStatement varName)
		ifTrue: [ | collection |
			collection := SAuxiliar
				removeOrRepair: args
				argsOf: aStatement
				statementWith: self varName
				varNameUsing: aTestCase.
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

{ #category : #'as yet unclassified' }
SConstructorStatement >> statementsToChange: methods using: aTestCase [
	| result |
	methods ifEmpty: [ ^ #() ].
	result := SAuxiliar
		change: args
		argsOf: methods first argTypes
		typesUsing: aTestCase.
	(aTestCase statementAt: self varName) args: result first.
	^ result second
]

{ #category : #accessing }
SConstructorStatement >> theClassName [
	^ theClassName
]

{ #category : #accessing }
SConstructorStatement >> theClassName: anObject [
	theClassName := anObject
]
