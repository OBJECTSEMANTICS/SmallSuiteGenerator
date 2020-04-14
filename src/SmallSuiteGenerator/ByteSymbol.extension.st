Extension { #name : #ByteSymbol }

{ #category : #'*SmallSuiteGenerator' }
ByteSymbol >> mutateToChange [
	| interval stringCopy randomGenerator |
	"correct bug to some characters form the string correctly, e.g: $-> problem in a string"
	randomGenerator := SPlatform newRandomGenerator.
	interval := Character alphabet , $_ asString.
	stringCopy := self
		ifEmpty: [ '' ]
		ifNotEmpty: [ self copyFrom: 1 to: self size - 1 ].
	^ ((randomGenerator selectAtRandom: interval)
		asString , stringCopy
		,
			(randomGenerator selectAtRandom: interval) asString)
		asSymbol
]
