Class {
	#name : #SConstructorStatement,
	#superclass : #SStatement,
	#instVars : [
		'theClassName',
		'selector',
		'args'
	],
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #accessing }
SConstructorStatement >> args [
	^ args
]

{ #category : #accessing }
SConstructorStatement >> args: anObject [
	args := anObject
]

{ #category : #private }
SConstructorStatement >> createNewStatement [
	^ self class create 
	args: self args;
	selector: self selector;
	theClassName: self theClassName; yourself
	
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> insertMethodCallUsing: aTestcase [
	^ nil
]

{ #category : #'as yet unclassified' }
SConstructorStatement >> insertParameterUsing: aTestCase [
	^ self insertParametersOf: self using: aTestCase
]

{ #category : #accessing }
SConstructorStatement >> insertRandomCallUsing: aTestCase [
	^ aTestCase
		insertStatementWithArgs: self
		before: aTestCase statements size + 1
]

{ #category : #accessing }
SConstructorStatement >> isConstructor [
	^ true.
]

{ #category : #printing }
SConstructorStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self theClassName.
	aStream nextPutAll: ' '.
	self args size = 0
		ifTrue: [ aStream nextPutAll: self selector ]
		ifFalse: [ (self selector substrings: ':')
				with: self args
				do: [ :selectorPart :arg | 
					aStream nextPutAll: selectorPart.
					aStream nextPutAll: ': '.
					aStream nextPutAll: arg ] ].
	aStream nextPut: $.
]

{ #category : #mutation }
SConstructorStatement >> repairOn: aTestCase changing: aStatement [
	| collection |
	self varName = aStatement varName
		ifFalse: [ ^ #() ].
	collection := STransformValue changeArgsOf: self using: aTestCase.
	(aTestCase statementAt: self varName) args: collection first.
	^ collection second
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
			^ collection second]
		ifFalse: [ ^ #() ]
]

{ #category : #accessing }
SConstructorStatement >> selector [
	^ selector
]

{ #category : #accessing }
SConstructorStatement >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
SConstructorStatement >> theClassName [
	^ theClassName
]

{ #category : #accessing }
SConstructorStatement >> theClassName: anObject [
	theClassName := anObject
]
