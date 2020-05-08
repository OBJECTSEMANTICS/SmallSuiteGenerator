"
SGARankSelection is responsible for select testCases randomly regardless of fitness
"
Class {
	#name : #SGARandomSelection,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #selection }
SGARandomSelection >> selectJustOneOf: aCollection with: probabilities [
	^ self random selectAtRandom: aCollection
]

{ #category : #selection }
SGARandomSelection >> selectOf: aCollection [ 
	^ self random collectAtRandom: aCollection
]
