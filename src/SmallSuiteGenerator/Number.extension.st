Extension { #name : #Number }

{ #category : #'*SmallSuiteGenerator' }
Number >> mutateToChange [
	|randomGenerator|
	randomGenerator := SConfiguration newRandomGenerator.
	^ (self perform: (randomGenerator selectAtRandom: #(#+ #- #*))  with: (randomGenerator selectAtRandom: (1 to: 100) asArray) )
		perform: (randomGenerator selectAtRandom: #(#+ #-))
		with: 1
]
