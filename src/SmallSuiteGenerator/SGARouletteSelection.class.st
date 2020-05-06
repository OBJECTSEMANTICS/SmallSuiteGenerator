"
SGARoulleteSelection is responsible for select testCases, gives more probaility of be selected when a testCase has more fitness
"
Class {
	#name : #SGARouletteSelection,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #creating }
SGARouletteSelection >> createRouletteWith: probability [ 
	| sum roulette |
	sum := probability sum.
	roulette := probability collect: [ :e | e/sum ].
	2 to: probability size do: [ :i | 
		roulette at: i put: (roulette at: (i-1)) + (roulette at: i) 
	].
	^ roulette 
]

{ #category : #selection }
SGARouletteSelection >> selectJustOneOf: aCollection with: probability [
	| roulette random |
	roulette := self createRouletteWith: probability .
	random := self next.
	1 to: (aCollection size) do: [ :index |
		(random < (roulette at: index)) ifTrue: [ 
			^ aCollection at: index ] ].
	^ nil
]

{ #category : #selection }
SGARouletteSelection >> selectOf: aCollection [ 
	^ self selectOf: aCollection with: (aCollection collect: [:testCase | self fitnessFor: testCase ])
	"^ self selectOf: aCollection with: (aCollection collect: #fitness)"
]

{ #category : #selection }
SGARouletteSelection >> selectOf: collection with: probability [
	| roulette random newCollection collectionSize indexes index |
	roulette := self createRouletteWith: probability.
	newCollection := OrderedCollection new.
	collectionSize := collection size.
	indexes := OrderedCollection new.
	[ newCollection size < collectionSize ] whileTrue: [ 
		random := self next.
		index := 0.
		roulette detect: [ :rv | 
			index := index + 1. 
			random < rv and: [ (indexes includes: index) not ] ] 
			ifFound: [ newCollection add: (collection at: index).
				indexes add: index ]
		].
	^ newCollection
]
