Extension { #name : #Number }

{ #category : #'*SmallSuiteGenerator-Extensions' }
Number >> mutateToChange [
	^ (self perform: #(#+ #- #*) atRandom with: (1 to: 100) atRandom) perform: #(#+ #-) atRandom with: 1
]
