Class {
	#name : #SGARouletteSelection,
	#superclass : #SGASelection,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'as yet unclassified' }
SGARouletteSelection >> createRouletteWith: probability [ 
	| sum roulette |
	sum := probability sum.
	roulette := probability collect: [ :e | e/sum ].
	2 to: probability size do: [ :i | 
		roulette at: i put: (roulette at: (i-1)) + (roulette at: i) 
	].
	^ roulette 
]

{ #category : #'as yet unclassified' }
SGARouletteSelection >> selectOf: aCollection [ 
	^ self selectOf: aCollection with: (aCollection select: #fitness)
]

{ #category : #'as yet unclassified' }
SGARouletteSelection >> selectOf: aCollection with: probability [
	| roulette random |
	roulette := self createRouletteWith: probability .
	random := randomGenerator next.
	1 to: (aCollection size) do: [ :index |
		(random < (roulette at: index)) ifTrue: [ 
			^ aCollection at: index ] ].
	^ nil
]
