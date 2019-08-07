Extension { #name : #Character }

{ #category : #'*SmallSuiteGenerator' }
Character >> mutateToChange [
	|newValue interval|
	interval := 33 to: 127.
	newValue := interval atRandom.
	[ newValue == self asInteger ]
		whileTrue: [ newValue := interval atRandom ].
	^ Character value: newValue
]
