"
SGARankSelection is responsible for select testCases randomly regardless of fitness
"
Class {
	#name : #SGARankSelection,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'as yet unclassified' }
SGARankSelection >> createRankOf: associations [ 
	| rank sortBlock |
	sortBlock := [ :a :b | a key < b key ].
	associations sort: sortBlock.
	rank := 0.
	^ (associations collect: [ :each | 
		rank := rank + 1.
		each value -> rank ]) sort: sortBlock
]

{ #category : #actions }
SGARankSelection >> fitnessFor: aTestCase [
	^ (aTestCase fitness at: fitness functionName) "values first"
]

{ #category : #selection }
SGARankSelection >> selectOf: aCollection [ 
	^ self selectOf: aCollection with: (aCollection collect: [:testCase | self fitnessFor: testCase ])
	"^ self random collectAtRandom: aCollection"
]

{ #category : #selection }
SGARankSelection >> selectOf: aCollection with: values [
	| rank indexValue |
	indexValue := 0.
	rank := (self createRankOf: (values collect: [:val | 
		indexValue := indexValue + 1.
		val -> indexValue ])) collect: #value.
	^ SGARouletteSelection new selectAllOf: aCollection with: rank
]
