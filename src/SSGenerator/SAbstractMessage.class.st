Class {
	#name : #SAbstractMessage,
	#superclass : #SExpression,
	#instVars : [
		'receiver',
		'selector',
		'args'
	],
	#category : #SSGenerator
}

{ #category : #creation }
SAbstractMessage class >> args: aMethodTypeInfo with: statements [
	| args typeInfo |
	"typeInfo must send as parameter"
	^ aMethodTypeInfo argTypes
		collect: [ :className | 
			| stms |
			stms := statements shuffle detect: [ :stm | stm returnType = className ]
			ifFound: [ :stm | stm variable] ifNone: [ self error: 'we could find an argument of type ' , className  ]]
			thenDo: [ :variable | 
				aMethodTypeInfo typeInfo scalars at: variable returnType ifPresent: [ :values | values shuffle first ] ifAbsent: [ self error: 'Error to generate args' ]
				
				 ]
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
	self stringBody: aStream
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

{ #category : #printing }
SAbstractMessage >> stringBody: aStream [
	args
		ifEmpty: [ aStream nextPutAll: self selector ]
		ifNotEmpty: [ | withColon |
			withColon := self selector includes: $:.
			(self selector substrings: ':')
				with: self args
				do: [ :selectorPart :arg | 
					aStream nextPutAll: selectorPart.
					withColon
						ifTrue: [ aStream nextPutAll: ':' ].
					aStream nextPutAll: arg asString ] ].
	aStream nextPut: $.
]
