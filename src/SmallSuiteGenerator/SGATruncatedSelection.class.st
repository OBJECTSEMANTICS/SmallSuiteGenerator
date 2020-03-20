Class {
	#name : #SGATruncatedSelection,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'as yet unclassified' }
SGATruncatedSelection >> selectOf: aCollection descarting: aNumber [
	(aNumber < aCollection size)
		ifTrue: [ | newColl |
			newColl := (aCollection sort: [ :a :b | a fitness > b fitness ]) copyFrom: 1 to: (aCollection size - aNumber).
			^ randomGenerator selectAtRandom: newColl
		].
	^ nil
]
