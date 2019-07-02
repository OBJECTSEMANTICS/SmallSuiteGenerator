Class {
	#name : #STypeClassInfo,
	#superclass : #Object,
	#instVars : [
		'methods',
		'classMethods'
	],
	#category : #'SmallSuiteGenerator-Info'
}

{ #category : #private }
STypeClassInfo >> accessMessages [
	^ methods select: #isQuick
]

{ #category : #initialization }
STypeClassInfo >> initialize [ 
	methods := Dictionary new.
	classMethods := Dictionary new.
]

{ #category : #private }
STypeClassInfo >> messages [
	^ methods reject: #isQuick
]

{ #category : #'as yet unclassified' }
STypeClassInfo >> methodOf: aSelector [
	^ methods at: aSelector
]
