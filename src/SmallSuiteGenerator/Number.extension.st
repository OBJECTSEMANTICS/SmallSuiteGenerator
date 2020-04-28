Extension { #name : #Number }

{ #category : #'*SmallSuiteGenerator' }
Number >> mutateToChange [
	^ (self perform: (SPlatform randomGenerator selectAtRandom: #(#+ #- #*))  with: (SPlatform randomGenerator selectAtRandom: (1 to: 100) asArray) )
		perform: (SPlatform randomGenerator selectAtRandom: #(#+ #-))
		with: 1
]
