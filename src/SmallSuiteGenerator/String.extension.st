Extension { #name : #String }

{ #category : #'*SmallSuiteGenerator' }
String >> mutateToChange [
	| interval stringCopy randomGenerator |
	"correct bug to some characters form the string correctly, e.g: $-> problem in a string"
	randomGenerator := SConfiguration newRandomGenerator.
	interval := (41 to: 127) asArray.
	stringCopy := self
		ifEmpty: [ '' ]
		ifNotEmpty: [ self copyFrom: 1 to: self size - 1 ].
	^ ((Character value: (randomGenerator selectAtRandom: interval))
		printString , stringCopy
		,
			(Character value: (randomGenerator selectAtRandom: interval)) printString)
		printString
]
