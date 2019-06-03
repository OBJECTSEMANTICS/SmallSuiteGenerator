Extension { #name : #Character }

{ #category : #'*SmallSuiteGenerator' }
Character >> mutateToChange [ 
	^ Character value: (SAuxiliar randomValueCharacter: self)
]
