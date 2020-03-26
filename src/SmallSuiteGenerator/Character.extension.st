Extension { #name : #Character }

{ #category : #'*SmallSuiteGenerator' }
Character >> mutateToChange [
	| newValue interval randomGenerator |
	randomGenerator := SConfiguration newRandomGenerator.
	interval := (33 to: 127) asArray.
	newValue := randomGenerator selectAtRandom: interval.
	[ newValue == self asInteger ]
		whileTrue: [ newValue := randomGenerator selectAtRandom: interval ].
	^ Character value: newValue
]
