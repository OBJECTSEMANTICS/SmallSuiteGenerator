"
SGARankSelection is responsible for select testCases based of their rank
"
Class {
	#name : #SGARankSelection,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SGARankSelection >> ranksOf: values [
	| indexValue |
	indexValue := 0.
	^ (self ranksWithIndexOf: (values collect: [:val | 
		indexValue := indexValue + 1.
		val -> indexValue ])) collect: #value.
]

{ #category : #actions }
SGARankSelection >> ranksWithIndexOf: associations [ 
	| rank sortBlock |
	sortBlock := [ :a :b | a key < b key ].
	associations sort: sortBlock.
	rank := 0.
	^ (associations collect: [ :each | 
		rank := rank + 1.
		each value -> rank ]) sort: sortBlock
]

{ #category : #selection }
SGARankSelection >> selectJustOneOf: aCollection with: probabilities [
	^ SGARouletteSelection new selectJustOneOf: aCollection with: (self ranksOf: probabilities)
]

{ #category : #selection }
SGARankSelection >> selectOf: aCollection [ 
	^ self selectOf: aCollection with: (aCollection collect: [:testCase | self fitnessFor: testCase ])
]

{ #category : #selection }
SGARankSelection >> selectOf: aCollection with: values [
	^ SGARouletteSelection new selectOf: aCollection with: (self ranksOf: values)
]
