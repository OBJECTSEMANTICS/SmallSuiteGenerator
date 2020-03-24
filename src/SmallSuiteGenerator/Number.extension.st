Extension { #name : #Number }

{ #category : #'*SmallSuiteGenerator' }
Number >> mutateToChange [
	|randomGenerator|
	randomGenerator := SConfiguration randomGenerator.
	^ (self perform: (randomGenerator selectAtRandom: #(#+ #- #*))  with: (randomGenerator selectAtRandom: (1 to: 100) asArray) )
		perform: (randomGenerator selectAtRandom: #(#+ #-))
		with: 1
]
