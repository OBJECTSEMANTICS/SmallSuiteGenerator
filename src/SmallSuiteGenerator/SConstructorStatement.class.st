Class {
	#name : #SConstructorStatement,
	#superclass : #SStatement,
	#instVars : [
		'theClassName',
		'selector',
		'args'
	],
	#category : #'SmallSuiteGenerator-Statement'
}

{ #category : #accessing }
SConstructorStatement >> args [
	^ args
]

{ #category : #accessing }
SConstructorStatement >> args: anObject [
	args := anObject
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
