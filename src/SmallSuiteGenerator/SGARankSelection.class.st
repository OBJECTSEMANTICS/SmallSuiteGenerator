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
	| sortedCollection rank |
	sortedCollection := associations sort: [ :a :b | a key < b key ].
	rank := 0.
	^ sortedCollection collect: [ :each | 
		rank := rank + 1.
		each value -> rank ]
]

{ #category : #'as yet unclassified' }
SGARankSelection >> createRankOf: collection with: associations [ 
	| sortedCollection |
	sortedCollection := associations sort: [ :a :b | a key < b key ].
	^ sortedCollection collect: [ :each | 
		each  ]
]

{ #category : #selection }
SGARankSelection >> selectOf: aCollection [ 
	^ self selectOf: aCollection with: (aCollection collect: [:testCase | (self fitnessFor: testCase) -> testCase ])
	"^ self random collectAtRandom: aCollection "
]

{ #category : #selection }
SGARankSelection >> selectOf: aCollection with: values [
	| rank roulette random indexValue |
	indexValue := 0.
	rank := self createRankOf: (values collect: [:val | 
		indexValue := indexValue + 1.
		indexValue -> val ]).
	roulette := SGARouletteSelection new selectOf: aCollection with: rank.
	random := self next.
	1 to: aCollection size do: [ :index |
		(random < (roulette at: index)) ifTrue: [ 
			^ aCollection at: index ] ].
	^ nil
]
