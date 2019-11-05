Class {
	#name : #SException,
	#superclass : #SObject,
	#classInstVars : [
		'nameException'
	],
	#category : #'SmallSuiteGenerator-Exceptions'
}

{ #category : #testing }
SException class >> canResolve: aException [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SException class >> signalerName: exception [
	^ [ exception signaler name ]
		on: MessageNotUnderstood
		do: [ exception signaler className asSymbol ]
]

{ #category : #'as yet unclassified' }
SException class >> solve: aException of: aTestCase [
	^ self subclasses
		detect: [ :subClass | subClass solveException: aException of: aTestCase ]
		ifFound: [ true ]
		ifNone: [  false ]
]

{ #category : #'as yet unclassified' }
SException class >> solveException: aException of: aTestCase [
	^ self subclassResponsibility 
]
