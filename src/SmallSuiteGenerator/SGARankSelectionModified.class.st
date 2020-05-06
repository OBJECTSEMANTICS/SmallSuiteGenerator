"
SGARankSelectionModified is responsible for select testCases based of their rank
"
Class {
	#name : #SGARankSelectionModified,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #actions }
SGARankSelectionModified >> createRankOf: associations [ 
	| rank sortBlock |
	sortBlock := [ :a :b | a key < b key ].
	associations sort: sortBlock.
	rank := 0.
	^ (associations collect: [ :each | 
		rank := rank + 1.
		each value -> rank ]) sort: sortBlock
]

{ #category : #selection }
SGARankSelectionModified >> selectOf: aCollection [ 
	^ self selectOf: aCollection with: (aCollection collect: [:testCase | self fitnessFor: testCase ])
]

{ #category : #selection }
SGARankSelectionModified >> selectOf: aCollection with: values [
	| rank indexValue |
	indexValue := 0.
	rank := (self createRankOf: (values collect: [:val | 
		indexValue := indexValue + 1.
		val -> indexValue ])) collect: #value.
	^ SGARouletteSelection new selectOf: aCollection with: rank
]
