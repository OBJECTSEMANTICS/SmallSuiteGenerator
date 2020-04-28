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
SGARouletteSelection >> selectOf: aCollection [ 
	^ self selectOf: aCollection with: (aCollection collect: #fitness)
]

{ #category : #selection }
SGARouletteSelection >> selectOf: aCollection with: probability [
	| roulette random |
	roulette := self createRouletteWith: probability .
	random := self next.
	1 to: (aCollection size) do: [ :index |
		(random < (roulette at: index)) ifTrue: [ 
			^ aCollection at: index ] ].
	^ nil
]
