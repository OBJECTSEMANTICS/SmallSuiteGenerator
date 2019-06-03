Extension { #name : #Number }

{ #category : #'*SmallSuiteGenerator' }
Number >> mutateToChange [
	^ self perform: #(#+ #- #*) atRandom with: (1 to: 100) atRandom
]
