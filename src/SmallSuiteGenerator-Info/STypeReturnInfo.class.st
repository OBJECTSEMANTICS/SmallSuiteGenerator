Class {
	#name : #STypeReturnInfo,
	#superclass : #STypeObjectInfo,
	#instVars : [
		'types'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #'instance creation' }
STypeReturnInfo class >> new: aType [
	^ self new type: aType
]

{ #category : #comparing }
STypeReturnInfo >> = otherType [
	^ types includes: otherType
]

{ #category : #copying }
STypeReturnInfo >> copy [
	| copy |
	copy := self class instance.
	types do: [ :aType | copy type: aType ].
	^ copy
]

{ #category : #initialization }
STypeReturnInfo >> initialize [
	types := Set new
]

{ #category : #'as yet unclassified' }
STypeReturnInfo >> joinWith: otherTypeReturn [
	otherTypeReturn types do: [ :aType | self type: aType ]
]

{ #category : #accessing }
STypeReturnInfo >> type [
	^ types ifEmpty: [nil] ifNotEmpty: [types asArray shuffle anyOne]
]

{ #category : #'accessing structure variables' }
STypeReturnInfo >> type: aClassName [
	aClassName ~= #nil ifTrue: [ 
	types add: aClassName]
]

{ #category : #accessing }
STypeReturnInfo >> types [ 	
	^ types
]
