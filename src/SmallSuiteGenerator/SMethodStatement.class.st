Class {
	#name : #SMethodStatement,
	#superclass : #SStatement,
	#instVars : [
		'selector',
		'args',
		'receiverVarName'
	],
	#category : #'SmallSuiteGenerator-Statement'
}

{ #category : #accessing }
SMethodStatement >> args [
	^ args
]

{ #category : #accessing }
SMethodStatement >> args: anObject [
	args := anObject
]

{ #category : #printing }
SMethodStatement >> printOn: aStream [
	aStream nextPutAll: self varName.
	aStream nextPutAll: ' := '.
	aStream nextPutAll: self receiverVarName.
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
SMethodStatement >> receiverVarName [
	^ receiverVarName
]

{ #category : #accessing }
SMethodStatement >> receiverVarName: anObject [
	receiverVarName := anObject
]

{ #category : #accessing }
SMethodStatement >> selector [
	^ selector
]

{ #category : #accessing }
SMethodStatement >> selector: anObject [
	selector := anObject
]
