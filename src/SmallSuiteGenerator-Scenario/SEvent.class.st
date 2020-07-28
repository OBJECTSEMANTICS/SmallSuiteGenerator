"
SEVent is a proof class created to test project functionality

Instance Variables
	discount:		<Object>
	price:			<Object>
"
Class {
	#name : #SEvent,
	#superclass : #SObject,
	#instVars : [
		'discount',
		'price'
	],
	#category : #'SmallSuiteGenerator-Scenario'
}

{ #category : #'instance creation' }
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

{ #category : #accessing }
SEvent >> price: aNumber [
	price := aNumber
]
