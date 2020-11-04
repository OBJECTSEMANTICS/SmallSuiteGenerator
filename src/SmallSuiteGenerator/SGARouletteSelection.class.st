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
	sum > 0 ifTrue: [
	roulette := probability collect: [ :e | [e/sum] on: Error do: [ 0 ] ]]
ifFalse: [ roulette := (OrderedCollection ofSize: probability size) atAllPut: 1/(probability size); yourself ].
	2 to: probability size do: [ :i | 
		roulette at: i put: (roulette at: (i-1)) + (roulette at: i) 
	].
	^ roulette 
]

{ #category : #selection }
SGARouletteSelection >> selectJustOneOf: aCollection with: probabilities [
	| roulette random |
	
	roulette := self createRouletteWith: probabilities.
	random := self next.
	roulette doWithIndex: [ :probability :index |
		(random < probability) ifTrue: [ 
			^ aCollection at: index ] ].
	^ nil
]

{ #category : #selection }
SGARouletteSelection >> selectOf: aCollection [ 

	^ self selectOf: aCollection with: (aCollection collect: [:testCase | self fitnessFor: testCase ])
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
