Extension { #name : #ByteSymbol }

{ #category : #'*SmallSuiteGenerator' }
ByteSymbol >> mutateToChange [
	| interval stringCopy |
	"correct bug to some characters form the string correctly, e.g: $-> problem in a string"
	interval := Character alphabet , $_ asString.
	stringCopy := self
		ifEmpty: [ '' ]
		ifNotEmpty: [ self copyFrom: 1 to: self size - 1 ].
	^ ((SPlatform randomGenerator selectAtRandom: interval)
		asString , stringCopy
		,
			(SPlatform randomGenerator selectAtRandom: interval) asString)
		asSymbol
]
