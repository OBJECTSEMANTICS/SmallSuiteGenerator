Class {
	#name : #SEvent,
	#superclass : #SObject,
	#instVars : [
		'discount',
		'price'
	],
	#category : #'SmallSuiteGenerator-Scenario'
}

{ #category : #'as yet unclassified' }
SEvent class >> price: aNumber [
	^ self new price: aNumber
]

{ #category : #testing }
SEvent >> canRegister: aPerson [
	^ aPerson canRegister: self
]

{ #category : #accessing }
SEvent >> discount [
	^ discount
]

{ #category : #accessing }
SEvent >> discount: aNumber [
	price > 0 ifTrue: [ discount := aNumber ].
]

{ #category : #initialization }
SEvent >> initialize [
	price := 0.
	discount := 0
]

{ #category : #accessing }
SEvent >> price [ 
	^ price - ((discount * price)/100)
]

{ #category : #'as yet unclassified' }
SEvent >> price: aNumber [
	price := aNumber
]
