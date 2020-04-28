Extension { #name : #Character }

{ #category : #'*SmallSuiteGenerator' }
Character >> mutateToChange [
	| newValue interval |
	interval := (33 to: 127) asArray.
	newValue := SPlatform randomGenerator selectAtRandom: interval.
	[ newValue == self asInteger ]
		whileTrue: [ newValue := SPlatform randomGenerator selectAtRandom: interval ].
	^ Character value: newValue
]
