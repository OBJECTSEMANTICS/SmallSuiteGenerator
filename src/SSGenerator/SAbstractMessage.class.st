Class {
	#name : #SAbstractMessage,
	#superclass : #SExpression,
	#instVars : [
		'receiver',
		'selector',
		'args'
	],
	#category : #'SSGenerator-Nodes'
}

{ #category : #creation }
SAbstractMessage class >> args: aMethodTypeInfo with: statements [
	|assocs|
	assocs := (statements collect: [:stm | stm returnType -> stm variable]) shuffle.
	^ aMethodTypeInfo argTypes
		collect: [ :className | 
			assocs
				detect: [ :assoc | assoc key = className ]
				ifFound: [ :assoc | assoc value ]
				ifNone: [ self error: 'we could find an argument of type ' , className ] ]
]

{ #category : #accessing }
SAbstractMessage >> args [
	^ args
]

{ #category : #accessing }
SAbstractMessage >> args: anObject [
	args := anObject
]

{ #category : #accessing }
SAbstractMessage >> id [ 
	^ receiver id
]

{ #category : #initialization }
SAbstractMessage >> initialize [ 	
	args := #().
]

{ #category : #printing }
SAbstractMessage >> printOn: aStream [
	receiver printOn: aStream.
	aStream	nextPut: Character space.
	self printSelectors: aStream
]

{ #category : #printing }
SAbstractMessage >> printSelectors: aStream [
	args
		ifEmpty: [ aStream nextPutAll: self selector ]
		ifNotEmpty: [ | withColon |
			withColon := self selector includes: $:.
			(self selector substrings: ':')
				with: self args
				do: [ :selectorPart :arg | 
					aStream nextPutAll: selectorPart.
					withColon
						ifTrue: [ aStream nextPutAll: ': ' ].
					aStream nextPutAll: arg asString ] ].
	aStream nextPut: $.
]

{ #category : #accessing }
SAbstractMessage >> receiver [
	^ receiver
]

{ #category : #accessing }
SAbstractMessage >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
SAbstractMessage >> selector [
	^ selector
]

{ #category : #accessing }
SAbstractMessage >> selector: anObject [
	selector := anObject
]
